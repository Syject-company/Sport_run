import 'dart:convert';

import 'package:one2one_run/data/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin PreferenceUtils {
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

  static bool getIsUserUnitInKM() {
    return _prefsInstance?.getBool(userUnit) ?? true;
  }

  static Future<void> setIsUserUnitInKM(bool value) async {
    await _prefsInstance?.setBool(userUnit, value);
  }

  static UserModel getCurrentUserModel() {
    return UserModel.fromJson(
        json.decode(_prefsInstance?.getString(userModelKey) ?? '')
            as Map<String, dynamic>);
  }

  static Future<void> setCurrentUserModel(UserModel value) async {
    await _prefsInstance?.setString(userModelKey, json.encode(value));
  }

  static bool getIsLoginFAQHelperShown() {
    return _prefsInstance?.getBool(loginFAQHelper) ?? false;
  }

  static Future<void> setIsLoginFAQHelperShown(bool value) async {
    await _prefsInstance?.setBool(loginFAQHelper, value);
  }

  static bool getIsInteractFAQHelperShown() {
    return _prefsInstance?.getBool(interactFAQHelper) ?? false;
  }

  static Future<void> setIsInteractFAQHelperShown(bool value) async {
    await _prefsInstance?.setBool(interactFAQHelper, value);
  }
}

String get isUserAuthenticated => 'is_user_authenticated';

String get userToken => 'user_token';

String get pageRout => 'page_rout';

String get userNickName => 'user_nickname';

String get userUnit => 'user_unit';

String get userModelKey => 'user_model';

String get loginFAQHelper => 'login_faq_helper';

String get interactFAQHelper => 'interact_faq_helper';
