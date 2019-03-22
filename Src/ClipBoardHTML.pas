unit ClipBoardHTML;

interface

uses
  Windows, SysUtils, ClipBrd;

procedure SetClipBoardHTML(s: String);
function GetClipBoardHTML: String;

implementation

// Ŭ�����忡 CF_HTML ���·� �Է�
// _____________________________________________________________________________
procedure SetClipBoardHTML(s: String);
const
  START_FRAGMENT = '<!--StartFragment-->';
  END_FRAGMENT = '<!--EndFragment-->';

var
  gMem: HGLOBAL;
  pBytes: PByteArray;
  i: Integer;
  tmpStr: String;
  LBuffer: TBytes;

begin
  // HTML Format�� �°� ����
  tmpStr := 'Version:1.0' + #13#10;
  tmpStr := tmpStr + 'StartHTML:~~~~~~~~' + #13#10;
  tmpStr := tmpStr + 'EndHTML:########' + #13#10;
  tmpStr := tmpStr + 'StartFragment:~~~~~~~~' + #13#10;
  tmpStr := tmpStr + 'EndFragment:########' + #13#10;
  tmpStr := tmpStr + '<html><body>' + #13#10;
  tmpStr := tmpStr + '<!--StartFragment-->' + s + '<!--EndFragment-->' + #13#10;
  tmpStr := StringReplace(tmpStr, '~~~~~~~~',
    Format('%.08d', [Pos('<html', tmpStr) - 1]), [rfReplaceAll]);
  tmpStr := StringReplace(tmpStr, '########',
    Format('%.08d', [Pos(END_FRAGMENT, tmpStr) + Length(END_FRAGMENT)]),
    [rfReplaceAll]);

  // ���ۿ� ����
  SetLength(LBuffer, Length(tmpStr) + 1);
  for i := 0 to Length(tmpStr) do
    LBuffer[i] := Byte(tmpStr[i + 1]);

  // Ŭ������� ���ۿ� ����
  gMem := GlobalAlloc(GHND, Length(LBuffer) * 2);
  pBytes := GlobalLock(gMem);
  try
    for i := 0 to Length(LBuffer) + 1 do
      pBytes[i] := LBuffer[i];
  finally
    GlobalUnlock(gMem);
  end;

  // Ŭ�����忡 ����
  OpenClipBoard(0);
  EmptyClipBoard;
  SetClipBoardData(RegisterClipBoardFormat('HTML Format'), gMem);
  CloseClipBoard;
end;

// Ŭ�������� CF_HTML ���˵����� ��������
// _____________________________________________________________________________
function GetClipBoardHTML: String;
var
  gMem: HGLOBAL;
  pBytes: PByteArray;
  lenBuffer: DWORD;
  i: Integer;
  CF_HTML: UINT;
begin
  Result := '';

  // CF_HTML ���
  CF_HTML := RegisterClipBoardFormat('HTML Format');

  // Ŭ�����带 ���� CF_HTML �����Ͱ� ������ �о�ͼ� ��ȯ
  OpenClipBoard(0);
  if ClipBoard.HasFormat(CF_HTML) then
  begin
    gMem := GetClipboardData(CF_HTML);
    pBytes := GlobalLock(gMem);
    try
      lenBuffer := Length(PChar(pBytes)) * 2;
      SetLength(Result, lenBuffer);
      for i := 0 to lenBuffer do
        Result[i + 1] := Chr(pBytes[i]);
      Result := TEncoding.UTF8.GetString(TBytes(pBytes), 0, lenBuffer);
    finally
      GlobalUnlock(gMem);
    end;
  end;
  CloseClipBoard;
end;

end.
