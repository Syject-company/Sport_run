import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/settings_notification_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class SettingsApi {
  final String _urlEnableNotification =
      '${Constants.domain}${Constants.enableNotificationsUrl}';

  final String _urlGetNotificationState =
      '${Constants.domain}${Constants.getNotificationsStateUrl}';

  //@patch
  Future<bool> enableNotifications(SettingsNotificationModel model) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await patch(Uri.parse(_urlEnableNotification),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@get
  Future<SettingsNotificationModel?> getNotificationsState() async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await get(Uri.parse(_urlGetNotificationState),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    if (res.statusCode == 200) {
      return SettingsNotificationModel.fromJson(
          json.decode(res.body) as Map<String, dynamic>);
    }

    return null;
  }
}
