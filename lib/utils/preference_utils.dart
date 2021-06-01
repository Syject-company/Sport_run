import 'package:shared_preferences/shared_preferences.dart';

class PreferenceUtils {
  static SharedPreferences? _prefsInstance;

  static Future<SharedPreferences?> init() async {
    return await SharedPreferences.getInstance();
  }

  static bool getIsTermsAccepted() {
    return _prefsInstance?.getBool(isTermsAccepted) ?? false;
  }

  static Future<void> setIsTermsAccepted(bool value) async {
    await _prefsInstance?.setBool(isTermsAccepted, value);
  }
}

String get isTermsAccepted => 'is_terms_accepted';
