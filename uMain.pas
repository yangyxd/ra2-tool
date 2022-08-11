unit uMain;

interface

uses
  uGameMem, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls,
  Forms, Dialogs, StdCtrls, Vcl.ActnMan, Vcl.ActnColorMaps, Vcl.ExtCtrls;

type
  PGameConfig = ^TGameConfig;

  TNotifyEventA = reference to procedure(Sender: TYXDMemItem; cfg: PGameConfig);

  TGameConfig = record
    Name: string;
    WndClassName: string;
    WndTitleName: string;
    /// <summary>
    /// Ǯ��ַ
    /// </summary>
    MoneyBase: DWORD;
    /// <summary>
    /// ��Ǯƫ��
    /// </summary>
    MoneyOffset: DWORD;
    /// <summary>
    /// ���IDƫ��
    /// </summary>
    IDOffset: DWORD;
    /// <summary>
    /// ����ƫ��
    /// </summary>
    DLOffset: DWORD;
    /// <summary>
    /// ��������ƫ��
    /// </summary>
    DLFZOffset: DWORD;
    /// <summary>
    /// ��һ��ѡ�ж����ַ
    /// </summary>
    SelBase: DWORD;
    /// <summary>
    /// ѡ������ƫ��
    /// </summary>
    SelCount: DWORD;
    /// <summary>
    /// ��3��ƫ��
    /// </summary>
    SelDJ: DWORD;
    /// <summary>
    /// ѡ�е�λ����ƫ��
    /// </summary>
    SelOwnerOffset: DWORD;
    /// <summary>
    /// ѡ�е�λת��Callƫ��
    /// </summary>
    SelChoseOffset: DWORD;

    /// <summary>
    /// ����ʤ����ַ
    /// </summary>
    WinImmeAddr: DWORD;

    /// ���޵�����ַ
    WXDLCodeAddr: DWORD;
    WXDLCode_New: TBytes;
    WXDLCode_Src: TBytes;

    /// �洦�����ַ
    SCJCCodeAddr: DWORD;
    SCJCCode_New: TBytes;
    SCJCCode_Src: TBytes;

    /// ��ͼȫ��
    DTQKCodeAddr: DWORD;
    DTQKCall: TNotifyEventA;

    /// <summary>
    /// �״��ַ
    /// </summary>
    RadarBase: DWORD;
    RadarOffset: DWORD;

    // ���ٽ���ƫ��
    KSJCOffset: DWORD;
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
    Label13: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ComboBox1Click(Sender: TObject);
  private
    { Private declarations }
    Game: TYXDGame;
    function GetIsGameing: Boolean;
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
    // ���ٽ���
    procedure DoQuickBuild(Sender: TYXDMemItem; cfg: TGameConfig);
    // ����ʤ��
    procedure DoGameWinImme(Sender: TYXDMemItem; cfg: TGameConfig);
    // ��Ϊ�������
    procedure DoTobeGhost(Sender: TYXDMemItem; cfg: TGameConfig);
    property IsGameing: Boolean read GetIsGameing;
  end;

var
  FRa2Tool: TFRa2Tool;

implementation
{$R *.dfm}

var
  Configs: array[0..2] of TGameConfig;

type
  TAddrs = packed record
    Addr1: DWORD;
    Addr2: DWORD;
    Addr3: DWORD;
  end;

  PAddrs = ^TAddrs;

// ȫ��ͼ��������
procedure mapOpenAllCall(P: PDWORD); stdcall;
var
  BaseAddr: DWORD;
begin
  BaseAddr := P^;
  asm
        pushad
        mov     eax, BaseAddr
        mov     edx, [eax]
        mov     ecx, $0087F7E8
        push    edx
        mov     eax, $00577D90
        call    eax
        popad
  end;
end;

// ��λת����������
//		pushad
//		mov eax,0x00A8ECC8	//ѡ�е�λ����
//		mov eax,[eax]
//		cmp eax,0		//�Ƿ�ѡ�е�λ
//		je exit1
//		push 0  //
//		mov ebx,0x00A83D4C
//		mov eax,[ebx]
//		push eax
//		mov ebx,0x00A8ECBC
//		mov eax,[ebx]
//		mov ecx,[eax]
//		mov ebx,[ecx]
//		add ebx,0x3D4
//		mov ebx,[ebx]
//		call ebx
//		exit1:
//		popad
procedure nineChoseCall(P: PAddrs); stdcall;
var
  WJAddr: DWORD;  // ת��Ŀ����ҵ�ַ
  SelAddr: DWORD; // ѡ��λ��ַ
  ChoseOffset: DWORD; // ת��callƫ��
