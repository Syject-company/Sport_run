import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:one2one_run/data/models/battle_respond_model.dart';
import 'package:one2one_run/data/models/opponent_chat_model.dart';
import 'package:one2one_run/data/models/register_response_google_appple_model.dart';
import 'package:one2one_run/utils/preference_utils.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import 'constants.dart';

extension EmailValidator on String {
  bool isValidEmailInput() {
    return RegExp(
            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
        .hasMatch(this);
  }

  bool isValidPasswordInput() {
    return RegExp(r'^(?=.*[a-z])').hasMatch(this);
  }
}

extension DateTimeExtension on void {
  String getFormattedDate({
    required DateTime date,
    required TimeOfDay time,
  }) {
    return DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }

  String getFormattedDateForUser({
    required DateTime date,
    required TimeOfDay time,
  }) {
    return DateFormat('yyyy-MM-dd HH:mm').format(
        DateTime(date.year, date.month, date.day, time.hour, time.minute)
            .toLocal());
  }

//0001-01-01T00:00:00
  String getFormattedTimeForServer({
    required String time,
  }) {
    return '0001-01-01T$time';
  }

//00:00
  String getFormattedTimeForUser({
    required TimeOfDay time,
  }) {
    return DateFormat('HH:mm').format(DateTime(DateTime.now().year,
            DateTime.now().month, DateTime.now().day, time.hour, time.minute)
        .toLocal());
  }

  String getTimeStringFromDouble(double value) {
    final int flooredValue = value.floor();
    final double decimalValue = value - flooredValue;
    final String hourValue = getHourString(flooredValue);
    final String minuteString = getMinuteString(decimalValue);

    return '$hourValue.$minuteString';
  }

  String getMinuteString(double decimalValue) {
    return '${(decimalValue * 60).toInt()}'.padLeft(2, '0');
  }

  String getHourString(int flooredValue) {
    return '${flooredValue % 24}'.padLeft(2, '0');
  }
}

extension ToastExtension on void {
  Future<void> toastUnexpectedError() {
    return Fluttertoast.showToast(
        msg: 'Unexpected error happened',
        fontSize: 16.0,
        gravity: ToastGravity.CENTER);
  }
}

extension UserData on void {
  num getDistance({required num distance}) {
    if (PreferenceUtils.getIsUserUnitInKM()) {
      if (distance > 11) {
        return 11.0;
      }
      if (distance < 2) {
        return 2.0;
      }
    } else {
      if (distance > 18) {
        return 18.0;
      }
      if (distance < 3) {
        return 3.0;
      }
    }

    return distance;
  }

  String distance({required num distance}) {
    return PreferenceUtils.getIsUserUnitInKM()
        ? '${getDistance(distance: distance).toStringAsFixed(0)} km'
        : '${getDistance(distance: distance).toStringAsFixed(1)} mile';
  }

  String getOpponentName({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.nickName;
    }

    return model.battleUsers[1].applicationUser.nickName;
  }

  String? getOpponentPhoto({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.photoLink;
    }

    return model.battleUsers[1].applicationUser.photoLink;
  }

  String getOpponentRank({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.rank.toString();
    }

    return model.battleUsers[1].applicationUser.rank.toString();
  }

  int? getMyBattleStatus({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return model.battleUsers[0].batlleStatus?.toInt();
    }

    return model.battleUsers[1].batlleStatus?.toInt();
  }

//0001-01-01T00:00:00
  String getMyProofTime({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return getTimeWithOutDate(time: model.battleUsers[0].time);
    }

    return getTimeWithOutDate(time: model.battleUsers[1].time);
  }

  List<dynamic> getMyProofPhotos({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id == currentUserId) {
      return model.battleUsers[0].photos;
    }

    return model.battleUsers[1].photos;
  }

  String getOpponentProofTime({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return getTimeWithOutDate(time: model.battleUsers[0].time);
    }

    return getTimeWithOutDate(time: model.battleUsers[1].time);
  }

  List<dynamic> getOpponentProofPhotos({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].photos;
    }

    return model.battleUsers[1].photos;
  }

  bool isNeedToCheckOpponentResults({required BattleUsers model}) =>
      model.photos != null &&
      model.photos.isNotEmpty &&
      !model.resultIsRejected &&
      !model.resultIsConfirmed;

  BattleUsers getOpponentBattleModel({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0];
    }

    return model.battleUsers[1];
  }

  //0001-01-01T00:00:00
  String getTimeWithOutDate({required String time}) {
    return time.substring(11, 19);
  }

  String getDateWithOutTime({required String date}) {
    return date.substring(0, 10);
  }

  String getOpponentId({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].applicationUser.id;
    }

    return model.battleUsers[1].applicationUser.id;
  }

  Messages? getChatMessageData({required List<Object> arguments}) {
    final Object data = arguments[0];
    if (data != null) {
      final Map<dynamic, dynamic> dataMessage = data as Map<dynamic, dynamic>;
      final Messages model =
          Messages.fromJson(dataMessage as Map<String, dynamic>);
      return model;
    }
    return null;
  }

  bool getIfOpponentCreatedTheBattle({
    required BattleRespondModel model,
    required String currentUserId,
  }) {
    if (model.battleUsers[0].applicationUser.id != currentUserId) {
      return model.battleUsers[0].isCreater;
    }

    return model.battleUsers[1].isCreater;
  }
}

extension Authorization on void {
  Future<void> signInWithApple(
      {required BuildContext context,
      required Function(String token) onSuccess}) async {
    await SignInWithApple.getAppleIDCredential(
        scopes: <AppleIDAuthorizationScopes>[
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: Constants.clientAppleServiceId,
          redirectUri: Uri.parse(Constants.redirectAppleUri),
        )).then((AuthorizationCredentialAppleID value) async {
      final String? token = value.identityToken;
      if (token != null) {
        onSuccess(token);
      }
    }).catchError((Object err) async {
      print('SignInWithApple: $err');
      await Fluttertoast.showToast(
          msg: 'Login error', fontSize: 16.0, gravity: ToastGravity.CENTER);
    });
  }

  Future<void> signInWithGoogle(
      {required BuildContext context,
      required Function(String token) onSuccess}) async {
    await GoogleSignIn().signIn().then((GoogleSignInAccount? result) {
      result?.authentication.then((GoogleSignInAuthentication googleKey) async {
        print(googleKey.accessToken);
        final String? token = googleKey.accessToken;
        if (token != null) {
          onSuccess(token);
        }
      }).catchError((Object err) {
        print('inner error');
      });
    }).catchError((Object err) async {
      print('error occurred');
      await Fluttertoast.showToast(
          msg: 'Registration error',
          fontSize: 16.0,
          gravity: ToastGravity.CENTER);
    });
  }
}
