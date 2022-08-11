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
  unitInjectFunc, SyncObjs, ExtCtrls, Windows, SysUtils, Classes, Messages,
  Variants;

type
  {$IFNDEF UNICODE}
  SIZE_T = ULONG_PTR;
  {$ENDIF}

  TYXDMemOption = (
    /// <summary>
    /// 允许重复触发热键
    /// </summary>
    moRepeatTriggerHotKey,
    /// <summary>
    /// 允许PID为0时触发热键
    /// </summary>
    moAllowZeroPID,
    /// <summary>
    /// 热键需要同时按下 Ctrl 键
    /// </summary>
    moHotKeyCtrl,
    /// <summary>
    /// 热键需要同时按下 Alt 键
    /// </summary>
    moHotKeyAlt,
    /// <summary>
    /// 设置通过 Value 读写字符串时是否以 Unicode 方式操作
    /// </summary>
    moValueIsUnicode);

  TYXDMemOptions = set of TYXDMemOption;

  /// <summary>
  /// 远程内存数据读写对象
  /// </summary>

  TYXDRemoteMem = class(TObject)
  private
    FPID: Cardinal;
    FBaseAddr: Cardinal;
    FLevel: Integer;
    FChecked: Boolean;
    FTag: Integer;
    FHandle: Cardinal;
    FType: Word;
    FLength: Cardinal;
    FOptions: TYXDMemOptions;
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
    function GetDataAddr(const Addr: array of Cardinal): Cardinal;
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
    /// 获取地址, [基址,偏移,偏移,偏移...]
    /// </summary>
    function GetAddress(const Addr: array of Cardinal; const Len: Integer = -1): Cardinal;

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
    /// 直接读取地址数据
    /// </summary>
    function ReadData(const Addr: Cardinal; var OutputValue: TBytes; const ALength: Cardinal = 4): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: Byte): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: WORD): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: DWORD): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: Integer): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: Int64): Boolean; overload;
    function ReadData(const Addr: Cardinal; const ALength: Cardinal; var OutputValue: string; IsUnicode: Boolean = False): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: Double): Boolean; overload;
    function ReadData(const Addr: Cardinal; var OutputValue: Single): Boolean; overload;

    /// <summary>
    /// 直接读取地址数据
    /// <param name="Addr">数据地址数组, [基址,偏移,偏移,偏移...]</param>
    /// <returns>成功返回 True</returns>
    /// </summary>
    function ReadData(const Addr: array of Cardinal; var OutputValue: TBytes; const ALength: Cardinal = 4): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: Byte): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: WORD): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: DWORD): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: Integer): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: Int64): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; const ALength: Cardinal; var OutputValue: string; IsUnicode: Boolean = False): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: Double): Boolean; overload;
    function ReadData(const Addr: array of Cardinal; var OutputValue: Single): Boolean; overload;

    /// <summary>
    /// 直接向指定地址 + 写数据
    /// </summary>
    function WriteData(const Addr: Cardinal; const Value: TBytes): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: Byte): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: WORD): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: DWORD): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: Integer): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: Int64): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: string; IsUnicode: Boolean = False; const ALength: Cardinal = 0): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: Single): Boolean; overload;
    function WriteData(const Addr: Cardinal; const Value: Double): Boolean; overload;

    /// <summary>
    /// 直接写入地址数据
    /// <param name="Addr">数据地址数组, [基址,偏移,偏移,偏移...]</param>
    /// <returns>成功返回 True</returns>
    /// </summary>
    function WriteData(const Addr: array of Cardinal; const Value: TBytes): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: Byte): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: WORD): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: DWORD): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: Integer): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: Int64): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: string; IsUnicode: Boolean = False; const ALength: Cardinal = 0): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: Single): Boolean; overload;
    function WriteData(const Addr: array of Cardinal; const Value: Double): Boolean; overload;

    /// <summary>
    /// 注入 Call 函数
    /// </summary>
    procedure InjectCall(pFuncAddr, pParamAddr: Pointer; pPSize: DWORD);
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
    property Value: Variant read GetValue write SetValue;

    // 选项
    property Options: TYXDMemOptions read FOptions write FOptions default[];
  end;

  TYXDGameMem = class;

  TYXDGameThread = class;

  TYXDMemItem = class;

  TYXDMemEvent = procedure(Sender: TYXDMemItem) of object;

  TYXDMemEventA = reference to procedure(Sender: TYXDMemItem);

  TYXDMemLoopCallBackA = reference to function(Sender: TYXDMemItem; Index: Integer; Addr: Cardinal): Boolean;

  TYXDMemItem = class(TYXDRemoteMem)
  private
    FOwner: TYXDGameMem;
    FHotKey: Integer;
    FLockValue: Variant;
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

    // 设置锁定值
    function SetLockValue(const value: Variant): TYXDMemItem; overload;
    function SetLockValue(const value: TBytes): TYXDMemItem; overload;

    /// <summary>
    /// 循环遍列内部数据
    /// <param name="MaxCount">最大循环次数</param>
    /// <param name="CallBack">回调事件，需要返回 true 才继续遍列</param>
    /// <param name="ItemOffset">列表项内存偏移，一般为4或4的倍数</param>
    /// <param name="FieldOffset">列表项字段值偏移</param>
    /// </summary>
    function LoopData(const MaxCount: Integer; const CallBack: TYXDMemLoopCallBackA; const FieldOffset: Cardinal = 0; const ItemOffset: Cardinal = 4): TYXDMemItem;
    property LockValue: Variant read FLockValue write FLockValue;

    // 热键
    property HotKey: Integer read FHotKey write FHotKey;
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

function ReadProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer; nSize: SIZE_T; var t: Cardinal): BOOL;
var
  p: SIZE_T;
begin
  Result := Windows.ReadProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, p);
  t := p;
end;

function WriteProcessMemory(hProcess: THandle; const lpBaseAddress: Pointer; lpBuffer: Pointer; nSize: SIZE_T; var t: Cardinal): BOOL;
var
  p: SIZE_T;
begin
  Result := Windows.WriteProcessMemory(hProcess, lpBaseAddress, lpBuffer, nSize, p);
  t := p;
end;

function OpenProcessToken(ProcessHandle: THandle; DesiredAccess: DWORD; var TokenHandle: Cardinal): BOOL;
var
  p: THandle;
begin
  Result := Windows.OpenProcessToken(ProcessHandle, DesiredAccess, p);
  TokenHandle := p;
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

procedure TYXDRemoteMem.Clone(Dest: TYXDRemoteMem);
begin
  Dest.FBaseAddr := FBaseAddr;
  if Count > 0 then
  begin
    SetLength(Dest.FOffsets, Count);
    CopyMemory(@Dest.FOffsets[0], @FOffsets[0], Count * OffsetSize);
  end
  else
    Dest.Clear;
  Dest.Level := Level;
  Dest.Tag := Tag;
  Dest.Checked := FChecked;
end;

procedure TYXDRemoteMem.Close;
begin
  if FHandle <> 0 then
  begin
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
  if Count <= 0 then
    Exit;
  SetLength(FOffsets, Count - 1);
  UpdateLevel;
end;

procedure TYXDRemoteMem.Delete(Index: Integer);
begin
  if (Index < Count) and (Index >= 0) then
  begin
    CopyMemory(@FOffsets[Index], @FOffsets[Index + 1], (Count - Index - 1) * OffsetSize);
    SetLength(FOffsets, Count - 1);
    UpdateLevel;
  end;
end;

function TYXDRemoteMem.GetAddress(const Addr: array of Cardinal; const Len: Integer): Cardinal;
var
  I, J: Integer;
begin
  I := Length(Addr);
  if I = 0 then
    Result := 0
  else
  begin
    if (Len >= 0) and (Len < I) then 
      I := Len;       
    Result := Addr[0];
    for J := 1 to I - 1 do begin
      if not ReadData(Result, Result) then
        Exit;
      Result := Result + Addr[J];  
    end;
  end;
