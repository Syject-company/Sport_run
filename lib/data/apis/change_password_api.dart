import 'dart:convert';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/change_pass_email_model.dart';
import 'package:one2one_run/data/models/code_verification_model.dart';
import 'package:one2one_run/data/models/update_password_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class ChangePasswordApi {
  final String _urlSendUserEmail =
      '${Constants.domain}${Constants.changePasswordUrl}';

  final String _urlCodeVerification =
      '${Constants.domain}${Constants.codeVerificationUrl}';

  final String _urlUpdatePasswordUrl =
      '${Constants.domain}${Constants.updatePasswordUrl}';

  //@post
  Future<String> sendUserEmailToGetCode(ChangePassEmailModel model) async {
    final res = await post(Uri.parse(_urlSendUserEmail),
        body: json.encode(model),
        headers: {
          'Content-Type': 'application/json',
        });

    if (res.statusCode == 200) {
      return '';
    } else {
      return res.reasonPhrase ?? 'error occurred';
    }
  }

  //@post
  Future<String> sendCodeVerification(CodeVerificationModel model) async {
    final res = await post(Uri.parse(_urlCodeVerification),
        body: json.encode(model),
        headers: {
          'Content-Type': 'application/json',
        });

    if (res.statusCode == 200) {
      return '';
    } else {
      return res.reasonPhrase ?? 'error occurred';
    }
  }

  //@patch
  Future<String> updatePassword(UpdatePasswordModel model) async {
    final res = await patch(Uri.parse(_urlUpdatePasswordUrl),
        body: json.encode(model),
        headers: {
          'Content-Type': 'application/json',
        });

    if (res.statusCode == 200) {
      return '';
    } else {
      return res.reasonPhrase ?? 'error occurred';
    }
  }
}
