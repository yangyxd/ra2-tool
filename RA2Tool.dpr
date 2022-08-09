program RA2Tool;
uses
  Forms,
  uMain in 'uMain.pas' {FRa2Tool},
  uGameMem in 'uGameMem.pas',
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}
begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Windows10 Dark');
  Application.Title := '红色警戒尤里的复仇修改器';
  Application.CreateForm(TFRa2Tool, FRa2Tool);
  Application.Run;
end.
