import 'dart:convert';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/register_google_appple_model.dart';
import 'package:one2one_run/data/models/register_model.dart';
import 'package:one2one_run/data/models/register_response_google_appple_model.dart';
import 'package:one2one_run/data/models/register_response_model.dart';
import 'package:one2one_run/utils/constants.dart';

class RegisterApi {
  final String _urlRegister = '${Constants.domain}${Constants.registerUrl}';
  final String _urlRegisterGoogle =
      '${Constants.domain}${Constants.registerGoogleUrl}';
  final String _urlRegisterApple =
      '${Constants.domain}${Constants.registerAppleUrl}';

  //@post
  Future<Response> registerEmail(RegisterModel model) async {
    final res = await post(Uri.parse(_urlRegister),
        body: json.encode(model),
        headers: {'Content-Type': 'application/json'});
    return res;
  }

  //@post
  Future<RegisterResponseGoogleAppleModel?> registerGoogle(
      RegisterGoogleAppleModel model) async {
    final res = await post(Uri.parse(_urlRegisterGoogle),
        body: json.encode(model),
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      return RegisterResponseGoogleAppleModel.fromJson(json.decode(res.body));
    }

    return null;
  }

  //@post
  Future<RegisterResponseGoogleAppleModel?> registerApple(
      RegisterGoogleAppleModel model) async {
    final res = await post(Uri.parse(_urlRegisterApple),
        body: json.encode(model),
        headers: {'Content-Type': 'application/json'});
    if (res.statusCode == 200) {
      return RegisterResponseGoogleAppleModel.fromJson(json.decode(res.body));
    }

    return null;
  }
}
