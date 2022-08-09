{*******************************************************}
{                                                       }
{       游戏内存读写锁定                                }
{                                                       }
{       版权所有 (C) 2012  YangYxd                      }
{                                                       }
{*******************************************************}
unit uGameMem;
interface
uses
  SyncObjs, ExtCtrls,
  Windows, SysUtils, Classes, Messages, Variants;
type
  {$IFNDEF UNICODE}
  SIZE_T = ULONG_PTR;
  {$ENDIF}
  /// <summary>
  /// 远程内存数据读写对象
  /// </summary>
  TYXDRemoteMem = class(TObject)
  private
    FPID: Cardinal;
    FBaseAddr: Cardinal;
    FTempDestAddr: Cardinal;
    FLevel: Integer;
    FChecked: Boolean;
    FInvalidAddr: Boolean;
    FTag: Integer;
    FHandle: Cardinal;
    FType: Word;
    FLength: Cardinal;
    FValueIsUnicode: Boolean;
    FOffsets: array of Cardinal;
    function GetCount: Integer;
    function GetOffsets(index: Integer): Cardinal;
    function GetDestAddr: Cardinal;
    function GetAsAnsiString(ALength: Cardinal): string;
    function GetAsByte: Byte;
    function GetAsBytes(ALength: Cardinal): TBytes;
    function GetAsDouble: Double;
    function GetAsDWORD: DWORD;
    function GetAsInteger: Integer;
    function GetAsSingle: Single;
    function GetAsWideString(ALength: Cardinal): string;
    function GetAsWord: Word;
    function GetAsInt64: Int64;
    function GetAsDateTime: TDateTime;
    function GetValue: Variant;
    procedure SetLevel(const Value: Integer);
    procedure SetOffsets(index: Integer; const Value: Cardinal);
    procedure SetAsAnsiString(ALength: Cardinal; const Value: string);
    procedure SetAsByte(const Value: Byte);
    procedure SetAsBytes(ALength: Cardinal; const Value: TBytes);
    procedure SetAsDateTime(const Value: TDateTime);
    procedure SetAsDouble(const Value: Double);
    procedure SetAsDWORD(const Value: DWORD);
    procedure SetAsInteger(const Value: Integer);
    procedure SetAsSingle(const Value: Single);
    procedure SetAsWideString(ALength: Cardinal; const Value: string);
    procedure SetAsWord(const Value: Word);
    procedure SetAsInt64(const Value: Int64);
    procedure SetValue(const Value: Variant);
  private
    function GetIsValid: Boolean; virtual;
    function GetDataPath: string; virtual;
    procedure SetDataPath(const Value: string); virtual;
    function GetPID: Cardinal; virtual;
    procedure SetPID(const Value: Cardinal); virtual;
    procedure UpdateLevel; virtual;
  protected
    procedure AssignTo(Dest: TObject); virtual; 
    procedure Open; virtual;
    procedure Close; virtual;
  public
    constructor Create(); virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Add(Value: Cardinal); virtual;
    procedure DeleteLast; virtual;
    procedure Delete(Index: Integer); virtual;
    procedure Clone(Dest: TYXDRemoteMem); virtual;
    procedure Assign(Source: TObject); virtual;
    /// <summary>
    /// 设置临时的目标地址，非0时直接使用此地址，不再根据偏移计算
    /// </summary>
    procedure SetTempDestAddr(const Addr: Cardinal);
    /// <summary>
    /// 清除临时目标地址
    /// </summary>
    procedure ClearTempDestAddr();

    /// <summary>
    /// 直接读取地址数据
    /// </summary>
    function ReadByte(const Addr: Cardinal): Byte;
    function ReadWORD(const Addr: Cardinal): WORD;
    function ReadDWORD(const Addr: Cardinal): DWORD;
    function ReadInteger(const Addr: Cardinal): Integer;
    function ReadInt64(const Addr: Cardinal): Int64;
    function ReadSingle(const Addr: Cardinal): Single;
    function ReadDobule(const Addr: Cardinal): Double;
    function ReadAnsiString(const Addr: Cardinal; const ALength: Cardinal): string;
    function ReadUnicodeString(const Addr: Cardinal; const ALength: Cardinal): string;
    function ReadBytes(const Addr: Cardinal; const ALength: Cardinal = 4): TBytes;

    /// <summary>
    /// 直接向指定地址 + 写数据
    /// </summary>
    procedure WriteData(const Addr: Cardinal; const Value: TBytes);

    property PID: Cardinal read GetPID write SetPID;
    property Handle: Cardinal read FHandle write FHandle;
    property BaseAddr: Cardinal read FBaseAddr write FBaseAddr;
    property DestAddr: Cardinal read GetDestAddr;
    property Offsets[index: Integer]: Cardinal read GetOffsets write SetOffsets;
    property Count: Integer read GetCount;
    /// <summary>
    /// 当前偏移级数
    /// </summary>
    property Level: Integer read FLevel write SetLevel;
    /// <summary>
    /// 当前地址是否有效
    /// </summary>
    property IsValid: Boolean read GetIsValid;
    /// <summary>
    /// 以字符串形式设置或返回当前读写的内存位置。 示例：[[[[$76AB6008]+$0]+$C]+$28]+$20
    /// </summary>
    property DataPath: string read GetDataPath write SetDataPath;
    /// <summary>
    /// 选中状态
    /// </summary>
    property Checked: Boolean read FChecked write FChecked;

    property Tag: Integer read FTag write FTag;
    property AsInteger: Integer read GetAsInteger write SetAsInteger;
    property AsDWORD: DWORD read GetAsDWORD write SetAsDWORD;
    property AsByte: Byte read GetAsByte write SetAsByte;
    property AsWORD: Word read GetAsWord write SetAsWord;
    property AsSingle: Single read GetAsSingle write SetAsSingle;
    property AsDouble: Double read GetAsDouble write SetAsDouble;
    property AsDateTime: TDateTime read GetAsDateTime write SetAsDateTime;
    property AsInt64: Int64 read GetAsInt64 write SetAsInt64;
    property AsAnsiString[ALength: Cardinal]: string read GetAsAnsiString write SetAsAnsiString;
    property AsUnicodeString[ALength: Cardinal]: string read GetAsWideString write SetAsWideString;
    property AsBytes[ALength: Cardinal]: TBytes read GetAsBytes write SetAsBytes;
    /// <summary>
    /// 设置在读写字符串时，是否以Unicode方式操作
    /// </summary>
    property ValueIsUnicode: Boolean read FValueIsUnicode write FValueIsUnicode;
    property Value: Variant read GetValue write SetValue;
  end;
  TYXDGameMem = class;
  TYXDGameThread = class;
  TYXDMemItem = class;

  TYXDMemEvent = procedure(Sender: TYXDMemItem) of object;
  TYXDMemEventA =  reference to procedure(Sender: TYXDMemItem);
  TYXDMemLoopCallBackA =  reference to function(Sender: TYXDMemItem; Index: Integer; Addr: Cardinal): Boolean;

  TYXDMemOption = (
    /// <summary>
    /// 允许重复触发热键
    /// </summary>
    moRepeatTriggerHotKey,
    /// <summary>
    /// 允许PID为0时触发热键
    /// </summary>
    moAllowZeroPID
  );

  TYXDMemOptions = set of TYXDMemOption;

  TYXDMemItem = class(TYXDRemoteMem)
  private
    FOwner: TYXDGameMem;
    FHotKey: Integer;
    FOptions: TYXDMemOptions;
    FHotKeyEvent: TYXDMemEvent;
    FHotKeyEventA: TYXDMemEventA;
    FOnListener: TYXDMemEvent;
    FOnListenerA: TYXDMemEventA;
    procedure SetPID(const Value: Cardinal); override;
  protected
    procedure Close; override;
    procedure Open; override;
    function DoListener(): Boolean;
  public
    constructor Create(AOwner: TYXDGameMem); reintroduce;
    // 增加一级偏移
    function Offset(const Value: Cardinal): TYXDMemItem;
    // 设置热键
    function SetHotKey(const Key: Integer; const Event: TYXDMemEvent = nil): TYXDMemItem;
    function SetHotKeyA(const Key: Integer; const Event: TYXDMemEventA = nil): TYXDMemItem;
    // 监听事件
    function SetOnListener(const event: TYXDMemEvent): TYXDMemItem;
    // 监听事件
    function SetOnListenerA(const event: TYXDMemEventA): TYXDMemItem;

    // 设置选择
    function SetOptions(const value: TYXDMemOptions): TYXDMemItem;

    /// <summary>
    /// 循环遍列内部数据
    /// <param name="MaxCount">最大循环次数</param>
    /// <param name="CallBack">回调事件，需要返回 true 才继续遍列</param>
    /// <param name="ItemOffset">列表项内存偏移，一般为4或4的倍数</param>
    /// <param name="FieldOffset">列表项字段值偏移</param>
    /// </summary>
    function LoopData(const MaxCount: Integer;
      const CallBack: TYXDMemLoopCallBackA;
      const FieldOffset: Cardinal = 0;
      const ItemOffset: Cardinal = 4): TYXDMemItem;

    // 热键
    property HotKey: Integer read FHotKey write FHotKey;
    // 选项
    property Options: TYXDMemOptions read FOptions write FOptions default [];
    property Owner: TYXDGameMem read FOwner write FOwner;
    property OnListener: TYXDMemEvent read FOnListener write FOnListener;
    property OnListenerA: TYXDMemEventA read FOnListenerA write FOnListenerA;
    property OnHotKeyEvent: TYXDMemEvent read FHotKeyEvent write FHotKeyEvent;
    property OnHotKeyEventA: TYXDMemEventA read FHotKeyEventA write FHotKeyEventA;
  end;
  /// <summary>
  /// 游戏内存读写对象
  /// </summary>
  TYXDGameMem = class(TObject)
  private
    FPID: Cardinal;
    FHandle: Cardinal;
    FItems: TList;
    FHotKeyRef: Integer;
    procedure SetPID(const Value: Cardinal);
    function GetItem(Index: Integer): TYXDMemItem;
    procedure SetItem(Index: Integer; const Value: TYXDMemItem);
    function GetCount: Integer;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Clear; virtual;
    procedure Add(Item: TYXDMemItem);
    procedure Delete(Index: Integer);
    procedure Remove(Index: Integer);
    procedure Open; virtual;
    procedure Close; virtual;
    function AddPath(const Value: string): TYXDMemItem;
    function AddNew: TYXDMemItem;
    function IndexOf(Item: TYXDMemItem): Integer;
    
    property PID: Cardinal read FPID write SetPID;
    property Items[Index: Integer]: TYXDMemItem read GetItem write SetItem;
    property Count: Integer read GetCount;
  end;
  /// <summary>
  /// 游戏处理线程　
  /// </summary>
  TYXDGameThread = class(TObject)
  private
    FTimer: TTimer;
    FGame: TYXDGameMem;
    FGmaeWnd: HWND;
    FLockValueInterval: Cardinal;
    FListenerInterval: Cardinal;
    FValues: array of Variant;
    FWndName: string;
    FClsName: string;
    function GetCount: Integer;
    function GetItem(Index: Integer): TYXDMemItem;
    function GetPID: Cardinal;
    procedure SetItem(Index: Integer; const Value: TYXDMemItem);
    procedure SetPID(const Value: Cardinal);
    function GetValue(Index: Integer): Variant;
    procedure SetValue(Index: Integer; const Value: Variant);
    procedure DoTimer(Sender: TObject);
  protected
    procedure Execute; virtual;
    procedure FindGame; virtual; abstract; 
    procedure ReadValueFormGame(Index: Integer);
    procedure WriteValueToGame(Index: Integer);
  public
    constructor Create(AOwner: TComponent);
    destructor Destroy; override;
    procedure AdjustPrivilege;     // 提升权限
    procedure SetGame(const WndName, ClsName: string);
    procedure Clear;
    procedure Open;
    procedure Close;
    procedure Start;
    procedure Stop;
    procedure Add(Item: TYXDMemItem);
    procedure Delete(Index: Integer);
    procedure Remove(Index: Integer);
    function FindGameWnd: HWND; virtual;
    function FindGamePID: Cardinal; virtual;
    function GetWndTitle(AHandle: HWND): string;
    function AddPath(const Path: string): TYXDMemItem; overload;
    function AddPath(const Path: string; const Value: Variant): TYXDMemItem; overload;
    function AddPath(const Path: string; const Value: Variant; IsUnicode: Boolean): TYXDMemItem; overload;
    function AddNew(const BaseAddr: DWORD = 0): TYXDMemItem;
    function IndexOf(Item: TYXDMemItem): Integer;
    property PID: Cardinal read GetPID write SetPID;
    property Items[Index: Integer]: TYXDMemItem read GetItem write SetItem;
    property Values[Index: Integer]: Variant read GetValue write SetValue;
    property Count: Integer read GetCount;
    property WndName: string read FWndName write FWndName;
    property ClsName: string read FClsName write FClsName;
    property GameWnd: HWND read FGmaeWnd write FGmaeWnd;
    /// <summary>
    /// 锁定值间隔时间
    /// </summary>
    property LockValueInterval: Cardinal read FLockValueInterval write FLockValueInterval;
    /// <summary>
    /// 监听值间隔时间
    /// </summary>
    property ListenerInterval: Cardinal read FListenerInterval write FListenerInterval;
  end;
  /// <summary>
  /// 游戏对象
  /// </summary>
  TYXDGame = class(TYXDGameThread)
  private
    FLastLock: Cardinal;
    FLastListener: Cardinal;
    FLastHotKey: Integer;
    /// <summary>
    /// 锁定 Checked = True 的 Item
    /// </summary>
    procedure LockValueProcess;
    /// <summary>
    /// 事件监听处理
    /// </summary>
    procedure ListinserProcess;
    /// <summary>
    /// 热键处理
    /// </summary>
    procedure HotKeyProcess(var IsOpen: Boolean; const Key: Integer = 0);
  protected
    procedure Execute; override;
    procedure FindGame; override;
  public
    /// 模拟按下热键
    procedure SendHotKey(Key: Integer);
    /// 是否按下某个热键
    function IsHotKey(const Key: Integer): Boolean;
  end;
