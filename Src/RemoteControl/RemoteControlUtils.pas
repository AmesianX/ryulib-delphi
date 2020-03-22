unit RemoteControlUtils;

interface

uses
  SuperSocketUtils,
  Classes, SysUtils;

type
  TPacketType = (
    ptNone=100,

    ptConnectionID,

    ptSetConnectionID,  // Ŭ���̾�Ʈ �ʿ��� ����(ȭ�������)�� ID�� �̿��ؼ� ������ ID�� ��ȯ�Ͽ� �����Ѵ�.
    ptErPeerConnected,  // �߸��� ����(ȭ�������)�� ID�� ���� �õ� �Ͽ���.
    ptPeerConnected,    // ����(ȭ�������)�� Ŭ���̾�Ʈ(����������)�� ����Ǿ���.
    ptPeerDisconnected, // ������ ������ ��������.

    ptKeyDown, ptKeyUp,
    ptMouseDown, ptMouseMove, ptMouseUp
  );

  TConnectionIDPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    ID : integer;
  end;
  PConnectionIDPacket = ^TConnectionIDPacket;

  TRemoteControlPacket = packed record
    PacketSize : word;
    PacketType : TPacketType;
    Key : word;
    X, Y : integer;
  end;
  PRemoteControlPacket = ^TRemoteControlPacket;

implementation

end.
