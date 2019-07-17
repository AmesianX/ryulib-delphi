unit TaskQueue;

interface

uses
  DebugTools, RyuLibBase, SimpleThread, SuspensionQueue,
  SysUtils, Classes;

type
  TTaskEnvet = procedure (ASender:Tobject; const AData:pointer) of object;

  {*
    ó���ؾ� �� �۾��� ť�� �ְ� ���ʷ� �����Ѵ�.
    �۾��� ������ ������ �����带 �̿��ؼ� �񵿱�� �����Ѵ�.
    �۾� ��û�� �پ��� �����忡�� ����Ǵµ�, �������� ������ �ʿ� �� �� ����Ѵ�.
  }
  TTaskQueue = class
  private
    FQueue : TSuspensionQueue<pointer>;
  private
    FSimpleThread : TSimpleThread;
    procedure on_FSimpleThread_Execute(ASimpleThread:TSimpleThread);
  private
    FOnTask: TTaskEnvet;
  public
    constructor Create;
    destructor Destroy; override;

    procedure Add(AData:pointer);
  public
    property OnTask : TTaskEnvet read FOnTask write FOnTask;
  end;

implementation

procedure TTaskQueue.Add(AData:pointer);
begin
  FQueue.Push(Adata);
end;

constructor TTaskQueue.Create;
begin
  inherited;

  FQueue := TSuspensionQueue<pointer>.Create;
  FSimpleThread := TSimpleThread.Create('TTaskQueue', on_FSimpleThread_Execute);
end;

destructor TTaskQueue.Destroy;
begin
  FSimpleThread.Terminate;
  FSimpleThread.WakeUp;

  inherited;
end;

procedure TTaskQueue.on_FSimpleThread_Execute(ASimpleThread: TSimpleThread);
var
  item : pointer;
begin
  while ASimpleThread.Terminated = false do begin
    item := FQueue.Pop;
    try
      if Assigned(FOnTask) then FOnTask(Self, item);
    except
      on E: Exception do Trace('TTaskQueue.on_FSimpleThread_Execute - ' + E.Message);
    end;
  end;

  FreeAndNil(FQueue);
  FreeAndNil(FSimpleThread);
end;

end.



