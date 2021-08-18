class Constants {
  //domain
  static const String domain = 'https://one2onerunapi.azurewebsites.net';

  //pager routs:
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String runnersDataRoute = '/runnersData';
  static const String homeRoute = '/home';
  static const String passwordRoute = '/password';
  static const String editProfileRoute = '/editProfile';

  //Api urls:
  static const String registerUrl = '/api/Account/registration';
  static const String logInUrl = '/api/Account/login';
  static const String registerGoogleUrl = '/api/Account/Login/Google';
  static const String registerAppleUrl = '/api/Account/Login/Apple';
  static const String runnersDataUrl = '/api/Account/PrimayData';
  static const String changePasswordUrl = '/api/Account/ForgotPassword';
  static const String codeVerificationUrl = '/api/Account/CodeVerification';
  static const String updatePasswordUrl = '/api/Account/ChangePassword';
  static const String getUserModelUrl = '/api/Account';
  static const String editUserModelUrl = '/api/Account';
  static const String updateUserPhotoUrl = '/api/Account/Photo';
  static const String connectUrl = '/api/Battle/Users/';
  static const String createBattleUrl = '/api/Battle';
  static const String sendFireBaseTokenUrl = '/api/Account/FirebaseToken/';
  static const String enableNotificationsUrl = '/api/Account/MuteNotifications';
  static const String getNotificationsStateUrl = '/api/Account/NotificationsMode';

  //Data:
  static const String socketUrl = 'https://one2onerunapi.azurewebsites.net/chathub';

}
