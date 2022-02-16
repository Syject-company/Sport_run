import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class RunnerDataApi {
  final String _urlRunnerData =
      '${Constants.domain}${Constants.runnersDataUrl}';

  //@patch
  Future<bool> sendRunnerData(RunnerDataModel model) async {
    final String token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final Response res = await patch(Uri.parse(_urlRunnerData),
        body: json.encode(model),
        headers: <String, String>{
          HttpHeaders.contentTypeHeader: 'application/json',
          HttpHeaders.authorizationHeader: token,
        });

    return res.statusCode == 200;
  }
}
