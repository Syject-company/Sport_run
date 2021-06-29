import 'dart:convert';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/user_model.dart';
import 'package:one2one_run/data/models/user_profile_request_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class HomeApi {
  final String _urlUserModel =
      '${Constants.domain}${Constants.getUserModelUrl}';

  final String _urlUserModelUpdate =
      '${Constants.domain}${Constants.editUserModelUrl}';

  //@get
  Future<UserModel?> getUserModel() async {
    final token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final res = await get(Uri.parse(_urlUserModel), headers: {
      'Content-Type': 'application/json',
      'authorization': token,
    });

    return UserModel.fromJson(json.decode(res.body));
  }

  //@put
  Future<bool> saveUserModel({required UserProfileRequestModel model}) async {
    final token = PreferenceUtils.getUserToken();
    final res = await put(Uri.parse(_urlUserModelUpdate),
        body: json.encode(model),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
        });

    return res.statusCode == 200;
  }
}
