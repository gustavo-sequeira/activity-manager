program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Horse.CORS,
  Usuario.Controller in 'controller\Usuario.Controller.pas',
  Usuario.Model in 'model\Usuario.Model.pas',
  Config.Database in 'Config.Database.pas',
  System.JSON,
  Tarefa.Model in 'model\Tarefa.Model.pas',
  Tarefa.Controller in 'controller\Tarefa.Controller.pas';

begin

  HorseCORS.
    AllowedOrigin('*').
    AllowedCredentials(true).
    AllowedHeaders('*').
    AllowedMethods('*').
    ExposedHeaders('*');

  THorse.Use(CORS);
  THorse.Use(Jhonson());

  Usuario.Controller.Registry;
  Tarefa.Controller.Registry;

  THorse.Listen(9000);

end.

