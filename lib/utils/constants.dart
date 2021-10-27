class Constants {
  //domain
  //Test domain
 // static const String domain = 'https://one2oneruntestapi.azurewebsites.net';
  //Main domain
  static const String domain = 'https://one2onerunapi.azurewebsites.net';

  //pager routs:
  static const String loginRoute = '/login';
  static const String registerRoute = '/register';
  static const String runnersDataRoute = '/runnersData';
  static const String homeRoute = '/home';
  static const String passwordRoute = '/password';
  static const String editProfileRoute = '/editProfile';
  static const String faqHelperRoute = '/faqHelper';
  static const String configurationRoute = '/configuration';

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
  static const String getOpponentChatUrl = '/api/Chats/';
  static const String sendFireBaseTokenUrl = '/api/Account/FirebaseToken/';
  static const String enableNotificationsUrl = '/api/Account/MuteNotifications';
  static const String getNotificationsStateUrl = '/api/Account/NotificationsMode';
  static const String sendResultPhotoUrl = '/api/Battle/Photo';
  static const String getEnjoyModelUrl = '/api/Enjoy';
  static const String getImageShareUrl = '/api/Share/Battle/';

  //Data:
  //Main domain
  //static const String socketUrl = 'https://one2onerunapi.azurewebsites.net/chathub';
  //Test domain
  static const String socketUrl = 'https://one2oneruntestapi.azurewebsites.net/chathub';
  static const String socketConnectToGroups = 'ConnectToGroups';
  static const String socketReceiveBattleNotification = 'ReceiveBattleNotification';
  static const String socketReceiveMessage = 'ReceiveMessage';
  static const String socketSendMessage = 'SendMessage';
  static const String redirectAppleUri = 'https://fluoridated-married-aristosuchus.glitch.me/callbacks/sign_in_with_apple';
  static const String clientAppleServiceId = 'com.one2one.one2oneRun.signin';

  static const String filterMenuThree = '3';
  static const String filterMenuFive = '5';
  static const String filterMenuTen = '10';
  static const String filterMenuHalfMarathon = 'Half Marathon';
  static const String filterMenuMarathon = 'Marathon';
  static const String filterMenuCustom = 'Custom';

}
