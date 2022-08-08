unit uMain;

interface

uses
  uGameMem,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ActnMan, Vcl.ActnColorMaps, Vcl.ExtCtrls;

type
  TGameConfig = record
    Name: string;
    WndClassName: string;
    WndTitleName: string;
    // 钱基址
    MoneyBase: string;
    // 金钱偏移
    MoneyOffset: string;
    // 电力偏移
    DLOffset: string;
    // 电力负载偏移
    DLFZOffset: string;
    // 第一个选中对象基址
    SelBase: string;
    // 升3星偏移
    SelDJ: string;
  end;

type
  TForm1 = class(TForm)
    Button1: TButton;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Label7: TLabel;
    lbMoney: TLabel;
    Timer1: TTimer;
    Label8: TLabel;
    lbDL: TLabel;
    Label10: TLabel;
    lbDLFZ: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
  private
    { Private declarations }
    Game: TYXDGame;
  public
    { Public declarations }
    function InitGame(cfg: TGameConfig): TYXDGame;
    procedure InitGameAddr(cfg: TGameConfig);
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

var
  Ra2Cfg: array [0..2] of TGameConfig;

procedure TForm1.Button1Click(Sender: TObject);
begin
  if Game.PID = 0 then begin
    MessageBox(0, '游戏没有运行！', PWideChar(Self.Caption), 48)
  end;
  Game.Open;
  Game.Items[0].AsDWORD := 500000;
  Game.Close;
end;

procedure TForm1.ComboBox1Click(Sender: TObject);
var
  cfg: TGameConfig;
begin
  cfg := Ra2Cfg[ComboBox1.ItemIndex];
  InitGameAddr(cfg);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  Ra2Cfg[0].Name := '红色警戒2';
  Ra2Cfg[0].WndClassName := '';
  Ra2Cfg[0].WndTitleName := 'Red Alert 2';
  Ra2Cfg[0].MoneyBase := '$A35DB4';
  Ra2Cfg[0].MoneyOffset := '$24C';
  Ra2Cfg[0].DLOffset := '$52D0';
  Ra2Cfg[0].DLFZOffset := '$52D4';
  Ra2Cfg[0].SelBase := '$A40C64';
  Ra2Cfg[0].SelDJ := '$11C';

  Ra2Cfg[1].Name := '尤里的复仇';
  Ra2Cfg[1].WndClassName := '';
  Ra2Cfg[1].WndTitleName := 'Yuri''s Revenge';
  Ra2Cfg[1].MoneyBase := '$A82CB4';
  Ra2Cfg[1].MoneyOffset := '$30C';
  Ra2Cfg[1].DLOffset := '$53A4';
  Ra2Cfg[1].DLFZOffset := '$53A8';
  Ra2Cfg[1].SelBase := '$A8DC24';
  Ra2Cfg[1].SelDJ := '$150';

  Ra2Cfg[2].Name := '尤里最新版';
  Ra2Cfg[2].WndClassName := '';
  Ra2Cfg[2].WndTitleName := 'Yuri''s Revenge';
  Ra2Cfg[2].MoneyBase := '$A83D4C';
  Ra2Cfg[2].MoneyOffset := '$30C';
  Ra2Cfg[2].DLOffset := '$53A4';
  Ra2Cfg[2].DLFZOffset := '$53A8';
  Ra2Cfg[2].SelBase := '$A8ECBC';
  Ra2Cfg[2].SelDJ := '$150';

  ComboBox1.Items.Clear;
  for I := 0 to High(Ra2Cfg) do
    ComboBox1.Items.Add(Ra2Cfg[i].Name);

  ComboBox1.ItemIndex := 2;
  Game := InitGame(Ra2Cfg[ComboBox1.ItemIndex]);
  InitGameAddr(Ra2Cfg[ComboBox1.ItemIndex]);
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Game);
end;

function TForm1.InitGame(cfg: TGameConfig): TYXDGame;
begin
  Result := TYXDGame.Create(True);
  Result.SetGame(cfg.WndTitleName, cfg.WndClassName);
  Result.Start;
end;

procedure TForm1.InitGameAddr(cfg: TGameConfig);
begin
  Game.Lock;
  try
    Game.Clear;
    Game.SetGame(cfg.WndTitleName, cfg.WndClassName);
    Game.PID := 0;
    // 金钱
    Game.AddPath('['+cfg.MoneyBase+']+'+cfg.MoneyOffset);
    // 电力
    Game.AddPath('['+cfg.MoneyBase+']+'+cfg.DLOffset);
    // 电力负载
    Game.AddPath('['+cfg.MoneyBase+']+'+cfg.DLFZOffset);
    // 升3星
    Game.AddPath('['+cfg.SelBase+']+'+cfg.DLFZOffset);
  finally
    Game.UnLock;
  end;
end;

procedure TForm1.Timer1Timer(Sender: TObject);
var
  Money, DL, DLFZ: Cardinal;
begin
  Money := 0;
  Game.Open;
  try
    Money := Game.Items[0].AsDWORD;
    if Money > $10000000 then Money := 0;
    DL := Game.Items[1].AsDWORD;
    DLFZ := Game.Items[2].AsDWORD;
  finally
    Game.Close;
  end;
  lbMoney.Caption := IntToStr(Money);
  lbDL.Caption := IntToStr(DL);
  lbDLFZ.Caption := IntToStr(DLFZ);
end;

end.
