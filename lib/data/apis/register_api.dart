import 'dart:convert';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/register_model.dart';
import 'package:one2one_run/utils/constants.dart';

class RegisterApi {
  final String _urlRegister = '${Constants.domain}${Constants.registerUrl}';

  //@post
  Future<String> register(RegisterModel model) async {
    Response res = await post(Uri.parse(_urlRegister),
        body: json.encode(model),
        headers: {"Content-Type": "application/json"});

    if (res.statusCode == 201) {
      return '';
    } else {
      return 'Wrong data';
    }
  }
}