implementation
const
  OffsetSize = SizeOf(Cardinal);
function ReadProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: SIZE_T; var t: Cardinal): BOOL;
var
  p: SIZE_T;
begin
  Result := Windows.ReadProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, p);
  t := p;
end;
function WriteProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer;
  nSize: SIZE_T; var t: Cardinal): BOOL;
var
  p: SIZE_T;
begin
  Result := Windows.WriteProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, p);
  t := p;
end;
function OpenProcessToken(ProcessHandle: THandle; DesiredAccess: DWORD;
  var TokenHandle: Cardinal): BOOL;
var
  p: THandle;
begin
  Result := Windows.OpenProcessToken(ProcessHandle, DesiredAccess, p);
  ToKenHandle := p;
end;

{ TYXDRemoteMem }
procedure TYXDRemoteMem.Add(Value: Cardinal);
begin
  SetLength(FOffsets, Count + 1);
  CopyMemory(@FOffsets[Count - 1], @Value, OffsetSize);
  UpdateLevel;
end;
procedure TYXDRemoteMem.Assign(Source: TObject);
begin
  if (Source <> nil) and (Source is TYXDRemoteMem) then
    TYXDRemoteMem(Source).AssignTo(Self);
end;
procedure TYXDRemoteMem.AssignTo(Dest: TObject);
begin
  if (Dest <> nil) and (Dest is TYXDRemoteMem) then
    TYXDRemoteMem(Dest).Clone(Self);
