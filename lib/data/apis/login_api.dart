import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/access_user_model.dart';
import 'package:one2one_run/data/models/register_google_appple_model.dart';
import 'package:one2one_run/data/models/register_response_google_appple_model.dart';
import 'package:one2one_run/utils/constants.dart';

class LoginApi {
  final String _urlLogin = '${Constants.domain}${Constants.logInUrl}';
  final String _urlRegisterGoogle =
      '${Constants.domain}${Constants.registerGoogleUrl}';
  final String _urlRegisterApple =
      '${Constants.domain}${Constants.registerAppleUrl}';

  //@post
  Future<Response> loginEmail(AccessUserModel model) async {
    final Response res = await post(Uri.parse(_urlLogin),
        body: json.encode(model),
        headers: <String, String>{HttpHeaders.contentTypeHeader: 'application/json'});
    return res;
  }

  //@post
  Future<RegisterResponseGoogleAppleModel?> registerGoogle(
      RegisterGoogleAppleModel model) async {
    final Response res = await post(Uri.parse(_urlRegisterGoogle),
        body: json.encode(model),
        headers: <String,String>{HttpHeaders.contentTypeHeader: 'application/json'});

    if (res.statusCode == 200) {
      return RegisterResponseGoogleAppleModel.fromJson(
          json.decode(res.body) as Map<String, dynamic>);
    }

    return null;
  }

  //@post
  Future<RegisterResponseGoogleAppleModel?> registerApple(
      RegisterGoogleAppleModel model) async {
    final Response res = await post(Uri.parse(_urlRegisterApple),
        body: json.encode(model),
        headers: <String,String>{HttpHeaders.contentTypeHeader: 'application/json'});
    if (res.statusCode == 200) {
      return RegisterResponseGoogleAppleModel.fromJson(
          json.decode(res.body) as Map<String, dynamic>);
    }

    return null;
  }
}
