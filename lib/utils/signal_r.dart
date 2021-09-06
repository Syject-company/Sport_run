import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/enums.dart';
import 'package:signal_r/signalr_client.dart';

class SignalR {
  HubConnection? _hubConnection;
  InteractPageTab interactPageTab = InteractPageTab.NON;

  Future<void> initSocketConnection({required String token}) async {
    _hubConnection = HubConnectionBuilder()
        .withUrl(Constants.socketUrl,
            options: HttpConnectionOptions(
              accessTokenFactory: () async => token,
            ))
        .build();

    _hubConnection
        ?.onclose((Exception error) => print('Connection Closed $error'));
  }

  Future<void> startConnection() async {
    await _startWebSocket();
    await _hubConnection?.invoke(Constants.socketConnectToGroups);
  }

  Future<void> receiveBattleNotification(
      {required Function(List<Object> arguments) onReceiveNotification}) async {
    _hubConnection?.on(
        Constants.socketReceiveBattleNotification, onReceiveNotification);
  }

  Future<void> sendChatMessage(
      {required String message, required String id}) async {
    await _hubConnection
        ?.invoke(Constants.socketSendMessage, args: <Object>[message, id]);
  }

  Future<void> receiveChatMessage(
      {required InteractPageTab tab,
      required Function(List<Object> arguments) onReceiveChatMessage}) async {
    interactPageTab = tab;
    _hubConnection?.on(Constants.socketReceiveMessage, onReceiveChatMessage);
  }

  Future<void> stopReceiveChatMessageData() async {
    interactPageTab = InteractPageTab.NON;
    _hubConnection?.off(Constants.socketReceiveMessage);
  }

  Future<void> _startWebSocket() async {
    if (HttpConnection.connectionState == ConnectionSignalState.Disconnected) {
      await _hubConnection?.start().catchError((dynamic value) {
        if (value != null) {
          Future<dynamic>.delayed(const Duration(seconds: 1), () async {
            await _startWebSocket();
          });
        }
      });
    }
  }

  Future<void> stopConnection() async {
    await _hubConnection?.stop();
  }
}
