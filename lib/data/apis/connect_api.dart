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
    final token = PreferenceUtils.getUserToken();

    final url = '${Constants.domain}${Constants.connectUrl}$isFilterIncluded';

    //NOTE: queryParameters should be strings, otherwise error when parse
    final queryParameters = {
      'PaceFrom': paceFrom.toString(),
      'PaceTo': paceTo.toString(),
      'WeeklyDistanceFrom': weeklyDistanceFrom.toString(),
      'WeeklyDistanceTo': weeklyDistanceTo.toString(),
      'WorkoutsPerWeek': workoutsPerWeek.toString(),
    };

    final uri = isFilterIncluded
        ? Uri.parse(url).replace(queryParameters: queryParameters)
        : Uri.parse(url);

    final res = await get(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (res.statusCode == 200) {
      return json
          .decode(res.body)
          .map<ConnectUsersModel>((model) => ConnectUsersModel.fromJson(model))
          .toList();
    }
    return null;
  }
}
