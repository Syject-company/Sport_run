import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/battle_result_model.dart';
import 'package:one2one_run/data/models/confirm_opponent_results_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class InteractApi {
  final String _urlGetTabById =
      '${Constants.domain}${Constants.createBattleUrl}';

  final String _urlGetOpponentChat =
      '${Constants.domain}${Constants.getOpponentChatUrl}';

  final String _urlSendResultPhoto =
      '${Constants.domain}${Constants.sendResultPhotoUrl}';

  final String _urlSendBattleResult =
      '${Constants.domain}${Constants.createBattleUrl}';

  final String _urlGetImageShare =
      '${Constants.domain}${Constants.getImageShareUrl}';

  //@get
  Future<List<BattleRespondModel>?> getInteractTabsDataById(
      {required int tabId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await get(Uri.parse('$_urlGetTabById/$tabId'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    if (res.statusCode == 200) {
      return (json.decode(res.body) as List<dynamic>)
          .map<BattleRespondModel>((dynamic model) =>
              BattleRespondModel.fromJson(model as Map<String, dynamic>))
          .toList();
    }
    return null;
  }

  //@get
  Future<OpponentChatModel?> getOpponentChatMessages(
      {required String opponentId}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res = await get(Uri.parse('$_urlGetOpponentChat$opponentId'),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    if (res.statusCode == 200) {
      return OpponentChatModel.fromJson(
          json.decode(res.body) as Map<String, dynamic>);
    }
    return null;
  }

  //@patch
  Future<String?> sendResultPhoto({required File? fileImage}) async {
    final String token = PreferenceUtils.getUserToken();

    final MultipartRequest request =
        MultipartRequest('PATCH', Uri.parse(_urlSendResultPhoto));

    final MultipartFile multipartFile =
        await MultipartFile.fromPath('Photo', fileImage!.path);

    request.headers.addAll(<String, String>{
      HttpHeaders.authorizationHeader: token,
      HttpHeaders.contentTypeHeader: 'multipart/form-data'
    });
    request.files.add(multipartFile);

    final StreamedResponse response = await request.send();

    //NOTE: to get the body response from StreamedResponse
    final Response responsePhoto = await Response.fromStream(response);

    if (responsePhoto.statusCode == 200) {
      return responsePhoto.body;
    }

    return null;
  }

  //@patch
  Future<bool> sendBattleResult(
      {required BattleResultModel model, required String id}) async {
    final String token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final Response res = await patch(
        Uri.parse('$_urlSendBattleResult/$id/Results'),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@post
  Future<bool> checkOpponentResults(
      {required String id, required ConfirmOpponentResultsModel model}) async {
    final String token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final Response res = await post(
        Uri.parse('$_urlSendBattleResult/$id/TimeConfirmation'),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }

  //@get
  Future<Uint8List?> getImageBattleShare({required String id}) async {
    final String token = PreferenceUtils.getUserToken();
    final Response res =
        await get(Uri.parse('$_urlGetImageShare$id/File'), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'image/png',
      HttpHeaders.authorizationHeader: token,
    });

    if (res.statusCode == 200 && res.bodyBytes != null) {
      return res.bodyBytes;
    }
  }
}
