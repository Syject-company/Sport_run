import 'dart:convert';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class InteractApi {
  final String _urlGetTabById =
      '${Constants.domain}${Constants.createBattleUrl}';

  //@get
  Future<BattleRespondModel?> applyBattleChanges({required int tabId}) async {
    final token = PreferenceUtils.getUserToken();
    final res = await get(Uri.parse('$_urlGetTabById/$tabId'), headers: {
      'Content-Type': 'application/json',
      'authorization': token,
    });

    if (res.statusCode == 200) {
      return BattleRespondModel.fromJson(json.decode(res.body));
    }
    return null;
  }
}
