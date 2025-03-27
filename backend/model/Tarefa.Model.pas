unit Tarefa.Model;

interface

uses
  FireDAC.Comp.Client, FireDac.Stan.Param;

type
  TTarefa = class
  private
    FCODIGO: Integer;
    FCODIGO_USUARIO: Integer;
    FDESCRICAO: string;
  public
    property CODIGO: Integer read FCODIGO write FCODIGO;
    property CODIGO_USUARIO: Integer read FCODIGO_USUARIO write FCODIGO_USUARIO;
    property DESCRICAO: string read FDESCRICAO write FDESCRICAO;

    constructor Create;
    destructor Destroy; override;

    function Listar(out erro: string): TFDQuery;
    function Incluir(out erro: string): Boolean;
    function Excluir(out erro: string): Boolean;
    function Alterar(out erro: string): Boolean;
  end;

implementation

uses
  Config.Database, System.SysUtils;

{ TTarefa }

constructor TTarefa.Create;
begin
  config.database.Connect;
end;

destructor TTarefa.Destroy;
begin
  config.database.Disconect;
end;

function TTarefa.Alterar(out erro: string): Boolean;
var
  vQuery: TFDQuery;
begin

  if CODIGO <= 0 then
  begin
    Result := false;
    erro := 'escolha uma tarefa';
    exit;
  end;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      sql.Clear;
      SQL.Add('update tarefa set descricao = :descricao ');
      SQL.Add('where codigo = :codigo');
      ParamByName('codigo').Value := CODIGO;
      ParamByName('descricao').Value := DESCRICAO;
      ExecSQL;
    end;

    vQuery.Free;
    erro := '';
    result := true;

  except
    on e: Exception do
    begin
      erro := 'Erro ao alterar a tarefa: ' + e.Message;
      Result := false;
    end;
  end;
end;

function TTarefa.Excluir(out erro: string): Boolean;
var
  vQuery: TFDQuery;
begin
  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      sql.Clear;
      SQL.Add('delete from tarefa where codigo = :id');
      ParamByName('id').Value := CODIGO;
      ExecSQL;
    end;

    vQuery.Free;
    erro := '';
    result := true;

  except
    on e: exception do
    begin
      erro := 'Erro ao excluir a tarefa: ' + e.Message;
      Result := false;
    end;
  end;
end;

function TTarefa.Incluir(out erro: string): Boolean;
var
  vQuery: TFDQuery;
begin

  if Trim(DESCRICAO) = '' then
  begin
    Result := false;
    erro := 'Informe alguma descrição para a tarefa';
    exit;
  end;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      sql.Clear;
      SQL.Add('insert into tarefa (codigo_usuario, descricao) ');
      SQL.Add('values (:codigo_usuario, :descricao)');

      ParamByName('codigo_usuario').Value := CODIGO_USUARIO;
      ParamByName('descricao').Value := DESCRICAO;

      ExecSQL;

      Params.Clear;
      SQL.Clear;
      SQL.Add('select max(codigo) codigo from tarefa ');
      SQL.Add('where codigo_usuario = :codigo_usuario');
      ParamByName('codigo_usuario').Value := CODIGO_USUARIO;
      active := true;

      CODIGO := FieldByName('codigo').AsInteger;
    end;

    vQuery.Free;
    erro := '';
    result := true;

  except
    on e: exception do
    begin
      erro := 'Erro ao cadastrar tarefa: ' + e.Message;
      Result := false;
    end;
  end;
end;

function TTarefa.Listar(out erro: string): TFDQuery;
var
  vQuery: TFDQuery;
begin

  if CODIGO_USUARIO <= 0 then
  begin
    erro := 'Informe algum usuario para a tarefa';
    exit;
  end;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('select * from tarefa where 1 = 1');

      SQL.Add('and codigo_usuario = :codigo_usuario');
      ParamByName('codigo_usuario').Value := CODIGO_USUARIO;

      Active := true;
    end;

    erro := '';
    Result := vQuery;
  except
    on e: Exception do
    begin
      erro := 'Erro ao consultar tarefa: ' + e.Message;
      Result := nil;
    end;
  end;
end;

end.

