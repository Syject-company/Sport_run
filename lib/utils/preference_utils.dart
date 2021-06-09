import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<void> init() async {
    _prefsInstance = await SharedPreferences.getInstance();
  }

  static bool getIsUserAuthenticated() {
    return _prefsInstance?.getBool(isUserAuthenticated) ?? false;
  }

  static Future<void> setIsUserAuthenticated(bool value) async {
    await _prefsInstance?.setBool(isUserAuthenticated, value);
  }

  static String getUserToken() {
    return _prefsInstance?.getString(userToken) ?? '';
  }

  static Future<void> setUserToken(String value) async {
    print('User token: Bearer $value');
    await _prefsInstance?.setString(userToken, 'Bearer $value');
  }
}

String get isUserAuthenticated => 'is_user_authenticated';

String get userToken => 'user_token';