end;
procedure TYXDRemoteMem.Clear;
begin
  SetLength(FOffsets, 0);
  UpdateLevel;
end;
procedure TYXDRemoteMem.ClearTempDestAddr;
begin
  FTempDestAddr := 0;
end;

procedure TYXDRemoteMem.Clone(Dest: TYXDRemoteMem);
begin
  Dest.FBaseAddr := FBaseAddr;
  if Count > 0 then begin  
    SetLength(Dest.FOffsets, Count);
    CopyMemory(@Dest.FOffsets[0], @FOffsets[0], Count * OffsetSize);
  end else
    Dest.Clear;
  Dest.Level := Level;
  Dest.Tag := Tag;
  Dest.Checked := FChecked;
end;
procedure TYXDRemoteMem.Close;
begin
  if FHandle <> 0 then begin
    CloseHandle(FHandle);
    FHandle := 0;
  end;
end;
constructor TYXDRemoteMem.Create;
begin
  FHandle := 0;
  FTag := 0;
  FBaseAddr := 0;
  FChecked := False;
  FInvalidAddr := False;
  FType := varInteger;
  FLength := 0;
  UpdateLevel;
end;
destructor TYXDRemoteMem.Destroy;
begin
  Clear;
  inherited Destroy;
end;
procedure TYXDRemoteMem.DeleteLast;
begin
  if Count <= 0 then Exit;
  SetLength(FOffsets, Count - 1);
  UpdateLevel;