end;

function TYXDRemoteMem.GetAsAnsiString(ALength: Cardinal): string;
begin
  Result := '';
  ReadData(DestAddr, ALength, Result, False);
end;

function TYXDRemoteMem.GetAsByte: Byte;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsBytes(ALength: Cardinal): TBytes;
begin
  ReadData(DestAddr, Result, ALength);
end;

function TYXDRemoteMem.GetAsDateTime: TDateTime;
var
  V: Double;
begin
  Result := 0;
  if ReadData(DestAddr, V) then
    Result := TDateTime(V);
end;

function TYXDRemoteMem.GetAsDouble: Double;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsDWORD: DWORD;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsInt64: Int64;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsInteger: Integer;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsSingle: Single;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetAsWideString(ALength: Cardinal): string;
begin
  Result := '';
  ReadData(DestAddr, ALength, Result, True);
end;

function TYXDRemoteMem.GetAsWord: Word;
begin
  Result := 0;
  ReadData(DestAddr, Result);
end;

function TYXDRemoteMem.GetCount: Integer;
begin
  Result := High(FOffsets) + 1;
end;

function TYXDRemoteMem.GetIsValid: Boolean;
var
  t: Cardinal;
begin
  Result := (FHandle <> 0) and ReadProcessMemory(FHandle, Pointer(FBaseAddr), @Result, 4, t);
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
    if moValueIsUnicode in FOptions then
      Result := AsUnicodeString[FLength]
    else
      Result := AsAnsiString[FLength];
  end;

begin
  case FType of
    varNull:
      Exit;
    varByte:
      Result := AsByte;
    varWord:
      Result := AsWORD;
    varLongWord:
      Result := AsDWORD;
    varInteger:
      Result := AsInteger;
    varSingle:
      Result := AsSingle;
    varDouble:
      Result := AsDouble;
    varDate:
      Result := AsDateTime;
    varInt64:
      Result := AsInt64;
    varArray + varByte:
      Result := AsBytes[FLength];
    varString:
      Result := GetString;
  end;
end;

procedure TYXDRemoteMem.InjectCall(pFuncAddr, pParamAddr: Pointer; pPSize: DWORD);
begin
  if PID = 0 then
    Exit;
  mInjectFunc(PID, pFuncAddr, pParamAddr, pPSize);
end;

function TYXDRemoteMem.GetDataAddr(const Addr: array of Cardinal): Cardinal;
begin
  Result := GetAddress(Addr, Length(Addr) - 1);
  if (Result <> 0)  then
    Result := Result + Addr[High(Addr)];
end;

function TYXDRemoteMem.GetDataPath: string;
const
  HexHeader = '$';
var
  i: Integer;
begin
  Result := '[' + HexHeader + IntToHex(FBaseAddr, 2) + ']';
  if FLevel >= 0 then
  begin
    for i := 0 to FLevel - 1 do
      Result := '[' + Result + '+' + HexHeader + IntToHex(FOffsets[i], 1) + ']';
    Result := Result + '+' + HexHeader + IntToHex(FOffsets[FLevel], 1);
  end;
end;

function TYXDRemoteMem.GetDestAddr: Cardinal;
var
  t: Cardinal;
  i: Integer;
begin
  Result := 0;
  if FHandle = 0 then
    Exit;
  if FLevel < 0 then
    Result := FBaseAddr
  else if ReadProcessMemory(FHandle, pointer(FBaseAddr), @Result, 4, t) then
  begin
    for i := 0 to FLevel - 1 do
      if ReadProcessMemory(FHandle, pointer(Result + FOffsets[i]), @Result, 4, t) = False then
      begin
        Result := 0;
        Exit;
      end;
    if Result = 0 then
      Exit;
    Result := Result + FOffsets[FLevel];
  end;
end;

procedure TYXDRemoteMem.Open;
begin
  if (FHandle = 0) and (PID > 0) then
  begin
    FHandle := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
    if FHandle = 0 then
      PID := 0;
  end;
end;

