import 'dart:convert';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class InteractApi {
  final String _urlGetTabById =
      '${Constants.domain}${Constants.createBattleUrl}';

  //@get
  Future<List<BattleRespondModel>?> getInteractTabsDataById(
      {required int tabId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res =
        await get(Uri.parse('$_urlGetTabById/$tabId'), headers: <String,String>{
      'Content-Type': 'application/json',
      'authorization': token,
    });

    if (res.statusCode == 200) {
      return (json.decode(res.body) as List<dynamic>)
          .map<BattleRespondModel>((dynamic model) =>
              BattleRespondModel.fromJson(model as Map<String, dynamic>))
          .toList();
    }
    return null;
  }
}