end;
procedure TYXDRemoteMem.Delete(Index: Integer);
begin
  if (Index < Count) and (Index >= 0) then begin
    CopyMemory(@FOffsets[index], @FOffsets[index + 1],
      (Count - index - 1) * OffsetSize);
    SetLength(FOffsets, Count - 1);
    UpdateLevel;
  end;
end;
function TYXDRemoteMem.GetAsAnsiString(ALength: Cardinal): string;
var
  t: Cardinal;
  s1: array of AnsiChar;
begin
  if FHandle = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(s1, ALength + 1);
  if not ReadProcessMemory(FHandle, pointer(DestAddr), @s1[0], ALength, t) then
    Result := ''
  else
    Result := string(PAnsiChar(s1));
end;
function TYXDRemoteMem.GetAsByte: Byte;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 1, t);
end;
function TYXDRemoteMem.GetAsBytes(ALength: Cardinal): TBytes;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    SetLength(Result, 0);
    Exit;
  end;
  SetLength(Result, ALength);
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result[0], ALength, t);
end;
function TYXDRemoteMem.GetAsDateTime: TDateTime;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 8, t);
end;
function TYXDRemoteMem.GetAsDouble: Double;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 8, t);
end;
function TYXDRemoteMem.GetAsDWORD: DWORD;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 4, t);
end;
function TYXDRemoteMem.GetAsInt64: Int64;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 8, t);
end;
function TYXDRemoteMem.GetAsInteger: Integer;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 4, t);
end;
function TYXDRemoteMem.GetAsSingle: Single;
var
  t: Cardinal;
begin
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 4, t);
end;
function TYXDRemoteMem.GetAsWideString(ALength: Cardinal): string;
var
  t: Cardinal;
  s1: array of WideChar;
begin
  if FHandle = 0 then begin
    Result := '';
    Exit;
  end;
  SetLength(s1, ALength + 1);
  if not ReadProcessMemory(FHandle, pointer(DestAddr), @s1[0], ALength * 2, t) then
    Result := ''
  else
    Result := string(PWideChar(s1));
end;
function TYXDRemoteMem.GetAsWord: Word;
var
  t: Cardinal;
begin
  if FHandle = 0 then begin
    Result := 0;
    Exit;
  end;
  ReadProcessMemory(FHandle, pointer(DestAddr), @Result, 2, t);
end;
function TYXDRemoteMem.GetCount: Integer;
begin
  Result := High(FOffsets) + 1;
end;
function TYXDRemoteMem.GetIsValid: Boolean;
var
  t: Cardinal;
begin
  if FInvalidAddr or (FHandle = 0) then begin
    if (FHandle <> 0) then begin
      if ReadProcessMemory(FHandle, pointer(FBaseAddr), @Result, 4, t) = False then begin
        Close;
        Open;
      end;
    end else
      Open;
    Result := FHandle > 0
  end else
    Result := True;  
end;
function TYXDRemoteMem.GetOffsets(index: Integer): Cardinal;
begin
  Result := FOffsets[index];
end;
function TYXDRemoteMem.GetPID: Cardinal;
begin
  Result := FPID;
end;
function TYXDRemoteMem.GetValue: Variant;
  function GetString: Variant;
  begin
    if ValueIsUnicode then
      Result := AsUnicodeString[FLength]
    else
      Result := AsAnsiString[FLength];
  end;
begin
  case FType of
    varNull: Exit;
    varByte: Result := AsByte;
    varWord: Result := AsWORD;
    varLongWord: Result := AsDWORD;
    varInteger: Result := AsInteger;
    varSingle: Result := AsSingle;
    varDouble: Result := AsDouble;
    varDate: Result := AsDateTime;
    varInt64: Result := AsInt64;
    varArray + varByte: Result := AsBytes[FLength];
    varString: Result := GetString;
  end;
end;
function TYXDRemoteMem.GetDataPath: string;
const
  HexHeader = '$';
var
  i: Integer;
begin
  Result := '[' + HexHeader + IntToHex(FBaseAddr, 2) + ']';
  if FLevel >= 0 then begin
    for I := 0 to FLevel - 1 do
      Result := '[' + Result + '+' + HexHeader  + IntToHex(FOffsets[i], 1) + ']';
    Result := Result + '+' + HexHeader  + IntToHex(FOffsets[FLevel], 1);
  end;
end;
function TYXDRemoteMem.GetDestAddr: Cardinal;
var
  t: Cardinal;
  i: Integer;
begin
  Result := 0;
  if FHandle = 0 then Exit;
  if FTempDestAddr <> 0 then begin
    Result := FTempDestAddr;
    Exit;
  end;
  if FLevel < 0 then    
    Result := FBaseAddr
  else
    if ReadProcessMemory(FHandle, pointer(FBaseAddr), @Result, 4, t) then begin
      for i := 0 to FLevel - 1 do
        if ReadProcessMemory(FHandle, pointer(Result + FOffsets[i]), @Result, 4, t) = False then begin
          Result := 0;
          FInvalidAddr := True;
          Exit;
        end;
      Result := Result + FOffsets[FLevel];
    end else begin
      FInvalidAddr := True;
      Close;
    end;
end;
procedure TYXDRemoteMem.Open;
begin
  if (FHandle = 0) and (PID > 0) then begin
    FHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
    if FHandle = 0 then
      PID := 0;
  end;