function TYXDRemoteMem.ReadAnsiString(const Addr, ALength: Cardinal): string;
begin
  Result := '';
  ReadData(Addr, ALength, Result, False);
end;

function TYXDRemoteMem.ReadByte(const Addr: Cardinal): Byte;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadBytes(const Addr, ALength: Cardinal): TBytes;
begin
  ReadData(Addr, Result, ALength);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: Double): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; const ALength: Cardinal; var OutputValue: string; IsUnicode: Boolean): Boolean;
var
  t: Cardinal;
  s1: array of AnsiChar;
  s2: array of WideChar;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
  begin
    if IsUnicode then
    begin
      SetLength(s2, ALength + 1);
      Result := ReadProcessMemory(FHandle, Pointer(Addr), @s2[0], ALength * 2, t);
      if Result then
        OutputValue := string(PWideChar(s2));
    end
    else
    begin
      SetLength(s1, ALength + 1);
      Result := ReadProcessMemory(FHandle, Pointer(Addr), @s1[0], ALength, t);
      if Result then
        OutputValue := string(PAnsiChar(s1));
    end;
  end;
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: Int64): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: DWORD): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: TBytes; const ALength: Cardinal): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
  begin
    SetLength(OutputValue, ALength);
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue[0], ALength, t);
  end;
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: Double): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: Byte): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: WORD): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: Integer): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: Cardinal; var OutputValue: Single): Boolean;
var
  t: Cardinal;
begin
  if (FHandle = 0) or (Addr = 0) then
    Result := False
  else
    Result := ReadProcessMemory(FHandle, Pointer(Addr), @OutputValue, SizeOf(OutputValue), t);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; const ALength: Cardinal; var OutputValue: string; IsUnicode: Boolean): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), ALength, OutputValue, IsUnicode);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: Int64): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: TBytes; const ALength: Cardinal): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue, ALength);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: DWORD): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadDobule(const Addr: Cardinal): Double;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadDWORD(const Addr: Cardinal): DWORD;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadInt64(const Addr: Cardinal): Int64;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadInteger(const Addr: Cardinal): Integer;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadSingle(const Addr: Cardinal): Single;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

function TYXDRemoteMem.ReadUnicodeString(const Addr, ALength: Cardinal): string;
begin
  Result := '';
  ReadData(Addr, ALength, Result, True);
end;

function TYXDRemoteMem.ReadWORD(const Addr: Cardinal): WORD;
begin
  Result := 0;
  ReadData(Addr, Result);
end;

procedure TYXDRemoteMem.SetAsAnsiString(ALength: Cardinal; const Value: string);
begin
  WriteData(DestAddr, Value, False, ALength);
end;

procedure TYXDRemoteMem.SetAsByte(const Value: Byte);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsBytes(ALength: Cardinal; const Value: TBytes);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsDateTime(const Value: TDateTime);
begin
  WriteData(DestAddr, Double(Value));
end;

procedure TYXDRemoteMem.SetAsDouble(const Value: Double);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsDWORD(const Value: DWORD);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsInt64(const Value: Int64);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsInteger(const Value: Integer);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsSingle(const Value: Single);
begin
  WriteData(DestAddr, Value);
end;

procedure TYXDRemoteMem.SetAsWideString(ALength: Cardinal; const Value: string);
begin
  WriteData(DestAddr, Value, True, ALength);
end;

procedure TYXDRemoteMem.SetAsWord(const Value: Word);
begin
  WriteData(DestAddr, Value);
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

procedure TYXDRemoteMem.SetValue(const Value: Variant);

  procedure SetString;
  var
    tmp: string;
  begin
    tmp := VarToStr(Value);
    FLength := Length(tmp);
    if moValueIsUnicode in FOptions then
      AsUnicodeString[FLength] := tmp
    else
      AsAnsiString[FLength] := tmp
  end;

