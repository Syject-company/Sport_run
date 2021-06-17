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

  static String getPageRout() {
    return _prefsInstance?.getString(pageRout) ?? 'Register';
  }

  static Future<void> setPageRout(String value) async {
    await _prefsInstance?.setString(pageRout, value);
  }

  static String getUserNickName() {
    return _prefsInstance?.getString(userNickName) ?? 'Register';
  }

  static Future<void> setUserNickName(String value) async {
    await _prefsInstance?.setString(userNickName, value);
  }
}

String get isUserAuthenticated => 'is_user_authenticated';

String get userToken => 'user_token';

String get pageRout => 'page_rout';

String get userNickName => 'user_nickname';
