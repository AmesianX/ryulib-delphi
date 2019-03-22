unit InsertDebugCode;

interface

uses
  Config,
  Scanner,
  RyuLibBase, SearchDir, Disk,
  SysUtils, Classes;

type
  TInsertDebugCode = class
  private
    procedure do_SkipToEnd;
    procedure do_InsertDebugCode(AFileName:string);
  private
    FOnWork: TStringEvent;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Execute(APath:string);
  public
    property OnWork : TStringEvent read FOnWork write FOnWork;
  end;

implementation

uses
  ScanMgr, ScanMethod;

{ TInsertDebugCode }

constructor TInsertDebugCode.Create;
begin
  inherited;

end;

destructor TInsertDebugCode.Destroy;
begin

  inherited;
end;

procedure TInsertDebugCode.do_InsertDebugCode(AFileName: string);
var
  isAfterEqualOrColon : boolean;
  isFirstUsesExpected : boolean;
  isImplementationArea : boolean;
begin
  if Assigned(FOnWork) then FOnWork(Self, AFileName);

  TScanMgr.Obj.SetText( AFileName, LoadFileAsText(AFileName) );

  // =, : ��ȣ �����̶��, isMethodBegin=true �� �Լ� ������ �ƴ� Ÿ�� ������ ���
  isAfterEqualOrColon := false;

  isFirstUsesExpected := true;
  isImplementationArea := false;

  TScanMgr.Obj.GetNextTokenAndSkipWhiteSpace;
  while not TScanMgr.Obj.IsEOF do begin
    if isFirstUsesExpected and TScanMgr.Obj.isUses then begin
      isFirstUsesExpected := false;
      TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText + DebugCodeUses;
      TScanMgr.Obj.GetNextToken;
      Continue;
    end;

    if TScanMgr.Obj.isImplementation then begin
      isImplementationArea := true;
      TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText;
      TScanMgr.Obj.GetNextToken;
      Continue;
    end;

    if not isImplementationArea then begin
      TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText;
      TScanMgr.Obj.GetNextToken;
      Continue;
    end;

    if TScanMgr.Obj.isClass or TScanMgr.Obj.isRecord or TScanMgr.Obj.isObject then begin
      do_SkipToEnd;

    end else if (not isAfterEqualOrColon) and TScanMgr.Obj.isMethodBegin then begin
      TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText;
      TScanMethod.Obj.Execute(0);

    end else begin
      TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText;
    end;

    isAfterEqualOrColon :=
      (TScanMgr.Obj.CurrentToken.TokenType = ttSpecialChar) and
      ((TScanMgr.Obj.CurrentToken.OriginalText = '=') or ((TScanMgr.Obj.CurrentToken.OriginalText = ':')));

    TScanMgr.Obj.GetNextTokenAndSkipWhiteSpace;
  end;

  SaveTextToFile( AFileName, TScanMgr.Obj.Source );
end;

procedure TInsertDebugCode.do_SkipToEnd;
begin
  while not TScanMgr.Obj.IsEOF do begin
    TScanMgr.Obj.Source := TScanMgr.Obj.Source + TScanMgr.Obj.CurrentToken.OriginalText;
    if TScanMgr.Obj.isEndToken then Break;

    TScanMgr.Obj.GetNextTokenAndSkipWhiteSpace;
  end;
end;

procedure TInsertDebugCode.Execute(APath: string);
begin
  SearchFiles( APath, true,
    procedure(Path:string; SearchRec:TSearchRec; var NeedStop:boolean)
    var
      isPascalFile : boolean;
    begin
      isPascalFile := ExtractFileExt( LowerCase(SearchRec.Name) ) = '.pas';
      if isPascalFile then do_InsertDebugCode(Path + SearchRec.Name);
    end
  );
end;

end.
