unit uMain;
interface
uses
  uGameMem,
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Vcl.ActnMan, Vcl.ActnColorMaps, Vcl.ExtCtrls;

type
  TNotifyEventA = reference to procedure(Sender: TYXDMemItem);
  
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
    /// 选中数量偏移
    /// </summary>
    SelCount: DWORD;
    /// <summary>
    /// 升3星偏移
    /// </summary>
    SelDJ: DWORD;
    /// <summary>
    /// 选中单位所属偏移
    /// </summary>
    SelOwnerOffset: DWORD;


    /// 无限电力地址
    WXDLCodeAddr: DWORD;
    WXDLCode_New: TBytes;
    WXDLCode_Src: TBytes;

    /// 随处建造地址
    SCJCCodeAddr: DWORD;
    SCJCCode_New: TBytes;
    SCJCCode_Src: TBytes;

    /// 地图全开
    DTQKCodeAddr: DWORD;
    DTQKCode_New: TBytes;
    DTQKCode_Src: TBytes;
    DTQKCall: TNotifyEventA;
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
    Label1: TLabel;
    Label2: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
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
    function IIF(Value: Boolean; const V1, V2: string): string;

    procedure DoChangeGameData(Sender: TYXDMemItem; cfg: TGameConfig; mode: Integer);
    procedure DoSetWXDL(Sender: TYXDMemItem; cfg: TGameConfig);
    procedure DoSetSCJC(Sender: TYXDMemItem; cfg: TGameConfig);
    procedure DoMapOpenAll(Sender: TYXDMemItem; cfg: TGameConfig);
  end;
var
  FRa2Tool: TFRa2Tool;
implementation
{$R *.dfm}
var
  Configs: array [0..2] of TGameConfig;

  
procedure mapOpenAllCall(); stdcall;
var
  Address: pointer;
begin
  Address := Pointer($00577d90);
  asm
    pushad
    mov dword ptr ds:[$BAD3E8],1
    mov esi,$0087F7E8
    mov dword ptr ds:[esi+$14AC],$3
    mov ecx,$00a83d4c
    mov edx,dword ptr ds:[ecx+$21C]
    mov ecx,$0087F7E8
    push edx
    call Address
    popad
  end;
end;
  
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

procedure TFRa2Tool.DoChangeGameData(Sender: TYXDMemItem; cfg: TGameConfig; mode: Integer);
var
  lastAddr, wjAddr: DWORD;
  selCount: Integer;
  B: TBytes;
begin
  wjAddr := 0;
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
        B[2] := $01;
        B[1] := $00;
        B[0] := $00;
      end;
    2: // 降血
      begin
        B[3] := $0;
        B[2] := $0;
        B[1] := $0;
        B[0] := $A;
      end;
    3: // 控制选中部队
      begin
        wjAddr := Sender.ReadDWORD(cfg.MoneyBase);  
      end
  else
    Exit;
  end;

  lastAddr := 0;
  selCount := Sender.ReadInteger(Sender.BaseAddr + cfg.SelCount);
  Sender.LoopData(selCount,
    function (Sender: TYXDMemItem; Index: Integer; ItemAddr: Cardinal): Boolean
    begin
      if (ItemAddr = 0) or (ItemAddr = lastAddr) then begin
        Result := False;
        Exit;
      end;
      lastAddr := ItemAddr;
      if mode = 0 then begin
        Sender.WriteData(ItemAddr + cfg.SelDJ, B);
      end else if mode = 3 then begin
        if cfg.SelOwnerOffset > 0 then begin
          Sender.WriteData(ItemAddr + cfg.SelOwnerOffset, wjAddr);
        end;
      end else begin
        Sender.WriteData(ItemAddr + $6C, B);
        Sender.WriteData(ItemAddr + $70, B);
      end;
      Result := True;
    end);
end;