begin
  FType := VarType(Value);
  case FType of
    varNull:
      Exit;
    varByte:
      AsByte := Value;
    varWord:
      AsWORD := Value;
    varLongWord:
      AsDWORD := Value;
    varInteger:
      AsInteger := Value;
    varSingle:
      AsSingle := Value;
    varDouble:
      AsDouble := Value;
    varDate:
      AsDateTime := Value;
    varInt64:
      AsInt64 := Value;
    varArray + varByte:
      begin
        FLength := High(TBytes(Value)) + 1;
        AsBytes[FLength] := Value;
      end;
    varString:
      SetString;
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
      if Value[i] = SubChar then
      begin
        Result := i;
        Exit;
      end;
    Result := -1;
  end;

  function mRightPos(SubChar: Char; sPos: Integer): Integer;
  var
    i: Integer;
  begin
    for i := sPos downto 1 do
      if Value[i] = SubChar then
      begin
        Result := i;
        Exit;
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
  if (i < 0) and (j < 0) then
  begin
    FBaseAddr := StrToIntDef(Value, 0);
    Exit;
  end;
  try
    while i > 0 do
    begin
      if j > 0 then
      begin
        if k = 0 then
        begin
          Clear;
          FBaseAddr := StrToIntDef(mMidStr(j + 1, i - j - 1), 0);
        end
        else
          Add(StrToIntDef(mMidStr(j + 1, i - j - 1), 0));
        k := i;
        i := mLeftPos(']', i + 1);
        if (i < 0) and (k < sLen) then
          i := sLen + 1;
        j := mRightPos('+', i);
      end
      else
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

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: DWORD): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: TBytes): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: Int64): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: string; IsUnicode: Boolean; const ALength: Cardinal): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value, IsUnicode, ALength);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: Double): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: WORD): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: Byte): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: Integer): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: array of Cardinal; const Value: Single): Boolean;
begin
  Result := WriteData(GetDataAddr(Addr), Value);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: Byte): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: WORD): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: Integer): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: Single): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: Int64): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: string; IsUnicode: Boolean; const ALength: Cardinal): Boolean;
var
  t: Cardinal;
  len: Integer;
  s1: AnsiString;
  s2: WideString;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
  begin
    if IsUnicode then
    begin
      s1 := AnsiString(Value);
      len := Integer(ALength) - Length(s1);
      if len > 0 then
      begin
        SetLength(s1, ALength);
        FillMemory(@s1[Length(s1) + 1], len, 0);
      end;
      Result := WriteProcessMemory(FHandle, Pointer(Addr), @s1[1], ALength, t);
    end
    else
    begin
      s2 := WideString(Value);
      len := (Integer(ALength) - Length(s2)) * 2;
      if len > 0 then
      begin
        SetLength(s2, ALength);
        FillMemory(@s2[Length(s2) + 1], len, 0);
      end;
      Result := WriteProcessMemory(FHandle, Pointer(Addr), @s2[1], ALength * 2, t);
    end;
  end;
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: Double): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: DWORD): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value, SizeOf(Value), t);
end;

function TYXDRemoteMem.WriteData(const Addr: Cardinal; const Value: TBytes): Boolean;
var
  t: Cardinal;
begin
  Result := False;
  if (FHandle <> 0) and (Addr <> 0) then
    Result := WriteProcessMemory(FHandle, Pointer(Addr), @Value[0], High(Value) + 1, t);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: Byte): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: WORD): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: Single): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

function TYXDRemoteMem.ReadData(const Addr: array of Cardinal; var OutputValue: Integer): Boolean;
begin
  Result := ReadData(GetDataAddr(Addr), OutputValue);
end;

{ TYXDMemItem }
procedure TYXDMemItem.Close;
begin
  if FOwner <> nil then
    FOwner.Close
  else
    inherited;
end;

constructor TYXDMemItem.Create(AOwner: TYXDGameMem);
begin
  FOwner := AOwner;
  FOptions := [];
  FLockValue := Null;
  inherited Create;
end;

function TYXDMemItem.DoListener: Boolean;
begin
  Result := False;
  if Assigned(FOnListenerA) then
  begin
    FOnListenerA(Self);
    Result := True;
  end
  else if Assigned(FOnListener) then
  begin
    FOnListener(Self);
    Result := True;
  end;
