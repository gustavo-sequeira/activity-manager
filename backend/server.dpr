program Server;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Usuario.Controller in 'Usuario.Controller.pas',
  Usuario.Model in 'model\Usuario.Model.pas',
  Config.Database in 'Config.Database.pas',
  System.JSON,
  Tarefa.Model in 'model\Tarefa.Model.pas';

begin
  THorse.Use(Jhonson());
  Usuario.Controller.Registry;

  THorse.Listen(9000);

end.