end;
function TYXDRemoteMem.ReadAnsiString(const Addr, ALength: Cardinal): string;
begin
  SetTempDestAddr(Addr);
  Result := AsAnsiString[ALength];
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadByte(const Addr: Cardinal): Byte;
begin
  SetTempDestAddr(Addr);
  Result := AsByte;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadBytes(const Addr, ALength: Cardinal): TBytes;
begin
  SetTempDestAddr(Addr);
  Result := AsBytes[ALength];
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadDobule(const Addr: Cardinal): Double;
begin
  SetTempDestAddr(Addr);
  Result := AsDouble;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadDWORD(const Addr: Cardinal): DWORD;
begin
  SetTempDestAddr(Addr);
  Result := AsDWORD;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadInt64(const Addr: Cardinal): Int64;
begin
  SetTempDestAddr(Addr);
  Result := AsInt64;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadInteger(const Addr: Cardinal): Integer;
begin
  SetTempDestAddr(Addr);
  Result := AsInteger;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadSingle(const Addr: Cardinal): Single;
begin
  SetTempDestAddr(Addr);
  Result := AsSingle;
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadUnicodeString(const Addr, ALength: Cardinal): string;
begin
  SetTempDestAddr(Addr);
  Result := AsUnicodeString[ALength];
  ClearTempDestAddr;
end;

function TYXDRemoteMem.ReadWORD(const Addr: Cardinal): WORD;
begin
  SetTempDestAddr(Addr);
  Result := AsWord;
  ClearTempDestAddr;
end;

procedure TYXDRemoteMem.SetAsAnsiString(ALength: Cardinal; const Value: string);
var
  t: Cardinal;
  tStr: AnsiString;
begin
  if FHandle = 0 then Exit;
  tStr := AnsiString(Value);
  if Integer(ALength) - Length(tStr) > 0 then begin
    SetLength(tStr, ALength);
    FillMemory(@tStr[Length(tStr)+1], Integer(ALength) - Length(tStr), 0);
  end;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @tStr[1], ALength, t);
end;
procedure TYXDRemoteMem.SetAsByte(const Value: Byte);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 1, t);
end;
procedure TYXDRemoteMem.SetAsBytes(ALength: Cardinal; const Value: TBytes);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value[0], High(Value)+1, t);
end;
procedure TYXDRemoteMem.SetAsDateTime(const Value: TDateTime);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 8, t);
end;
procedure TYXDRemoteMem.SetAsDouble(const Value: Double);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 8, t);
end;
procedure TYXDRemoteMem.SetAsDWORD(const Value: DWORD);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 4, t);
end;
procedure TYXDRemoteMem.SetAsInt64(const Value: Int64);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 8, t);
end;
procedure TYXDRemoteMem.SetAsInteger(const Value: Integer);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 4, t);
end;
procedure TYXDRemoteMem.SetAsSingle(const Value: Single);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 4, t);
end;
procedure TYXDRemoteMem.SetAsWideString(ALength: Cardinal; const Value: string);
var
  t: Cardinal;
  s: Integer;
  tStr: WideString;
begin
  if FHandle = 0 then Exit;
  tStr := WideString(Value);
  s := (Integer(ALength) - Length(tStr)) * 2;
  if s > 0 then begin
    SetLength(tStr, ALength);
    FillMemory(@tStr[Length(tStr)+1], s, 0);
  end;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @tStr[1], ALength * 2, t);
end;
procedure TYXDRemoteMem.SetAsWord(const Value: Word);
var
  t: Cardinal;
begin
  if FHandle = 0 then Exit;
  WriteProcessMemory(FHandle, Pointer(DestAddr), @Value, 2, t);
end;
procedure TYXDRemoteMem.SetLevel(const Value: Integer);
begin
  if (Value < Count) and (Value >= 0) then
    FLevel := Value
  else
    UpdateLevel;
end;
procedure TYXDRemoteMem.SetOffsets(index: Integer; const Value: Cardinal);
begin
  FOffsets[index] := Value;
end;
procedure TYXDRemoteMem.SetPID(const Value: Cardinal);
begin
  FPID := Value;
  Close;
end;
procedure TYXDRemoteMem.SetTempDestAddr(const Addr: Cardinal);
begin
  FTempDestAddr := Addr;
end;

procedure TYXDRemoteMem.SetValue(const Value: Variant);
  procedure SetString;
  var
    tmp: string;
  begin
    tmp := VarToStr(Value);
    FLength := Length(tmp);
    if ValueIsUnicode then
      AsUnicodeString[FLength] := tmp
    else
      AsAnsiString[FLength] := tmp
  end;
begin
  if IsValid = False then Exit;
  FType := VarType(Value);
  case FType of
    varNull: Exit;
    varByte: AsByte := Value;
    varWord: AsWORD := Value;
    varLongWord: AsDWORD := Value;
    varInteger: AsInteger := Value;
    varSingle: AsSingle := Value;
    varDouble: AsDouble := Value;
    varDate: AsDateTime := Value;
    varInt64: AsInt64 := Value;
    varArray + varByte:
      begin
        FLength := High(TBytes(Value))+1;
        AsBytes[FLength] := Value;
      end;
    varString: SetString;
  end;
