unit Usuario.Controller;

interface

uses
  Horse, System.JSON, System.SysUtils, Usuario.Model, FireDAC.Comp.Client,
  DataSet.Serialize;

procedure AutenticarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure IncluirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure ListarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);

procedure Registry;

implementation

procedure AutenticarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vUsuario: TUsuario;
  vErro: string;
  vJsonObject: TJSONObject;
  vBody: TJSONValue;
begin
  try
    vUsuario := TUsuario.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  try
    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONValue;

      vUsuario.LOGIN := vBody.GetValue<string>('login', '');
      vUsuario.SENHA := vBody.GetValue<string>('senha', '');
      vUsuario.Autenticar(vErro);

      vBody.Free;

      if vErro <> '' then
        raise Exception.Create(vErro);
    except
      on e: Exception do
      begin
        Res.Send(e.Message).Status(404);
        Exit;
      end;
    end;

    vJsonObject := TJSONObject.Create;
    vJsonObject.AddPair('codigo', vUsuario.CODIGO.ToString);

    Res.Send<TJSONObject>(vJsonObject).Status(200);

  finally
    vUsuario.Free;
  end;
end;

procedure IncluirUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vUsuario: TUsuario;
  vErro: string;
  vJsonObject: TJSONObject;
  vBody: TJSONValue;
begin
  try
    vUsuario := TUsuario.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    Exit;
  end;

  try
    try
      vBody := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(Req.Body), 0) as TJSONValue;

      vUsuario.NOME := vBody.GetValue<string>('nome', '');
      vUsuario.LOGIN := vBody.GetValue<string>('login', '');
      vUsuario.SENHA := vBody.GetValue<string>('senha', '');
      vUsuario.Incluir(vErro);

      vBody.Free;

      if vErro <> '' then
        raise Exception.Create(vErro);
    except
      on e: Exception do
      begin
        Res.Send(e.Message).Status(500);
        Exit;
      end;
    end;

    vJsonObject := TJSONObject.Create;
    vJsonObject.AddPair('codigo', vUsuario.CODIGO.ToString);

    Res.Send<TJSONObject>(vJsonObject).Status(201);
  finally
    vUsuario.Free;
  end;
end;

procedure ListarUsuario(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
  vUsuario: TUsuario;
  vQuery: TFDQuery;
  vErro: string;
  vArrayUsuarios: TJSONArray;
begin
  try
    vUsuario := TUsuario.Create;
  except
    Res.Send('Erro ao conectar com o banco').Status(500);
    exit;
  end;

  try
    vQuery := vUsuario.Listar('', vErro);

    vArrayUsuarios := vQuery.ToJSONArray();

    Res.Send<TJSONArray>(vArrayUsuarios);

  finally
    vQuery.Free;
    vUsuario.Free;
  end;
end;

procedure Registry;
begin
  THorse.Get('/usuario', ListarUsuario);
  THorse.Get('/usuario/logar', AutenticarUsuario);
  THorse.Post('/usuario', IncluirUsuario);
end;

end.

