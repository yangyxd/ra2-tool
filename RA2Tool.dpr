program RA2Tool;

uses
  Forms,
  uMain in 'uMain.pas' {Form1},
  uGameMem in 'uGameMem.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.Title := '��ɫ��������ĸ����޸���';
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
