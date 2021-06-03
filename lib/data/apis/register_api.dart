import 'dart:convert';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/register_model.dart';
import 'package:one2one_run/data/models/register_response_model.dart';
import 'package:one2one_run/utils/constants.dart';

class RegisterApi {
  final String _urlRegister = '${Constants.domain}${Constants.registerUrl}';

  //@post
  Future<RegisterResponseModel?> register(RegisterModel model) async {
    final res = await post(Uri.parse(_urlRegister),
        body: json.encode(model),
        headers: {'Content-Type': 'application/json'});

    if (res.statusCode == 200) {
      return RegisterResponseModel.fromJson(json.decode(res.body));
    } else {
      return null;
    }
  }
}
