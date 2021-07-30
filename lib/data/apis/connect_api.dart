import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/connect_users_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class ConnectApi {
  //@get
  Future<List<ConnectUsersModel>?> getUsersConnect({
    required bool isFilterIncluded,
    required double? paceFrom,
    required double? paceTo,
    required double? weeklyDistanceFrom,
    required double? weeklyDistanceTo,
    required int? workoutsPerWeek,
  }) async {
    final String token = PreferenceUtils.getUserToken();

    final String url =
        '${Constants.domain}${Constants.connectUrl}$isFilterIncluded';

    //NOTE: queryParameters should be strings, otherwise error when parse
    final Map<String, String> queryParameters = <String, String>{
      'PaceFrom': paceFrom.toString(),
      'PaceTo': paceTo.toString(),
      'WeeklyDistanceFrom': weeklyDistanceFrom.toString(),
      'WeeklyDistanceTo': weeklyDistanceTo.toString(),
      'WorkoutsPerWeek': workoutsPerWeek.toString(),
    };

    final Uri uri = isFilterIncluded
        ? Uri.parse(url).replace(queryParameters: queryParameters)
        : Uri.parse(url);

    final Response res = await get(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
    );
    //  List<Map<String, dynamic>>
    if (res.statusCode == 200) {
      return (json.decode(res.body) as List<dynamic>)
          .map<ConnectUsersModel>((dynamic model) {
        return ConnectUsersModel.fromJson(model as Map<String, dynamic>);
      }).toList();
    }
    return null;
  }
}
