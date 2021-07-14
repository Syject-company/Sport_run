class Constants {
  //domain
  static const String domain = 'https://one2onerunapi.azurewebsites.net';

  //pager routs:
  static const loginRoute = '/login';
  static const registerRoute = '/register';
  static const runnersDataRoute = '/runnersData';
  static const homeRoute = '/home';
  static const passwordRoute = '/password';
  static const editProfileRoute = '/editProfile';
  static const userInfoRoute = '/userInfo';

  //Api urls:
  static const registerUrl = '/api/Account/registration';
  static const logInUrl = '/api/Account/login';
  static const registerGoogleUrl = '/api/Account/Login/Google';
  static const registerAppleUrl = '/api/Account/Login/Apple';
  static const runnersDataUrl = '/api/Account/PrimayData';
  static const changePasswordUrl = '/api/Account/ForgotPassword';
  static const codeVerificationUrl = '/api/Account/CodeVerification';
  static const updatePasswordUrl = '/api/Account/ChangePassword';
  static const getUserModelUrl = '/api/Account';
  static const editUserModelUrl = '/api/Account';
  static const updateUserPhotoUrl = '/api/Account/Photo';
  static const connectUrl = '/api/Battle/Users/';
  static const createBattleUrl = '/api/Battle';
  static const sendFireBaseTokenUrl = '/api/Account/FirebaseToken/';

}