begin
  WJAddr := P^.Addr1;
  SelAddr := P^.Addr2;
  ChoseOffset := P^.Addr3;
  asm
        pushad
        push    WJAddr
        mov     ebx, SelAddr
        add     ebx, ChoseOffset
        mov     ebx, [ebx]
        call    ebx
        popad
  end;
end;

procedure TFRa2Tool.InitConfig(var cfg: TGameConfig; const Mode: Integer);
begin
  FillChar(cfg, SizeOf(cfg), 0);
  case Mode of
    0:
      begin
        cfg.Name := '��ɫ����2';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Red Alert 2';
        cfg.MoneyBase := $A35DB4;
        cfg.MoneyOffset := $24C;
        cfg.IDOffset := $30;
        cfg.DLOffset := $52D0;
        cfg.DLFZOffset := $52D4;
        cfg.SelBase := $A40C64;
        cfg.SelCount := $c;
        cfg.SelDJ := $11C;
        cfg.SelOwnerOffset := $1b4;
        cfg.SelChoseOffset := $378;
        cfg.WinImmeAddr := cfg.MoneyBase - $3;
      end;
    1:
      begin
        cfg.Name := '����ĸ���';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Yuri''s Revenge';
        cfg.MoneyBase := $A82CB4;
        cfg.MoneyOffset := $30C;
        cfg.IDOffset := $30;
        cfg.DLOffset := $53A4;
        cfg.DLFZOffset := $53A8;
        cfg.SelBase := $A8DC24;
        cfg.SelCount := $c;
        cfg.SelDJ := $150;
        cfg.SelOwnerOffset := $21C;
        cfg.SelChoseOffset := $3D4;
        cfg.WinImmeAddr := cfg.MoneyBase - $3;

        cfg.WXDLCodeAddr := $508D16;
        cfg.WXDLCode_New := [$83, $c2, $00, $90, $90, $90, $90, $90];
        cfg.WXDLCode_Src := [$03, $d0, $89, $96, $a8, $53, $00, $00];

        cfg.DTQKCodeAddr := $00656BE9;
        cfg.DTQKCall :=
          procedure(o: TYXDMemItem; cfg: PGameConfig)
          begin
            o.InjectCall(@mapOpenAllCall, @cfg.MoneyBase, SizeOf(DWORD));
          end;

        cfg.SCJCCodeAddr := $4ABAAC;
        cfg.SCJCCode_New := [$90, $90, $90, $90, $90, $90, $8a, $85, $81, $11, $00, $00, $84, $c0, $90, $90, $90, $90, $90, $90];
        cfg.SCJCCode_Src := [$0f, $84, $c4, $01, $00, $00, $8a, $85, $81, $11, $00, $00, $84, $c0, $0f, $84, $b6, $01, $00, $00];

        cfg.KSJCOffset := $5378;
      end;
    2:
      begin
        cfg.Name := '�������°�';
        cfg.WndClassName := '';
        cfg.WndTitleName := 'Yuri''s Revenge';
        cfg.MoneyBase := $A83D4C;
        cfg.MoneyOffset := $30C;
        cfg.IDOffset := $30;
        cfg.DLOffset := $53A4;
        cfg.DLFZOffset := $53A8;
        cfg.SelBase := $A8ECBC;
        cfg.SelCount := $c;
        cfg.SelDJ := $150;
        cfg.SelOwnerOffset := $21C;
        cfg.SelChoseOffset := $3D4;
        cfg.WinImmeAddr := cfg.MoneyBase - $3;

        cfg.RadarBase := $A8B230;
        cfg.RadarOffset := $34A4;

        cfg.WXDLCodeAddr := $508D16;
        cfg.WXDLCode_New := [$83, $c2, $00, $90, $90, $90, $90, $90];
        cfg.WXDLCode_Src := [$03, $d0, $89, $96, $a8, $53, $00, $00];

        cfg.DTQKCodeAddr := $00656BE9;
        cfg.DTQKCall :=
          procedure(o: TYXDMemItem; cfg: PGameConfig)
          begin
            o.InjectCall(@mapOpenAllCall, @cfg.MoneyBase, SizeOf(DWORD));
          end;

        cfg.SCJCCodeAddr := $4ABAAC;
        cfg.SCJCCode_New := [$90, $90, $90, $90, $90, $90, $8a, $85, $81, $11, $00, $00, $84, $c0, $90, $90, $90, $90, $90, $90];
        cfg.SCJCCode_Src := [$0f, $84, $c4, $01, $00, $00, $8a, $85, $81, $11, $00, $00, $84, $c0, $0f, $84, $b6, $01, $00, $00];

        cfg.KSJCOffset := $5378;
      end;
  end;
