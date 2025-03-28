unit Tarefa.Controller;

interface

uses
  Horse, System.JSON, System.SysUtils, Tarefa.Model, FireDAC.Comp.Client,
  Data.DB, DataSet.Serialize;

procedure Registry;

implementation

procedure Listar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vTarefa: TTarefa;
  vQuery: TFDQuery;
  vErro: string;
  vArrayTarefas: TJSONArray;
begin
  try
    vTarefa := TTarefa.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      vTarefa.CODIGO_USUARIO := Req.Params['id'].ToInteger;
      vQuery := vTarefa.Listar(vErro);

      if vQuery.IsEmpty then
        Res.Send(' ')
      else
      begin
        vArrayTarefas := vQuery.ToJSONArray();
        Res.Send<TJSONArray>(vArrayTarefas);
      end;
    except
      on e: Exception do
      begin
        Res.Send(e.Message).Status(404);
        exit;
      end;
    end;

  finally
    vQuery.Free;
    vTarefa.Free;
  end;
end;

procedure Incluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vTarefa: TTarefa;
  vJsonObject: TJSONObject;
  vErro: string;
  vBody: TJsonValue;
begin

  try
    vTarefa := TTarefa.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJsonValue;

      vTarefa.CODIGO_USUARIO := vBody.GetValue<Integer>('codigoUsuario', 0);
      vTarefa.DESCRICAO := vBody.GetValue<string>('descricao', '');
      vTarefa.Incluir(vErro);

      vBody.Free;

      if vErro <> '' then
        raise Exception.Create(vErro);

    except
      on e: Exception do
      begin
        Res.Send(e.Message).Status(400);
        exit;
      end;
    end;

    vJsonObject := TJSONObject.Create;
    vJsonObject.AddPair('codigo', vTarefa.CODIGO.ToString);

    Res.Send<TJSONObject>(vJsonObject).Status(201);
  finally
    vTarefa.Free;
  end;
end;

procedure Excluir(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vTarefa: TTarefa;
  vJsonObject: TJSONObject;
  vErro: string;
begin

  try
    vTarefa := TTarefa.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

    vTarefa.CODIGO := Req.Params['id'].ToInteger;
  try
    try
      if not vTarefa.Excluir(vErro) then
        raise Exception.Create(vErro);

    except
      on e: Exception do
      begin
        Res.Send(e.Message).Status(400);
        exit;
      end;
    end;

    vJsonObject := TJSONObject.Create;
    vJsonObject.AddPair('codigo', vTarefa.CODIGO.ToString);

    Res.Send<TJSONObject>(vJsonObject);
  finally
    vTarefa.Free;
  end;
end;

procedure Alterar(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vTarefa: TTarefa;
  vJsonObject: TJSONObject;
  vErro: string;
  vBody: TJsonValue;
begin

  try
    vTarefa := TTarefa.Create;
    vTarefa.CODIGO := Req.Params['id'].ToInteger;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJsonValue;


      vTarefa.DESCRICAO := vBody.GetValue<string>('descricao', '');
      vTarefa.Alterar(vErro);

      vBody.Free;

      if vErro <> '' then
        raise Exception.Create(vErro);

    except
      on ex: exception do
      begin
        Res.Send(ex.Message).Status(400);
        exit;
      end;
    end;

    vJsonObject := TJSONObject.Create;
    vJsonObject.AddPair('codigo', vTarefa.CODIGO.ToString);
    vJsonObject.AddPair('codigo_usuario', vTarefa.CODIGO_USUARIO.ToString);
    vJsonObject.AddPair('descricao', vTarefa.DESCRICAO);

    Res.Send<TJSONObject>(vJsonObject).Status(200);
  finally
    vTarefa.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/tarefa/usuario/:id', Listar);
  THorse.Post('/tarefa', Incluir);
  THorse.Put('/tarefa/:id', Alterar);
  THorse.Delete('/tarefa/:id', Excluir);
end;

end.

