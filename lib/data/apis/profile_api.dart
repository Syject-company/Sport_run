import 'dart:io';
import 'package:http/http.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class ProfileApi {
  final String _urlUserPhoto =
      '${Constants.domain}${Constants.updateUserPhotoUrl}';

  //post
  Future<bool> uploadImageProfile(File? fileImage) async {
    final token = PreferenceUtils.getUserToken();

    final request = MultipartRequest('POST', Uri.parse(_urlUserPhoto));

    final multipartFile = await MultipartFile.fromPath('file', fileImage!.path);

    request.headers.addAll({
      HttpHeaders.authorizationHeader: token,
      'Content-Type': 'multipart/form-data'
    });
    request.files.add(multipartFile);

    final response = await request.send();

    return response.statusCode == 200;
  }
}