end;

procedure TFRa2Tool.Button1Click(Sender: TObject);
begin
  if Game.PID = 0 then
  begin
    MessageBox(Handle, '��Ϸû�����У�', PWideChar(Self.Caption), 48);
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
  if not Button1.Focused then
    Button1.SetFocus;
end;

procedure TFRa2Tool.DoChangeGameData(Sender: TYXDMemItem; cfg: TGameConfig; mode: Integer);
var
  lastAddr, wjAddr: DWORD;
  selCount: Integer;
  B: TBytes;
  P: TAddrs;
begin
  wjAddr := 0;
  SetLength(B, 4);

  case mode of
    0:  // ������
      begin
        B[3] := $40;
        B[2] := $0;
        B[1] := $0;
        B[0] := $0;
      end;
    1: // ��Ѫ
      begin
        B[3] := $0;
        B[2] := $01;
        B[1] := $00;
        B[0] := $00;
      end;
    2: // ��Ѫ
      begin
        B[3] := $0;
        B[2] := $0;
        B[1] := $0;
        B[0] := $A;
      end;
    3: // ����ѡ�в���
      begin
        wjAddr := Sender.ReadDWORD(cfg.MoneyBase);
      end
  else
    Exit;
  end;

  lastAddr := 0;
  selCount := Sender.ReadInteger(Sender.BaseAddr + cfg.SelCount);
  Sender.LoopData(selCount,
    function(Sender: TYXDMemItem; Index: Integer; ItemAddr: Cardinal): Boolean
    begin
      if (ItemAddr = 0) or (ItemAddr = lastAddr) then
      begin
        Result := False;
        Exit;
      end;
      lastAddr := ItemAddr;
      if mode = 0 then
      begin
        Sender.WriteData(ItemAddr + cfg.SelDJ, B);
      end
      else if mode = 3 then
      begin
        if cfg.SelOwnerOffset > 0 then
        begin
          if Sender.ReadDWORD(ItemAddr + cfg.SelOwnerOffset) = wjAddr then
          begin
            P.Addr1 := wjAddr;
            P.Addr2 := ItemAddr;
            P.Addr3 := cfg.SelChoseOffset;
            Sender.InjectCall(@nineChoseCall, @P, SizeOf(P));
            // Sender.WriteData(ItemAddr + cfg.SelOwnerOffset, wjAddr);
          end;
        end;
      end
      else
      begin
        Sender.WriteData(ItemAddr + $6C, B);
        Sender.WriteData(ItemAddr + $70, B);
      end;
      Result := True;
    end);
end;