end;
//[[[[$76AB6008]+$0]+$C]+$28]+$20
procedure TYXDRemoteMem.SetDataPath(const Value: string);
var
  sLen: Integer;
  function mLeftPos(SubChar: Char; sPos: Integer): Integer;
  var
    i: Integer;
  begin
    for i := sPos to sLen do
      if Value[i] = SubChar then begin
        Result := i; Exit;
      end;
    Result := -1;
  end;
  function mRightPos(SubChar: Char; sPos: Integer): Integer;
  var
    i: Integer;
  begin
    for i := sPos downto 1 do
      if Value[i] = SubChar then begin
        Result := i; Exit;
      end;
    Result := -1;
  end;
  function mMidStr(sPos, sCount: Integer): string;
  begin
    Result := Copy(Value, sPos, sCount);
  end;
var
  i, j, k: Integer;
begin
  k := 0;
  sLen := Length(Value);
  i := mLeftPos(']', 1);
  j := mRightPos('[', i);
  if (i < 0) and (j < 0) then begin
    FBaseAddr := StrToIntDef(Value, 0);
    Exit;
  end;
  try
    while i > 0 do begin
      if j > 0 then begin
        if k = 0 then begin
          Clear;
          FBaseAddr := StrToIntDef(mMidStr(j + 1, i - j - 1), 0);
        end else
          Add(StrToIntDef(mMidStr(j + 1, i - j - 1), 0));
        k := i;
        i := mLeftPos(']', i + 1);
        if (i < 0) and (k < sLen) then
          i := sLen + 1;
        j := mRightPos('+', i);
      end else
        Break;
    end;
  except
    on E: Exception do
      MessageBox(0, PChar(E.Message), 'Error', 48);
  end;
end;
procedure TYXDRemoteMem.UpdateLevel;
begin
  FLevel := Count - 1;
end;

procedure TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: TBytes);
begin
  if Length(Value) = 0 then Exit;
  SetTempDestAddr(Addr);
  AsBytes[Length(Value)] := Value;
  ClearTempDestAddr;
end;

{ TYXDMemItem }
procedure TYXDMemItem.Close;
begin
  if FOwner <> nil then
    FOwner.Close
  else inherited;
end;
constructor TYXDMemItem.Create(AOwner: TYXDGameMem);
begin
  FOwner := AOwner;
  FValueIsUnicode := False;
  FOptions := [];
  inherited Create;  
end;
function TYXDMemItem.DoListener: Boolean;
begin
  Result := False;
  if Assigned(FOnListenerA) then begin
    FOnListenerA(Self);
    Result := True;
  end else if Assigned(FOnListener) then begin
    FOnListener(Self);
    Result := True;
  end;
end;

function TYXDMemItem.LoopData(const MaxCount: Integer;
  const CallBack: TYXDMemLoopCallBackA; const FieldOffset,
  ItemOffset: Cardinal): TYXDMemItem;
var
  addr, itemAddr: Cardinal;
  I: Cardinal;
begin
  addr := AsDWORD;
  Result := Self;
  if addr = 0 then Exit;
  try
    for I := 0 to MaxCount - 1 do begin
      SetTempDestAddr(addr + I * ItemOffset);
      itemAddr := AsDWORD + FieldOffset;
      SetTempDestAddr(itemAddr);
      if not CallBack(Self, I, itemAddr) then
        Break;
    end;
  finally
    ClearTempDestAddr();
  end;
end;

function TYXDMemItem.Offset(const Value: Cardinal): TYXDMemItem;
begin
  Add(Value);
  Result := Self;
end;

function TYXDMemItem.SetHotKey(const Key: Integer; const Event: TYXDMemEvent): TYXDMemItem;
begin
  if FHotKey > 0 then
    Dec(FOwner.FHotKeyRef);
  if Key > 0 then
    Inc(FOwner.FHotKeyRef);
  FHotKey := Key;
  FHotKeyEvent := Event;
  Result := Self;
end;

function TYXDMemItem.SetHotKeyA(const Key: Integer; const Event: TYXDMemEventA): TYXDMemItem;
begin
  if FHotKey > 0 then
    Dec(FOwner.FHotKeyRef);
  if Key > 0 then
    Inc(FOwner.FHotKeyRef);
  FHotKey := Key;
  FHotKeyEventA := Event;
  Result := Self;
end;

function TYXDMemItem.SetOnListener(const event: TYXDMemEvent): TYXDMemItem;
begin
  FOnListener := event;
  Result := Self;
end;

function TYXDMemItem.SetOnListenerA(const event: TYXDMemEventA): TYXDMemItem;
begin
  FOnListenerA := event;
  Result := Self;
end;

function TYXDMemItem.SetOptions(const value: TYXDMemOptions): TYXDMemItem;
begin
  FOptions := Value;
  Result := Self;
end;

procedure TYXDMemItem.Open;
begin
  if FOwner <> nil then
    FOwner.Open
  else
    inherited;
end;
procedure TYXDMemItem.SetPID(const Value: Cardinal);
begin
  if FOwner <> nil then
    FOwner.PID := Value
  else
    inherited;
end;
{ TYXDGameMem }
procedure TYXDGameMem.Add(Item: TYXDMemItem);
begin
  FItems.Add(Item);
end;
function TYXDGameMem.AddNew: TYXDMemItem;
begin
  Result := TYXDMemItem.Create(Self);
  FItems.Add(Result); 
end;
function TYXDGameMem.AddPath(const Value: string): TYXDMemItem;
begin
  Result := AddNew;
  Result.DataPath := Value;
end;
procedure TYXDGameMem.Clear;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
    if Assigned(TObject(FItems[i])) then TObject(FItems[i]).Free;
  FItems.Clear;
end;
procedure TYXDGameMem.Close;
var
  i: Integer;
begin
  if FHandle <> 0 then begin
    CloseHandle(FHandle);
    FHandle := 0;
    for i := 0 to Count - 1 do
      Items[i].Handle := FHandle;
  end;
