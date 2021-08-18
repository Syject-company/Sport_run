import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/battle_request_model.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/change_battle_conditions_model.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/data/models/user_profile_request_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class HomeApi {
  final String _urlUserModel =
      '${Constants.domain}${Constants.getUserModelUrl}';

  final String _urlUserModelUpdate =
      '${Constants.domain}${Constants.editUserModelUrl}';

  final String _urlCreateBattle =
      '${Constants.domain}${Constants.createBattleUrl}';

  final String _urlSendFirebaseToken =
      '${Constants.domain}${Constants.sendFireBaseTokenUrl}';

  final String _urlGetBattleById =
      '${Constants.domain}${Constants.createBattleUrl}';

  //@get
  Future<UserModel?> getUserModel() async {
    final String token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final Response res =
        await get(Uri.parse(_urlUserModel), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token,
    });

    return UserModel.fromJson(json.decode(res.body) as Map<String, dynamic>);
  }

  //@put
  Future<bool> saveUserModel({required UserProfileRequestModel model}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await put(Uri.parse(_urlUserModelUpdate),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@post
  Future<bool> createBattle({required BattleRequestModel model}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await post(Uri.parse(_urlCreateBattle),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
          'accept': '*/*',
        });

    return res.statusCode == 200;
  }

  //@post
  Future<bool> sendFireBaseToken({required String tokenFireBase}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await post(
        Uri.parse('$_urlSendFirebaseToken$tokenFireBase'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@get
  Future<BattleRespondModel?> getBattleById({
    required String battleId,
  }) async {
    final String token = PreferenceUtils.getUserToken();
    final Map<String, String> queryParameters = <String, String>{
      'id': battleId
    };

    final Uri uri =
        Uri.parse(_urlGetBattleById).replace(queryParameters: queryParameters);

    final Response res = await get(
      uri,
      headers: <String, String>{
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: token,
      },
    );

    if (res.statusCode == 200) {
      return BattleRespondModel.fromJson(
          json.decode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  //@post
  Future<bool> acceptBattle({required String battleId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await post(
        Uri.parse('$_urlGetBattleById/$battleId/Accept'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@post
  Future<bool> declineBattle({required String battleId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await post(
        Uri.parse('$_urlGetBattleById/$battleId/Decline'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@post
  Future<bool> applyBattleChanges(
      {required ChangeBattleConditionsModel model,
      required String battleId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await patch(Uri.parse('$_urlGetBattleById/$battleId'),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }
}