procedure TFRa2Tool.DoMapOpenAll(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if (cfg.DTQKCodeAddr <> 0) and (Label2.Caption = '游戏中') then begin
    if Sender.Checked then begin
      Sender.WriteData(cfg.DTQKCodeAddr, cfg.DTQKCode_New);
      if cfg.DTQKCall <> nil then begin
        cfg.DTQKCall(Sender);
      end;
    end else
      Sender.WriteData(cfg.DTQKCodeAddr, cfg.DTQKCode_Src)
  end;
end;

procedure TFRa2Tool.DoSetSCJC(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if cfg.SCJCCodeAddr <> 0 then begin
    if Sender.Checked then
      Sender.WriteData(cfg.SCJCCodeAddr, cfg.SCJCCode_New)
    else
      Sender.WriteData(cfg.SCJCCodeAddr, cfg.SCJCCode_Src)
  end;
end;

procedure TFRa2Tool.DoSetWXDL(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if cfg.WXDLCodeAddr <> 0 then begin
    if Sender.Checked then
      Sender.WriteData(cfg.WXDLCodeAddr, cfg.WXDLCode_New)
    else
      Sender.WriteData(cfg.WXDLCodeAddr, cfg.WXDLCode_Src)
  end;
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

function TFRa2Tool.IIF(Value: Boolean; const V1, V2: string): string;
begin
  if Value then Result := V1 else Result := V2;
end;

procedure TFRa2Tool.InitConfig(var cfg: TGameConfig; const Mode: Integer);
begin
  FillChar(cfg, SizeOf(cfg), 0);
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
        cfg.SelCount := $c;
        cfg.SelDJ := $11C;
        cfg.SelOwnerOffset := $1b4; 
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
        cfg.SelCount := $c;
        cfg.SelDJ := $150;
        cfg.SelOwnerOffset := $21C; 
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
        cfg.SelCount := $c;
        cfg.SelDJ := $150;
        cfg.SelOwnerOffset := $21C; 
        
        cfg.WXDLCodeAddr := $508D16;
        cfg.WXDLCode_New := [$83,$c2,$00,$90,$90,$90,$90,$90];
        cfg.WXDLCode_Src := [$03,$d0,$89,$96,$a8,$53,$00,$00];
        
        cfg.DTQKCodeAddr := $00656BE9;
        cfg.DTQKCode_New := [$90,$90];
        cfg.DTQKCode_Src := [$75,$5d];
        cfg.DTQKCall := procedure (o: TYXDMemItem)
          begin
            o.InjectCall(@mapOpenAllCall, nil, 0);  
          end;
        
        cfg.SCJCCodeAddr := $4ABAAC;
        cfg.SCJCCode_New := [
          $90,$90,$90,$90,$90,$90,
          $8a,$85,$81,$11,$00,$00,
          $84,$c0,
          $90,$90,$90,$90,$90,$90
        ];
        cfg.SCJCCode_Src := [
          $0f,$84,$c4,$01,$00,$00,
          $8a,$85,$81,$11,$00,$00,
          $84,$c0,
          $0f,$84,$b6,$01,$00,$00
        ];
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
  Label9.Enabled := cfg.SCJCCodeAddr > 0;
  Label1.Enabled := cfg.WXDLCodeAddr > 0;
  Label2.Enabled := cfg.DTQKCodeAddr > 0;

  // 游戏状态检测
  Game.AddNew(cfg.MoneyBase).SetOnListenerA(
    procedure (Sender: TYXDMemItem) begin
      if Sender.PID = 0 then
        Label2.Caption := '未开启'
      else
        Label2.Caption := IIF(Sender.AsDWORD = 0, '未进入游戏', '游戏中');
      Label9.Caption := 'F6'+Char(9)+'随处建造'+IIF(Sender.Checked, '(开启)', '');
    end
  ).SetHotKeyA(VK_F6,
    procedure (o: TYXDMemItem) begin
      o.Checked := not o.Checked;
      // 随处建造处理
      DoSetSCJC(o, cfg);
    end
  );
  
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
      Label1.Caption := 'F7'+Char(9)+'无限电力'+IIF(Sender.Checked, '(开启)', '');
    end
  ).SetHotKeyA(VK_F7,
    procedure (o: TYXDMemItem) begin
      o.Checked := not o.Checked;
      // 无限电力处理
      DoSetWXDL(o, cfg);
    end
  ).SetLockValue(99999);

  // 电力负载
  Game.AddNew(cfg.MoneyBase).Offset(cfg.DLFZOffset).SetOnListenerA(
    procedure (Sender: TYXDMemItem) begin
      lbDLFZ.Caption := IntToStr(Sender.AsDWORD);
    end
  );

  // 地图全开
  Game.AddNew().SetHotKeyA(VK_F5,
    procedure (o: TYXDMemItem) begin
      if not o.Checked then begin
        o.Checked := True;
        DoMapOpenAll(o, cfg);
      end;
    end
  );
  
  // 控制选中部队
  Game.AddNew(cfg.SelBase)
    .SetHotKeyA(VK_F8,
    procedure (o: TYXDMemItem) begin
      DoChangeGameData(o, cfg, 3);
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
