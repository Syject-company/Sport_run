import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/enjoy_response_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class EnjoyApi {
  final String _urlEnjoyList =
      '${Constants.domain}${Constants.getEnjoyModelUrl}';

  //@get
  Future<List<EnjoyResponseModel>?> getEnjoyList() async {
    final String token = PreferenceUtils.getUserToken();
    final Response res =
        await get(Uri.parse(_urlEnjoyList), headers: <String, String>{
      HttpHeaders.contentTypeHeader: 'application/json',
      HttpHeaders.authorizationHeader: token,
    });

    if (res.statusCode == 200) {
      return (json.decode(res.body) as List<dynamic>)
          .map<EnjoyResponseModel>((dynamic value) =>
              EnjoyResponseModel.fromJson(value as Map<String, dynamic>))
          .toList();
    }

    return null;
  }
}