end;

function TYXDMemItem.LoopData(const MaxCount: Integer; const CallBack: TYXDMemLoopCallBackA; const FieldOffset, ItemOffset: Cardinal): TYXDMemItem;
var
  addr, itemAddr: Cardinal;
  I: Cardinal;
begin
  Result := Self;
  addr := AsDWORD;
  if addr = 0 then
    Exit;
  for I := 0 to MaxCount - 1 do
  begin
    itemAddr := ReadDWORD(addr + I * ItemOffset) + FieldOffset;
    if not CallBack(Self, I, itemAddr) then
      Break;
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

function TYXDMemItem.SetLockValue(const value: TBytes): TYXDMemItem;
begin
  FType := varArray + varByte;
  FLength := Length(value);
  FLockValue := value;
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
  FOptions := value;
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
  inherited;
  if (FOwner <> nil) and (FOwner.PID <> Value) then
    FOwner.PID := Value
end;

function TYXDMemItem.SetLockValue(const value: Variant): TYXDMemItem;
begin
  FLockValue := value;
  Result := Self;
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
    if Assigned(TObject(FItems[i])) then
      TObject(FItems[i]).Free;
  FItems.Clear;
end;

procedure TYXDGameMem.Close;
var
  i: Integer;
begin
  if FHandle <> 0 then
  begin
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
  if (Index >= 0) and (Index < FItems.Count) then
  begin
    if Assigned(TObject(FItems[Index])) then
      TObject(FItems[Index]).Free;
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
  Result := TYXDMemItem(FItems[Index]);
end;

function TYXDGameMem.IndexOf(Item: TYXDMemItem): Integer;
begin
  Result := FItems.IndexOf(Item);
end;

procedure TYXDGameMem.Open;
var
  i: Integer;
begin
  if (FHandle = 0) and (PID > 0) then
  begin
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
    TObject(FItems[Index]).Free;
  FItems[Index] := Value;
end;

procedure TYXDGameMem.SetPID(const Value: Cardinal);
var
  i: Integer;
begin
  if FPID <> Value then
  begin
    FPID := Value;
    for i := 0 to Count - 1 do
      if Assigned(Items[i]) then
      begin
        Items[i].PID := Value;
        Items[i].DoListener();
      end;
  end;
end;
{ TYXDGameThread }

procedure TYXDGameThread.Add(Item: TYXDMemItem);
begin
  FGame.Add(Item);
end;

function TYXDGameThread.AddNew(const BaseAddr: DWORD = 0): TYXDMemItem;
begin
  Result := FGame.AddNew;
  Result.BaseAddr := BaseAddr;
end;

function TYXDGameThread.AddPath(const Path: string; const Value: Variant): TYXDMemItem;
begin
  Result := AddPath(Path);
  Result.FLockValue := Value;
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
  except
  end;
end;

function TYXDGameThread.AddPath(const Path: string): TYXDMemItem;
begin
  Result := FGame.AddPath(Path);
end;

procedure TYXDGameThread.Clear;
begin
  FGame.Clear;
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
  if tmpWnd > 0 then
  begin
    GetWindowThreadProcessId(tmpWnd, Result);
  end
  else
    Result := 0;
end;

function TYXDGameThread.FindGameWnd: HWND;
var
  i: Integer;
begin
  i := 0;
  if (FWndName = '') then
    Inc(i);
  if (FClsName = '') then
    Inc(i, 2);
  case i of
    0:
      Result := FindWindow(PChar(FClsName), PChar(FWndName));
    1:
      Result := FindWindow(PChar(FClsName), nil);
    2:
      Result := FindWindow(nil, PChar(FWndName));
  else
    Result := 0;
  end;
  if Result <> 0 then
    GameWnd := Result
  else
    GameWnd := 0;
end;

function TYXDGameThread.GetCount: Integer;
begin
  Result := FGame.Count;
end;

function TYXDGameThread.GetItem(Index: Integer): TYXDMemItem;
begin
  Result := FGame.Items[Index];
