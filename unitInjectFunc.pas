{*******************************************************}
{                                                       }
{       功能：远程注入                                  }
{                                                       }
{       版权所有 (C) 2009 yangyxd                       }
{                                                       }
{*******************************************************}

unit unitInjectFunc;

interface

uses
  Windows, Messages, SysUtils, Classes;

const
  Opcodes1: array [0..255] of word =
  (
    (16913),(17124),(8209),(8420),(33793),(35906),(0),(0),(16913),(17124),(8209),(8420),(33793),(35906),(0),(0),(16913),
    (17124),(8209),(8420),(33793),(35906),(0),(0),(16913),(17124),(8209),(8420),(33793),(35906),(0),(0),(16913),
    (17124),(8209),(8420),(33793),(35906),(0),(32768),(16913),(17124),(8209),(8420),(33793),(35906),(0),(32768),(16913),
    (17124),(8209),(8420),(33793),(35906),(0),(32768),(529),(740),(17),(228),(1025),(3138),(0),(32768),(24645),
    (24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(69),
    (69),(69),(69),(69),(69),(69),(69),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(24645),(0),
    (32768),(228),(16922),(0),(0),(0),(0),(3072),(11492),(1024),(9444),(0),(0),(0),(0),(5120),
    (5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(5120),(1296),
    (3488),(1296),(1440),(529),(740),(41489),(41700),(16913),(17124),(8209),(8420),(17123),(8420),(227),(416),(0),
    (57414),(57414),(57414),(57414),(57414),(57414),(57414),(32768),(0),(0),(0),(0),(0),(0),(32768),(33025),
    (33090),(769),(834),(0),(0),(0),(0),(1025),(3138),(0),(0),(32768),(32768),(0),(0),(25604),
    (25604),(25604),(25604),(25604),(25604),(25604),(25604),(27717),(27717),(27717),(27717),(27717),(27717),(27717),(27717),(17680),
    (17824),(2048),(0),(8420),(8420),(17680),(19872),(0),(0),(2048),(0),(0),(1024),(0),(0),(16656),
    (16800),(16656),(16800),(33792),(33792),(0),(32768),(8),(8),(8),(8),(8),(8),(8),(8),(5120),
    (5120),(5120),(5120),(33793),(33858),(1537),(1602),(7168),(7168),(0),(5120),(32775),(32839),(519),(583),(0),
    (0),(0),(0),(0),(0),(8),(8),(0),(0),(0),(0),(0),(0),(16656),(416)
  );

  Opcodes2: array [0..255] of word =
  (
    (280),(288),(8420),(8420),(65535),(0),(0),(0),(0),(0),(65535),(65535),(65535),(272),(0),(1325),(63),
    (575),(63),(575),(63),(63),(63),(575),(272),(65535),(65535),(65535),(65535),(65535),(65535),(65535),(16419),
    (16419),(547),(547),(65535),(65535),(65535),(65535),(63),(575),(47),(575),(61),(61),(63),(63),(0),
    (32768),(32768),(32768),(0),(0),(65535),(65535),(65535),(65535),(65535),(65535),(65535),(65535),(65535),(65535),(8420),
    (8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(8420),(16935),
    (63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(63),(237),
    (237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(101),(237),(1261),
    (1192),(1192),(1192),(237),(237),(237),(0),(65535),(65535),(65535),(65535),(65535),(65535),(613),(749),(7168),
    (7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(7168),(16656),
    (16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(16656),(0),
    (0),(32768),(740),(18404),(17380),(49681),(49892),(0),(0),(0),(17124),(18404),(17380),(32),(8420),(49681),
    (49892),(8420),(17124),(8420),(8932),(8532),(8476),(65535),(65535),(1440),(17124),(8420),(8420),(8532),(8476),(41489),
    (41700),(1087),(548),(1125),(9388),(1087),(33064),(24581),(24581),(24581),(24581),(24581),(24581),(24581),(24581),(65535),
    (237),(237),(237),(237),(237),(749),(8364),(237),(237),(237),(237),(237),(237),(237),(237),(237),
    (237),(237),(237),(237),(237),(63),(749),(237),(237),(237),(237),(237),(237),(237),(237),(65535),
    (237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(237),(0)
  );

  Opcodes3: array [0..9] of array [0..15] of word =
  (
    ((1296),(65535),(16656),(16656),(33040),(33040),(33040),(33040),(1296),(65535),(16656),(16656),(33040),(33040),(33040),(33040)),
    ((3488),(65535),(16800),(16800),(33184),(33184),(33184),(33184),(3488),(65535),(16800),(16800),(33184),(33184),(33184),(33184)),
    ((288),(288),(288),(288),(288),(288),(288),(288),(54),(54),(48),(48),(54),(54),(54),(54)),
    ((288),(65535),(288),(288),(272),(280),(272),(280),(48),(48),(0),(48),(0),(0),(0),(0)),
    ((288),(288),(288),(288),(288),(288),(288),(288),(54),(54),(54),(54),(65535),(0),(65535),(65535)),
    ((288),(65535),(288),(288),(65535),(304),(65535),(304),(54),(54),(54),(54),(0),(54),(54),(0)),
    ((296),(296),(296),(296),(296),(296),(296),(296),(566),(566),(48),(48),(566),(566),(566),(566)),
    ((296),(65535),(296),(296),(272),(65535),(272),(280),(48),(48),(48),(48),(48),(48),(65535),(65535)),
    ((280),(280),(280),(280),(280),(280),(280),(280),(566),(566),(48),(566),(566),(566),(566),(566)),
    ((280),(65535),(280),(280),(304),(296),(304),(296),(48),(48),(48),(48),(0),(54),(54),(65535))
  );

var
  //变量声明
  pRemoteFuncAddr: Pointer;  //注入空间地址
  pRemoteParamAddr: Pointer;  //注入参数地址

const
  //常量声明
  pFuncCodeSize = 9000; //代码大小
  pParamSize = 1000;    //参数大小

  //函数过程声明
  function SizeOfProc(Proc: pointer): DWORD; stdcall;
  function SizeOfCode(Code: pointer): DWORD; stdcall;
  function mInjectFunc(PID: Cardinal; pFuncAddr, pParamAddr: Pointer; pPSize: DWORD): Boolean; stdcall;
  procedure mClearCall(hProcess: THandle); stdcall;

implementation

//----------------------------------------------------------------//

// -------------------------
//  注入游戏进程,调用Call
// -------------------------
{参数：
    hProcess: 进程句柄，可用OpenProcess打开后传递给它。
    pFuncAddr: 要注入的函数地址
    pParamAddr: 要注入的参数地址
    pParamSize: 要注入的参数大小
  返回：
    返回为Boolean类型，True成功，否则失败。}
function mInjectFunc(PID: Cardinal; pFuncAddr, pParamAddr: Pointer; pPSize: DWORD): Boolean; stdcall;
label
  lblExit;
var
  intCodeSize: NativeInt;
  dwReserved: NativeUInt;
  hThread: THandle;
  lpThredId: Cardinal;
  hProcess: THandle;
begin
  Result := False;
  hProcess := OpenProcess(PROCESS_ALL_ACCESS, False, PID);
  if hProcess = 0 then Exit;
  // 向目标进程申请内存
  if pRemoteFuncAddr = nil then
  begin
    //分配函数内存
    // 计算函数大小
    pRemoteFuncAddr := VirtualAllocEx(hProcess, nil, pFuncCodeSize, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE);
    //msgbox(inttostr(getlasterror), 0, '');
    if pRemoteFuncAddr = nil then Exit;
    //分配参数内存
    pRemoteParamAddr := VirtualAllocEx(hProcess, nil, pParamSize, MEM_COMMIT or MEM_RESERVE, PAGE_READWRITE);
  end;
  // 计算函数大小
  if pFuncAddr = nil then Exit;
  intCodeSize := SizeOfProc(pFuncAddr);
  // 将代码写入到目标内存中
  if not WriteProcessMemory(hProcess, pRemoteFuncAddr, pFuncAddr, intCodeSize, dwReserved) then goto lblExit;
  // 写入参数
  if pParamAddr <> nil then
  begin
    if pRemoteParamAddr = nil then goto lblExit;
    if not WriteProcessMemory(hProcess, pRemoteParamAddr, pParamAddr, pPSize, dwReserved) then
      goto lblExit;
  end else pRemoteParamAddr := nil;
  // 创建并执行远程线程
  hThread := CreateRemoteThread(hProcess, nil, 0, pRemoteFuncAddr, pRemoteParamAddr, 0, lpThredId);
  if hThread <= 0 then goto lblExit;
  // 等待线程结束
  WaitForSingleObject(hThread, INFINITE);
  // 关闭线程句柄
  CloseHandle(hThread);
  Result := True;
lblExit:
  CloseHandle(hProcess);
end;

// -------------------------
// 销毁远程注入代码，释放内存
// -------------------------
procedure mClearCall(hProcess: THandle); stdcall;
begin
  //消毁函数
  if pRemoteFuncAddr <> nil then
    VirtualFreeEx(hProcess, pRemoteFuncAddr, pFuncCodeSize, MEM_RELEASE);
  //消除参数空间
  if pRemoteParamAddr <> nil then
    VirtualFreeEx(hProcess, pRemoteParamAddr, pParamSize, MEM_RELEASE);
end;

// -------------------------
// 计算函数大小。从老外那边复制过来的
// -------------------------
{
  参数：
    Proc： 要获取的函数地址
  返回：
    返回DWORD类型，得出具体字节大小
}
function SizeOfProc(Proc: pointer): DWORD; stdcall;
var
  Length: longword;
begin
  Result := 0;
  repeat
    Length := SizeOfCode(Proc);
    Inc(Result, Length);
    if ((Length = 1) and (Byte(Proc^) = $C3)) then Break;
    Proc := pointer(DWORD(Proc) + Length);
  until Length = 0;
end;
//----------------------------------------------------------------//
function SizeOfCode(Code: pointer): DWORD; stdcall;
var
  Opcode: word;
  Modrm: byte;
  Fixed, AddressOveride: boolean;
  Last, OperandOveride, Flags, Rm, Size, Extend: longword;
begin
  try
    Last := longword(Code);
    if Code <> nil then
    begin
      AddressOveride := False;
      Fixed := False;
      OperandOveride := 4;
      Extend := 0;
      repeat
        Opcode := byte(Code^);
        Code := pointer(longword(Code) + 1);
        if Opcode = $66 then
        begin
          OperandOveride := 2;
        end
        else if Opcode = $67 then
        begin
          AddressOveride := True;
        end
        else
        begin
          if not ((Opcode and $E7) = $26) then
          begin
            if not (Opcode in [$64..$65]) then
            begin
              Fixed := True;
            end;
          end;
        end;
      until Fixed;
      if Opcode = $0f then
      begin
        Opcode := byte(Code^);
        Flags := Opcodes2[Opcode];
        Opcode := Opcode + $0f00;
        Code := pointer(longword(Code) + 1);
      end
      else
      begin
        Flags := Opcodes1[Opcode];
      end;
      if ((Flags and $0038) <> 0) then
      begin
        Modrm := byte(Code^);
        Rm := Modrm and $7;
        Code := pointer(longword(Code) + 1);
        case (Modrm and $c0) of
          $40: Size := 1;
          $80:
            begin
              if AddressOveride then
              begin
                Size := 2;
              end
              else
                Size := 4;
              end;
          else
          begin
            Size := 0;
          end;
        end;
        if not (((Modrm and $c0) <> $c0) and AddressOveride) then
        begin
          if (Rm = 4) and ((Modrm and $c0) <> $c0) then
          begin
            Rm := byte(Code^) and $7;
          end;
          if ((Modrm and $c0 = 0) and (Rm = 5)) then
          begin
            Size := 4;
          end;
          Code := pointer(longword(Code) + Size);
        end;
        if ((Flags and $0038) = $0008) then
        begin
          case Opcode of
            $f6: Extend := 0;
            $f7: Extend := 1;
            $d8: Extend := 2;
            $d9: Extend := 3;
            $da: Extend := 4;
            $db: Extend := 5;
            $dc: Extend := 6;
            $dd: Extend := 7;
            $de: Extend := 8;
            $df: Extend := 9;
          end;
          if ((Modrm and $c0) <> $c0) then
          begin
            Flags := Opcodes3[Extend][(Modrm shr 3) and $7];
          end
          else
          begin
            Flags := Opcodes3[Extend][((Modrm shr 3) and $7) + 8];
          end;
        end;
      end;
      case (Flags and $0C00) of
        $0400: Code := pointer(longword(Code) + 1);
        $0800: Code := pointer(longword(Code) + 2);
        $0C00: Code := pointer(longword(Code) + OperandOveride);
        else
        begin
          case Opcode of
            $9a, $ea: Code := pointer(longword(Code) + OperandOveride + 2);
            $c8: Code := pointer(longword(Code) + 3);
            $a0..$a3:
              begin
                if AddressOveride then
                begin
                  Code := pointer(longword(Code) + 2)
                end
                else
                begin
                  Code := pointer(longword(Code) + 4);
                end;
              end;
          end;
        end;
      end;
    end;
    Result := longword(Code) - Last;
  except
    Result := 0;
  end;
end;



end.
