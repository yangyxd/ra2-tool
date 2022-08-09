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
    /// <summary>
    /// 钱基址
    /// </summary>
    MoneyBase: DWORD;
    /// <summary>
    /// 金钱偏移
    /// </summary>
    MoneyOffset: DWORD;
    /// <summary>
    /// 电力偏移
    /// </summary>
    DLOffset: DWORD;
    /// <summary>
    /// 电力负载偏移
    /// </summary>
    DLFZOffset: DWORD;
    /// <summary>
    /// 第一个选中对象基址
    /// </summary>
    SelBase: DWORD;
    /// <summary>
    /// 升3星偏移
    /// </summary>
    SelDJ: DWORD;
  end;
type
  TFRa2Tool = class(TForm)
    Button1: TButton;
    Label3: TLabel;
    Label4: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    ComboBox1: TComboBox;
    Label7: TLabel;
    lbMoney: TLabel;
    Label8: TLabel;
    lbDL: TLabel;
    Label10: TLabel;
    lbDLFZ: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
  private
    { Private declarations }
    Game: TYXDGame;
  public
    { Public declarations }
    function InitGame(cfg: TGameConfig): TYXDGame;
    procedure InitConfig(var cfg: TGameConfig; const Mode: Integer);
    procedure InitGameAddr(cfg: TGameConfig);

    procedure DoChangeGameData(Sender: TYXDMemItem; const cfg: TGameConfig; mode: Integer);
  end;
var
  FRa2Tool: TFRa2Tool;
implementation
{$R *.dfm}
var
  Configs: array [0..2] of TGameConfig;
procedure TFRa2Tool.Button1Click(Sender: TObject);
begin
  if Game.PID = 0 then begin
    MessageBox(Handle, '游戏没有运行！', PWideChar(Self.Caption), 48);
    Exit;
  end;
  Game.SendHotKey(VK_F9);
end;
procedure TFRa2Tool.ComboBox1Click(Sender: TObject);
var
  cfg: TGameConfig;
begin
  cfg := Configs[ComboBox1.ItemIndex];
  InitGameAddr(cfg);
  if not Button1.Focused then Button1.SetFocus;
end;

procedure TFRa2Tool.DoChangeGameData(Sender: TYXDMemItem;
  const cfg: TGameConfig; mode: Integer);
var
  lastAddr: DWORD;
  B: TBytes;
begin
  SetLength(B, 4);
  case mode of
    0:  // 升三星
      begin
        B[3] := $40;
        B[2] := $0;
        B[1] := $0;
        B[0] := $0;
      end;
    1: // 加血
      begin
        B[3] := $0;
        B[2] := $0;
        B[1] := $FF;
        B[0] := $DC;
      end;
    2: // 降血
      begin
        B[3] := $0;
        B[2] := $0;
        B[1] := $0;
        B[0] := $A;
      end;
  else
    Exit;
  end;

  lastAddr := 0;
  Sender.LoopData(80,
    function (Sender: TYXDMemItem; Index: Integer; ItemAddr: Cardinal): Boolean
    begin
      if (ItemAddr = 0) or (ItemAddr = lastAddr) then begin
        Result := False;
        Exit;
      end;
      lastAddr := ItemAddr;
      if mode = 0 then begin
        Sender.WriteData(ItemAddr + cfg.SelDJ, B);
      end else begin
        Sender.WriteData(ItemAddr + $6C, B);
        Sender.WriteData(ItemAddr + $70, B);
      end;
      Result := True;
    end);
end;

procedure TFRa2Tool.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(Configs) do
    InitConfig(Configs[i], i);
  ComboBox1.Items.Clear;
  for I := 0 to High(Configs) do
    ComboBox1.Items.Add(Configs[i].Name);
  ComboBox1.ItemIndex := 2;
  Game := InitGame(Configs[ComboBox1.ItemIndex]);
  InitGameAddr(Configs[ComboBox1.ItemIndex]);
end;
procedure TFRa2Tool.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Game);
end;
procedure TFRa2Tool.InitConfig(var cfg: TGameConfig; const Mode: Integer);
begin
  case Mode of
    0:
      begin
        cfg.Name := '红色警戒2';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Red Alert 2';
        cfg.MoneyBase := $A35DB4;
        cfg.MoneyOffset := $24C;
        cfg.DLOffset := $52D0;
        cfg.DLFZOffset := $52D4;
        cfg.SelBase := $A40C64;
        cfg.SelDJ := $11C;
      end;
    1: 
      begin
        cfg.Name := '尤里的复仇';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Yuri''s Revenge';
        cfg.MoneyBase := $A82CB4;
        cfg.MoneyOffset := $30C;
        cfg.DLOffset := $53A4;
        cfg.DLFZOffset := $53A8;
        cfg.SelBase := $A8DC24;
        cfg.SelDJ := $150;
      end;
    2: 
      begin
        cfg.Name := '尤里最新版';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Yuri''s Revenge';
        cfg.MoneyBase := $A83D4C;
        cfg.MoneyOffset := $30C;
        cfg.DLOffset := $53A4;
        cfg.DLFZOffset := $53A8;
        cfg.SelBase := $A8ECBC;
        cfg.SelDJ := $150;
      end;
  end;
end;

function TFRa2Tool.InitGame(cfg: TGameConfig): TYXDGame;
begin
  Result := TYXDGame.Create(Self);
  Result.SetGame(cfg.WndTitleName, cfg.WndClassName);
  Result.Start;
end;

procedure TFRa2Tool.InitGameAddr(cfg: TGameConfig);
begin
  Game.Clear;
  Game.Stop;
  // 金钱
  // Game.AddPath('['+cfg.MoneyBase+']+'+cfg.MoneyOffset);
  Game.AddNew(cfg.MoneyBase).Offset(cfg.MoneyOffset).SetOnListenerA(
    procedure (Sender: TYXDMemItem) begin
      lbMoney.Caption := IntToStr(Sender.AsDWORD);
    end
  )
  .SetHotKeyA(VK_F9,
    procedure (Sender: TYXDMemItem) begin
      Sender.AsDWORD := 500000;
    end
  );
  // 电力
  Game.AddNew(cfg.MoneyBase).Offset(cfg.DLOffset).SetOnListenerA(
    procedure (Sender: TYXDMemItem) begin
      lbDL.Caption := IntToStr(Sender.AsDWORD);
    end
  );
  // 电力负载
  Game.AddNew(cfg.MoneyBase).Offset(cfg.DLFZOffset).SetOnListenerA(
    procedure (Sender: TYXDMemItem) begin
      lbDLFZ.Caption := IntToStr(Sender.AsDWORD);
    end
  );

  // 升3星选中部队
  Game.AddNew(cfg.SelBase)
    .SetHotKeyA(VK_F10,
    procedure (o: TYXDMemItem) begin
      DoChangeGameData(o, cfg, 0);
    end
  );

  // 弱化选中部队
  Game.AddNew(cfg.SelBase)
    .SetHotKeyA(VK_F11,
    procedure (o: TYXDMemItem) begin
      DoChangeGameData(o, cfg, 2);
    end
  );

  // 强化选中部队
  Game.AddNew(cfg.SelBase)
    .SetHotKeyA(VK_F12,
    procedure (o: TYXDMemItem) begin
      DoChangeGameData(o, cfg, 1);
    end
  );

  Game.SetGame(cfg.WndTitleName, cfg.WndClassName);
  Game.PID := 0;
  Game.Start;
end;


end.
