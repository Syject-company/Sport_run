import 'dart:convert';

import 'package:http/http.dart';
import 'package:one2one_run/data/models/runner_data_model.dart';
import 'package:one2one_run/utils/constants.dart';
import 'package:one2one_run/utils/preference_utils.dart';

class RunnerDataApi {
  final String _urlRunnerData =
      '${Constants.domain}${Constants.runnersDataUrl}';

  //@patch
  Future<bool> sendRunnerData(RunnerDataModel model) async {
    final token = PreferenceUtils.getUserToken();
    print('User token: $token');
    final res = await patch(Uri.parse(_urlRunnerData),
        body: json.encode(model),
        headers: {
          'Content-Type': 'application/json',
          'authorization': token,
        });

    return res.statusCode == 200;
  }
}
