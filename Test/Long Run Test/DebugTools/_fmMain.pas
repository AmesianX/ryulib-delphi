{*
  DebugTools ���ֿ��� �߻��� ������ �ƴ� ���̶� ����������,
  ���� �� ���μ������� ������ �߻��� ������ �ǽɵǾ� �շ� �׽�Ʈ�� �ۼ��ߴ�.
}
unit _fmMain;

interface

uses
  DebugTools, SimpleThread, RyuLibBase,
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls;

type
  TfmMain = class(TForm)
    procedure FormCreate(Sender: TObject);
  private
  public
  end;

var
  fmMain: TfmMain;

implementation

{$R *.dfm}

procedure TfmMain.FormCreate(Sender: TObject);
var
  Loop: Integer;
begin
  for Loop := 1 to 32 do begin
    TSimpleThread.Create(
      '', nil,
      procedure (ASimpleThread:TSimpleThread)
      begin
        while true do begin
          if TraceCount < 1024 then Trace( 'TfmMain.FormCreate' );
          Sleep(5);
        end;
      end
    );
  end;
end;

end.
