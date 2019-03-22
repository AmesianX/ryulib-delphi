/// TCore�� ���ǵǰ� ������ �����̴�.
unit Core;

interface

uses
  View, Option, ValueList,
  SysUtils, Classes;

type
  /// Application�� �ٽ� ����� ��Ƶ� Ŭ���� �̴�.
  TCore = class (TComponent)
  private
    FIsInitialized : boolean;
    FIsfinalized : boolean;
  private
    FView: TView;
    FOption: TOption;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;

    class function Obj:TCore;

    /// TCore���� ����ϴ� ��ü�鿡 ���� �ʱ�ȭ.
    procedure Initialize;  

    /// TCore���� ����ϴ� ��ü�鿡 ���� ���� ó��.
    procedure Finalize;  
  published
    property View: TView read FView;
    property Option : TOption read FOption;
  end;

implementation

var
  MyObject : TCore = nil;

{ TCore }

constructor TCore.Create(AOwner: TComponent);
begin
  inherited;

  FIsInitialized := false;
  FIsfinalized := false;

  FOption := TOption.Create;
  FView := TView.Create(Self);
end;

destructor TCore.Destroy;
begin
  Finalize;

  FreeAndNil(FOption);
  FreeAndNil(FView);

  inherited;
end;

procedure TCore.Finalize;
begin
  if FIsfinalized then Exit;
  FIsfinalized := true;

  FView.sp_Finalize;
  FView.Active := false;
end;

procedure TCore.Initialize;
begin
  if FIsfinalized then Exit;

  if FIsInitialized then Exit;
  FIsInitialized := true;

  FView.sp_Initialize;
end;

class function TCore.Obj: TCore;
begin
  if MyObject = nil then MyObject := TCore.Create(nil);
  Result := MyObject;
end;

end.