end;
constructor TYXDGameMem.Create;
begin
  FItems := TList.Create;
end;
procedure TYXDGameMem.Delete(Index: Integer);
begin
  if (Index >= 0) and (Index < FItems.Count) then begin
    if Assigned(TObject(FItems[Index])) then TObject(FItems[Index]).Free;
    FItems.Delete(Index);
  end;
end;
destructor TYXDGameMem.Destroy;
begin
  Clear;
  FItems.Free;
  inherited;
end;
function TYXDGameMem.GetCount: Integer;
begin
  Result := FItems.Count;
end;
function TYXDGameMem.GetItem(Index: Integer): TYXDMemItem;
begin
  Result := TYXDMemItem(FItems[index]);
end;
function TYXDGameMem.IndexOf(Item: TYXDMemItem): Integer;
begin
  Result := FItems.IndexOf(Item); 
end;
procedure TYXDGameMem.Open;
var
  i: Integer;
begin
  if (FHandle = 0) and (PID > 0) then begin
    FHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
    if FHandle = 0 then
      PID := 0;
    for i := 0 to Count - 1 do
      Items[i].Handle := FHandle;
  end;
end;
procedure TYXDGameMem.Remove(Index: Integer);
begin
  if (Index >= 0) and (Index < FItems.Count) then
    FItems.Delete(Index);
end;
procedure TYXDGameMem.SetItem(Index: Integer; const Value: TYXDMemItem);
begin
  if Assigned(TObject(FItems[Index])) then
    TObject(FItems[index]).Free;
  FItems[index] := Value;
end;
procedure TYXDGameMem.SetPID(const Value: Cardinal);
var
  i: Integer;
begin
  if FPID <> Value then begin
    FPID := Value;
    for i := 0 to Count - 1 do
      if Assigned(Items[i]) then begin
        Items[i].PID := Value;
        Items[i].DoListener();
      end;
  end;
end;
{ TYXDGameThread }
procedure TYXDGameThread.Add(Item: TYXDMemItem);
begin
  FGame.Add(Item);
  SetLength(FValues, Count); 
end;
function TYXDGameThread.AddNew(const BaseAddr: DWORD = 0): TYXDMemItem;
begin
  Result := FGame.AddNew;
  Result.BaseAddr := BaseAddr;
  SetLength(FValues, Count); 
end;
function TYXDGameThread.AddPath(const Path: string; const Value: Variant;
  IsUnicode: Boolean): TYXDMemItem;
begin
  Result := AddPath(Path, Value);
  if Result <> nil then Result.ValueIsUnicode := IsUnicode;
end;
function TYXDGameThread.AddPath(const Path: string;
  const Value: Variant): TYXDMemItem;
begin
  Result := AddPath(Path);
  if Count > 0 then  
    FValues[Count - 1] := Value;
end;
procedure TYXDGameThread.AdjustPrivilege;
var
  hdlProcessHandle: Cardinal;
  hdlTokenHandle: Cardinal;
  tmpLuid: Int64;
  tkp: TOKEN_PRIVILEGES;
  lBufferNeeded: TOKEN_PRIVILEGES;
begin
  try
    hdlProcessHandle := GetCurrentProcess();
    OpenProcessToken(hdlProcessHandle, Cardinal(TOKEN_ALL_ACCESS), hdlTokenHandle);
    LookupPrivilegeValue('', 'SeDebugPrivilege', tmpLuid);
    tkp.PrivilegeCount := 1;
    tkp.Privileges[0].Luid := tmpLuid;
    tkp.Privileges[0].Attributes := SE_PRIVILEGE_ENABLED;
    AdjustTokenPrivileges(hdlTokenHandle, False, tkp, SizeOf(TOKEN_PRIVILEGES), lBufferNeeded, hdlProcessHandle);
  except end;
end;
function TYXDGameThread.AddPath(const Path: string): TYXDMemItem;
begin
  Result := FGame.AddPath(Path);
  SetLength(FValues, Count);
end;
procedure TYXDGameThread.Clear;
begin
  FGame.Clear;
  SetLength(FValues, 0);
end;
procedure TYXDGameThread.Close;
begin
  FGame.Close;
end;
constructor TYXDGameThread.Create(AOwner: TComponent);
begin
  FTimer := TTimer.Create(AOwner);
  FTimer.OnTimer := DoTimer;
  FTimer.Interval := 20;
  FGame := TYXDGameMem.Create;
  FListenerInterval := 200;
  FLockValueInterval := 1000;
  AdjustPrivilege;
end;
procedure TYXDGameThread.Delete(Index: Integer);
begin
  FGame.Delete(Index);
  SetLength(FValues, Count);
end;
destructor TYXDGameThread.Destroy;
begin
  FreeAndNil(FGame);
  FreeAndNil(FTimer);
  inherited;
end;
procedure TYXDGameThread.DoTimer(Sender: TObject);
begin
  Execute;
end;

procedure TYXDGameThread.Execute;
begin
  inherited;  
end;
function TYXDGameThread.FindGamePID: Cardinal;
var
  tmpWnd: HWND;
begin
  tmpWnd := FindGameWnd;
  if tmpWnd > 0 then begin
    GetWindowThreadProcessId(tmpWnd, Result);
  end else
    Result := 0;
end;
function TYXDGameThread.FindGameWnd: HWND;
var
  i: Integer;
begin
  i := 0;
  if (FWndName = '') then Inc(i);
  if (FClsName = '') then Inc(i, 2);
  case i of
    0: Result := FindWindow(PChar(FClsName), PChar(FWndName));
    1: Result := FindWindow(PChar(FClsName), nil);
    2: Result := FindWindow(nil, PChar(FWndName));
  else
    Result := 0;
  end;
  if Result <> 0 then GameWnd := Result else GameWnd := 0;
