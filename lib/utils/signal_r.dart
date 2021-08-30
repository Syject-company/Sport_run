import 'package:signal_r/signalr_client.dart';
import 'package:one2one_run/utils/constants.dart';

 class SignalR {
  HubConnection? _hubConnection;

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

  Future<void> startConnection(
      {required Function(List<Object> arguments) onReceiveNotification}) async {
    await _startWebSocket();
 /*   await _hubConnection?.invoke('ConnectToGroups');
    _hubConnection?.on('ReceiveBattleNotification', onReceiveNotification);*/
    // TODO: check on back error
    await _hubConnection?.invoke('ConnectToGroups');
    await _hubConnection?.invoke('SendMessage',args: <Object>['Text', 'd77cd9d6-84bc-42fe-847a-dbe81a5b96ff']).then((dynamic value) {
      dynamic dd = value;
    }).catchError((dynamic value){
       dynamic dd = value;
    });
    _hubConnection?.on('ReceiveMessage', onReceiveNotification);
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
