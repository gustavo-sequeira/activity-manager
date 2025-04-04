unit Usuario.Model;

interface

uses
  FireDAC.Comp.Client, Config.Database, FireDAC.Stan.Param, Data.DB;

type
  TUsuario = class
  private
    FCODIGO: Integer;
    FNOME: string;
    FLOGIN: string;
    FSENHA: string;
  public
    constructor Create;
    destructor Destroy; override;
    property CODIGO: Integer read FCODIGO write FCODIGO;
    property NOME: string read FNOME write FNOME;
    property LOGIN: string read FLOGIN write FLOGIN;
    property SENHA: string read FSENHA write FSENHA;

    function Logar(out erro: string): Boolean;
    function Incluir(out erro: string): Boolean;
    function Listar(order_by: string; out erro: string): TFDQuery;
  end;

implementation

uses
  System.JSON, System.SysUtils;

{ TUsuario }

function TUsuario.Logar(out erro: string): Boolean;
var
  vQuery: TFDQuery;
begin

  if LOGIN = '' then
  begin
    Result := false;
    erro := 'Informe o login do usu�rio';
    exit;
  end;

  if SENHA = '' then
  begin
    Result := false;
    erro := 'Informe a senha do usu�rio';
    exit;
  end;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin

      Params.Clear;
      SQL.Clear;
      SQL.Add('select codigo from usuario ');
      SQL.Add('where login = :login');
      SQL.Add(' and senha = :senha');
      ParamByName('login').Value := LOGIN;
      ParamByName('senha').Value := SENHA;
      Active := true;

      if IsEmpty then
        raise Exception.Create('Usu�rio inv�lido')
      else
        CODIGO := FieldByName('codigo').AsInteger;
    end;

    vQuery.Free;
    erro := '';
    result := true;

  except
    on e: Exception do
    begin
      erro := 'Erro ao localziar usuario: ' + e.Message;
      Result := false;
    end;
  end;
end;

constructor TUsuario.Create;
begin
  Config.Database.Connect;
end;

destructor TUsuario.Destroy;
begin
  Config.Database.Disconect;
end;

function TUsuario.Incluir(out erro: string): Boolean;
var
  vQuery: TFDQuery;
begin

  if NOME = '' then
  begin
    Result := false;
    erro := 'Informe o nome do usu�rio';
    exit;
  end;

  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      sql.Clear;
      SQL.Add('insert into usuario (nome, login, senha)');
      SQL.Add('values(:nome, :login, :senha)');

      ParamByName('nome').Value := NOME;
      ParamByName('login').Value := LOGIN;
      ParamByName('senha').Value := SENHA;

      ExecSQL;

      Params.Clear;
      SQL.Clear;
      SQL.Add('select codigo from usuario ');
      SQL.Add('where login = :login');
      ParamByName('login').Value := LOGIN;
      active := true;

      CODIGO := FieldByName('codigo').AsInteger;

    end;

    vQuery.Free;
    erro := '';
    result := true;

  except
    on e: Exception do
    begin
      erro := 'Erro ao cadastrar usuario: ' + e.Message;
      Result := false;
    end;
  end;
end;

function TUsuario.Listar(order_by: string; out erro: string): TFDQuery;
var
  vQuery: TFDQuery;
begin
  try
    vQuery := TFDQuery.Create(nil);
    vQuery.Connection := Config.Database.FConnection;

    with vQuery do
    begin
      Active := false;
      SQL.Clear;
      SQL.Add('select * from usuario ');

      if order_by = '' then
        SQL.Add('ORDER BY NOME')
      else
        SQL.Add('ORDER BY ' + order_by);

      Active := true;
    end;

    erro := '';
    Result := vQuery;
  except
    on ex: exception do
    begin
      erro := 'Erro ao consultar usuarios: ' + ex.Message;
      Result := nil;
    end;
  end;
end;

end.