end;
function TYXDGameThread.GetCount: Integer;
begin
  Result := FGame.Count;
end;
function TYXDGameThread.GetItem(Index: Integer): TYXDMemItem;
begin
  Result := FGame.Items[index];
end;
function TYXDGameThread.GetPID: Cardinal;
begin
  Result := FGame.PID;
end;
function TYXDGameThread.GetValue(Index: Integer): Variant;
begin
  Result := FValues[Index];
end;
function TYXDGameThread.GetWndTitle(AHandle: HWND): string;
  function GetLenStr(sLen: Integer): string;
  begin
    SetLength(Result, sLen);
    FillMemory(@Result[1], Length(Result), 0);
  end;
var
  i: Integer;
begin
  Result := '';
  // 获取内容长度
  i := GetWindowTextLength(AHandle);
  if i > 0 then begin
    GetWindowText(AHandle, PChar(GetLenStr(i)), i);
  end else begin
    i := SendMessage(AHandle, WM_GETTEXTLENGTH, 0, 0);
    if i > 0 then begin
      SendNotifyMessage(AHandle, WM_GETTEXT, i, NativeInt(GetLenStr(i)));
      if Length(Result) = 0 then
        SendNotifyMessage(AHandle, EM_GETPASSWORDCHAR, i, NativeInt(GetLenStr(i)));
    end;
  end;
end;
function TYXDGameThread.IndexOf(Item: TYXDMemItem): Integer;
begin
  Result := FGame.IndexOf(Item); 
end;
procedure TYXDGameThread.Open;
begin
  FGame.Open;
end;
procedure TYXDGameThread.ReadValueFormGame(Index: Integer);
begin
end;
procedure TYXDGameThread.Remove(Index: Integer);
begin
  FGame.Remove(Index); 
  SetLength(FValues, Count);
end;
procedure TYXDGameThread.SetGame(const WndName, ClsName: string);
begin
  FWndName := WndName;
  FClsName := ClsName;
end;
procedure TYXDGameThread.SetItem(Index: Integer; const Value: TYXDMemItem);
begin
  FGame.Items[Index] := Value;
end;
procedure TYXDGameThread.SetPID(const Value: Cardinal);
begin
  FGame.PID := Value;
end;
procedure TYXDGameThread.SetValue(Index: Integer; const Value: Variant);
begin
  FValues[Index] := Value;
end;
procedure TYXDGameThread.Start;
begin
  FTimer.Enabled := True;
end;

procedure TYXDGameThread.Stop;
begin
  FTimer.Enabled := False;
end;

procedure TYXDGameThread.WriteValueToGame(Index: Integer);
begin
  if (Index < 0) or (Index >= Count) then Exit;
  FGame.Items[Index].Value := FValues[Index];
end;
{ TYXDGame }
procedure TYXDGame.Execute;
var
  T: Cardinal;
  IsOpen: Boolean;
begin
  T := GetTickCount;
  if T < FLastLock then begin
    FLastLock := 0;
    FLastListener := 0;
  end;
  IsOpen := False;
  try
    if FGame.FHotKeyRef > 0 then begin
      HotKeyProcess(IsOpen);
    end;

    if (PID = 0) then begin
      if T - FLastLock >= FLockValueInterval then begin
        FLastLock := T;
        FindGame;
      end;
      if PID = 0 then Exit;
    end;

    if T - FLastLock >= FLockValueInterval then begin
      FLastLock := T;
      Open;
      IsOpen := True;
      LockValueProcess;
    end;
    if T - FLastListener >= FListenerInterval then begin
      FLastListener := T;
      if not IsOpen then Open;
      IsOpen := True;
      ListinserProcess;
    end;
  finally
    if IsOpen then
      Close;
  end;
end;
procedure TYXDGame.FindGame;
begin
  PID := FindGamePID;
end;

procedure TYXDGame.HotKeyProcess(var IsOpen: Boolean; const Key: Integer);
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    with Items[i] do begin
      if (FPID = 0) and not (moAllowZeroPID in FOptions) then
        Continue;
      if (FHotKey <> 0) and ((FHotKey = Key) or IsHotKey(FHotKey)) then begin
        if (moRepeatTriggerHotKey in FOptions) or (FLastHotKey <> FHotKey) then begin
          if Assigned(FHotKeyEventA) then begin
            if not IsOpen then Open;
            IsOpen := True;
            FLastHotKey := FHotKey;
            FHotKeyEventA(Items[I]);
            Exit;
          end else if Assigned(FHotKeyEvent) then begin
            if not IsOpen then Open;
            IsOpen := True;
            FLastHotKey := FHotKey;
            FHotKeyEvent(Items[I]);
            Exit;
          end;
        end else begin
          if FLastHotKey = FHotKey then
            Exit;
        end;
      end;
    end;
  end;
  FLastHotKey := 0;
end;

function TYXDGame.IsHotKey(const Key: Integer): Boolean;
begin
  Result := GetAsyncKeyState(Key) <> 0;
end;

procedure TYXDGame.ListinserProcess;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    with Items[i] do begin
      DoListener();
    end;
  end;
end;

procedure TYXDGame.LockValueProcess;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do begin
    with Items[i] do begin
      if Checked then
        WriteValueToGame(i);
    end;
  end;
end;

procedure TYXDGame.SendHotKey(Key: Integer);
var
  IsOpen: Boolean;
begin
  if Key = 0 then Exit;
  IsOpen := False;
  try
    HotKeyProcess(IsOpen, Key);
  finally
    if IsOpen then Close();
  end;
end;

end.