end;

function TYXDGameThread.GetPID: Cardinal;
begin
  Result := FGame.PID;
end;

function TYXDGameThread.GetValue(Index: Integer): Variant;
begin
  Result := GetItem(Index).FLockValue;
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
  if i > 0 then
  begin
    GetWindowText(AHandle, PChar(GetLenStr(i)), i);
  end
  else
  begin
    i := SendMessage(AHandle, WM_GETTEXTLENGTH, 0, 0);
    if i > 0 then
    begin
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
  GetItem(Index).FLockValue := Value;
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
var
  Item: TYXDMemItem;
  Buf, Buf2: TBytes;
begin
  if (Index < 0) or (Index >= Count) then
    Exit;
  Item := FGame.Items[Index];
  if (Item.FType = varArray + varByte) then
  begin
    Buf := Item.FLockValue;
    Buf2 := Item.Value;
    if (Buf2 <> Buf) then
    begin
      Item.Value := Buf;
    end;
  end
  else if Item.Value <> Item.FLockValue then
    Item.Value := Item.FLockValue;
end;
{ TYXDGame }

procedure TYXDGame.Execute;
var
  T: Cardinal;
  IsOpen: Boolean;
begin
  T := GetTickCount;
  if T < FLastLock then
  begin
    FLastLock := 0;
    FLastListener := 0;
  end;
  IsOpen := False;
  try
    if FGame.FHotKeyRef > 0 then
    begin
      HotKeyProcess(IsOpen);
    end;

    if (PID = 0) then
    begin
      if T - FLastLock >= FLockValueInterval then
      begin
        FLastLock := T;
        FindGame;
      end;
      if PID = 0 then
        Exit;
    end;

    if T - FLastLock >= FLockValueInterval then
    begin
      FLastLock := T;
      Open;
      IsOpen := True;
      LockValueProcess;
    end;
    if T - FLastListener >= FListenerInterval then
    begin
      FLastListener := T;
      if not IsOpen then
        Open;
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
  Item: TYXDMemItem;
begin
  for i := 0 to Count - 1 do
  begin
    Item := Items[i];
    if (Item.FPID = 0) and not (moAllowZeroPID in Item.FOptions) then
      Continue;
    if (Item.FHotKey <> 0) and ((Item.FHotKey = Key) or IsHotKey(Item.FHotKey)) then
    begin
      if (moHotKeyCtrl in Item.FOptions) and (not IsHotKey(VK_CONTROL)) then
        Continue;
      if (moHotKeyAlt in Item.FOptions) and (not IsHotKey(VK_MENU)) then
        Continue;
      if (moRepeatTriggerHotKey in Item.FOptions) or (FLastHotKey <> Item.FHotKey) then
      begin
        if Assigned(Item.FHotKeyEventA) then
        begin
          if not IsOpen then
            Open;
          IsOpen := True;
          FLastHotKey := Item.FHotKey;
          Item.FHotKeyEventA(Items[i]);
          Exit;
        end
        else if Assigned(Item.FHotKeyEvent) then
        begin
          if not IsOpen then
            Open;
          IsOpen := True;
          FLastHotKey := Item.FHotKey;
          Item.FHotKeyEvent(Items[i]);
          Exit;
        end;
      end
      else
      begin
        if FLastHotKey = Item.FHotKey then
          Exit;
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
  for i := 0 to Count - 1 do
  begin
    with Items[i] do
    begin
      DoListener();
    end;
  end;
end;

procedure TYXDGame.LockValueProcess;
var
  i: Integer;
begin
  for i := 0 to Count - 1 do
  begin
    with Items[i] do
    begin
      if Checked then
        WriteValueToGame(i);
    end;
  end;
end;

procedure TYXDGame.SendHotKey(Key: Integer);
var
  IsOpen: Boolean;
begin
  if Key = 0 then
    Exit;
  IsOpen := False;
  try
    HotKeyProcess(IsOpen, Key);
  finally
    if IsOpen then
      Close();
  end;
end;

end.