procedure TFRa2Tool.DoGameWinImme(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if IsGameing then
    Sender.AsByte := 1;
end;

procedure TFRa2Tool.DoMapOpenAll(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if (cfg.DTQKCodeAddr <> 0) and IsGameing then
  begin
    if cfg.DTQKCall <> nil then
    begin
      cfg.DTQKCall(Sender, @cfg);
    end;
  end;
end;

procedure TFRa2Tool.DoQuickBuild(Sender: TYXDMemItem; cfg: TGameConfig);
var
  I: Cardinal;
  Addr: DWORD;
begin
  if cfg.KSJCOffset = 0 then
    Exit;
  Addr := Sender.AsDWORD;
  if Addr = 0 then
    Exit;
  for I := 0 to 4 do
  begin
    Sender.WriteData(Addr + I * 4 + cfg.KSJCOffset, DWORD(15));
  end;
end;

procedure TFRa2Tool.DoSetSCJC(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if cfg.SCJCCodeAddr <> 0 then
  begin
    if Sender.Checked then
      Sender.WriteData(cfg.SCJCCodeAddr, cfg.SCJCCode_New)
    else
      Sender.WriteData(cfg.SCJCCodeAddr, cfg.SCJCCode_Src)
  end;
end;

procedure TFRa2Tool.DoSetWXDL(Sender: TYXDMemItem; cfg: TGameConfig);
begin
  if cfg.WXDLCodeAddr <> 0 then
  begin
    if Sender.Checked then
      Sender.WriteData(cfg.WXDLCodeAddr, cfg.WXDLCode_New)
    else
      Sender.WriteData(cfg.WXDLCodeAddr, cfg.WXDLCode_Src)
  end;
end;

//
//	DWORD dat1,dat2;
//	readMemory(0x00A8ECC8,&dat1);	//ѡ������
//	if(dat1 != 1)		//����ѡ��һ������
//		return FALSE;
//
//	DWORD address[3] = {0x00A8ECBC,0,0};
//	readMemory(address,3,&dat1);		//ѡ�е�λ�׵�ַ
//	if(dat1 != 0x007E3EBC)		//����ѡ��һ������
//		return FALSE;
//
//	address[2] = 0x21C;		//��λ����
//	readMemory(address,3,&dat1);		//ѡ�е�λ����
//	readMemory(0x00A83D4C,&dat2);		//������ݻ�ַ
//	if(dat1 != dat2)		//����ѡ����ҵ�λ
//		return FALSE;
//	//����������ʼת��
//	DWORD PlayerID[2] = {0x00A83D4C,0x30};
//	readMemory(PlayerID,2,&dat1);		//��ȡ��ҵ�ǰID
//	if(dat1 != 0)		//ת�Ƶ�����ID
//		dat1--;
//	else
//		dat1++;
//
//	DWORD AimID[2] = {0x00A8022C,4*dat1};	//Ŀ����һ�ַ
//	readMemory(AimID,2,&dat2);		//��ȡĿ��������ݻ�ַ
//	readAddress(address,3,&dat1);		//ѡ�е�λ�����洢��ַ
//	writeMemory(dat1,dat2);		//ת��
//
//	//address[2] = 0x6C;		//��λѪ��
//	//readAddress(address,3,&dat1);		//ѡ�е�λѪ���洢��ַ
//	//writeMemory(dat1,0);		//����ѡ�еĽ�����
//
//	//ɾ��ѡ�е�λ
//	writProcess(DeleteThis_Assemble);
//
//	return TRUE;
procedure TFRa2Tool.DoTobeGhost(Sender: TYXDMemItem; cfg: TGameConfig);
var
  v, selAddr, wjAddr, id, destAddr: DWORD;
begin
  if not IsGameing then
    Exit;
  // ����ѡ��һ������
  if Sender.ReadInteger(Sender.BaseAddr + cfg.SelCount) <> 1 then
    Exit;
  // ����ѡ��һ������
  selAddr := Sender.GetAddress([Sender.AsDWORD, 0]);
  v := Sender.GetAddress([selAddr, 0]);
  if v <> $7E3EBC then
    Exit;
  
  // ����ѡ����ҵ�λ
  wjAddr := Sender.ReadDWORD(cfg.MoneyBase);
  if Sender.ReadDWORD(selAddr + cfg.SelOwnerOffset) <> wjAddr then
    Exit;
 

  // ת�Ƶ�����ID
  id := Sender.ReadDWORD(wjAddr + cfg.IDOffset);
  if id > 0 then
    Dec(id)
  else
    Inc(id);

  // ��ȡĿ��������ݻ�ַ
  destAddr := Sender.GetAddress([$A8022C, 4 * id]);

  // ��Ѫ
  DoChangeGameData(Sender, cfg, 2);
  
  // ת�Ƹ�Ŀ�����
  Sender.WriteData(selAddr + cfg.SelOwnerOffset, destAddr);
end;

procedure TFRa2Tool.FormCreate(Sender: TObject);
var
  I: Integer;
begin
  for I := 0 to High(Configs) do
    InitConfig(Configs[I], I);
  ComboBox1.Items.Clear;
  for I := 0 to High(Configs) do
    ComboBox1.Items.Add(Configs[I].Name);
  ComboBox1.ItemIndex := 2;
  Game := InitGame(Configs[ComboBox1.ItemIndex]);
  InitGameAddr(Configs[ComboBox1.ItemIndex]);
end;

procedure TFRa2Tool.FormDestroy(Sender: TObject);
begin
  FreeAndNil(Game);
end;

function TFRa2Tool.GetIsGameing: Boolean;
begin
  Result := Label2.Caption = '��Ϸ��';
end;

function TFRa2Tool.IIF(Value: Boolean; const V1, V2: string): string;
begin
  if Value then
    Result := V1
  else
    Result := V2;
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
  Label12.Enabled := cfg.KSJCOffset > 0;
  Label13.Enabled := cfg.DTQKCodeAddr > 0;

  // ��Ϸ״̬���
  Game.AddNew(cfg.MoneyBase).SetOnListenerA(
    procedure(Sender: TYXDMemItem)
    begin
      if Sender.PID = 0 then
        Label2.Caption := 'δ����'
      else
        Label2.Caption := IIF(Sender.AsDWORD = 0, 'δ������Ϸ', '��Ϸ��');
      Label9.Caption := 'F6' + Char(9) + '�洦����' + IIF(Sender.Checked, '(����)', '');
    end).SetHotKeyA(VK_F6,
    procedure(o: TYXDMemItem)
    begin
      o.Checked := not o.Checked;
      // �洦���촦��
      DoSetSCJC(o, cfg);
    end);
  
  // ��Ǯ
  // Game.AddPath('['+cfg.MoneyBase+']+'+cfg.MoneyOffset);
  Game.AddNew(cfg.MoneyBase).Offset(cfg.MoneyOffset).SetOnListenerA(
    procedure(Sender: TYXDMemItem)
    begin
      lbMoney.Caption := IntToStr(Sender.AsDWORD);
    end).SetHotKeyA(VK_F9,
    procedure(Sender: TYXDMemItem)
    begin
      Sender.AsDWORD := 500000;
    end);
  
  // ����
  Game.AddNew(cfg.MoneyBase).Offset(cfg.DLOffset).SetOnListenerA(
    procedure(Sender: TYXDMemItem)
    begin
      lbDL.Caption := IntToStr(Sender.AsDWORD);
      Label1.Caption := 'F7' + Char(9) + '���޵���' + IIF(Sender.Checked, '(����)', '');
    end).SetHotKeyA(VK_F7,
    procedure(o: TYXDMemItem)
    begin
      o.Checked := not o.Checked;
      // ���޵�������
      DoSetWXDL(o, cfg);
    end).SetLockValue(99999);

  // ��������
  Game.AddNew(cfg.MoneyBase).Offset(cfg.DLFZOffset).SetOnListenerA(
    procedure(Sender: TYXDMemItem)
    begin
      lbDLFZ.Caption := IntToStr(Sender.AsDWORD);
    end);

  // ���ٽ���
  Game.AddNew(cfg.MoneyBase).SetHotKeyA(VK_F4,
    procedure(o: TYXDMemItem)
    begin
      DoQuickBuild(o, cfg);
    end);

  // ��ͼȫ��
  Game.AddNew(cfg.RadarBase).Offset(cfg.RadarOffset).SetHotKeyA(VK_F5,
    procedure(o: TYXDMemItem)
    begin
      DoMapOpenAll(o, cfg);
      o.Checked := not o.Checked;
    end).SetLockValue([$01, $01]);

  // ����ѡ�в���
  Game.AddNew(cfg.SelBase).SetHotKeyA(VK_F8,
    procedure(o: TYXDMemItem)
    begin
      DoChangeGameData(o, cfg, 3);
    end);

  // ��Ϊ�������
  Game.AddNew(cfg.SelBase).SetOptions([moHotKeyCtrl]).SetHotKeyA(VK_F1,
    procedure(o: TYXDMemItem)
    begin
      DoTobeGhost(o, cfg);
    end);

  // ��3��ѡ�в���
  Game.AddNew(cfg.SelBase).SetHotKeyA(VK_F10,
    procedure(o: TYXDMemItem)
    begin
      DoChangeGameData(o, cfg, 0);
    end);

  // ����ѡ�в���
  Game.AddNew(cfg.SelBase).SetHotKeyA(VK_F11,
    procedure(o: TYXDMemItem)
    begin
      DoChangeGameData(o, cfg, 2);
    end);

  // ǿ��ѡ�в���
  Game.AddNew(cfg.SelBase).SetHotKeyA(VK_F12,
    procedure(o: TYXDMemItem)
    begin
      DoChangeGameData(o, cfg, 1);
    end);

  // ����ʤ��
  Game.AddNew(cfg.WinImmeAddr).SetOptions([moHotKeyCtrl]).SetHotKeyA(VK_ESCAPE,
    procedure(o: TYXDMemItem)
    begin
      DoGameWinImme(o, cfg);
    end);

  Game.SetGame(cfg.WndTitleName, cfg.WndClassName);
  Game.PID := 0;
  Game.Start;
end;

end.

