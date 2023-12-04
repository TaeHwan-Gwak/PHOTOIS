import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/model/user_model.dart';
import 'package:photois/service/firebase.auth.dart';
import 'package:photois/setting.dart';

class Account extends GetxService {
  Future<UserModel?> tryLogin(String uid) async {
    try {
      return await UserModel.fetch(uid);
    } catch (e) {
      'FAILED Account.tryLogin: $e'.log();
    }
    return null;
  }
}

class AccountController extends GetxController {
  final Account accountService;

  AccountController({required this.accountService});

  UserModel? _user;

  UserModel? get user => _user;

  String get uid => _user?.uid ?? 'null';

  tryLogin() async {
    try {
      if (kDebugMode && kDevUseTempUser) {
        _user = UserModel.temp();
        return true;
      } else {
        _user = await accountService.tryLogin(uid);
      }
    } catch (e, track) {
      debugPrint('error in accountContoller tryLogin $e, $track');
    } finally {
      'SUCCESS Account.tryLogin: ${_user?.toJson()}'.log();
    }
  }

  getUserInfo(User? user) {
    if (user == null) {
      _user = UserModel.temp();
      return true;
    } else {
      _user = UserModel(
        uid: user.uid,
        nickname: user.displayName ?? 'email',
        email: user.email ?? '',
        phoneNumber: user.phoneNumber ?? '',
        type: UserType.normal,
        category: PrefferedCategory.family,
      );
    }
  }

  updateNickname(String nickname) {
   _user = _user!.copyWith(nickname: nickname);
    update();
  }

  changeUserType(UserType type) {
    _user = _user!.copyWith(type: type);
    update();
  }

  changeUserCategory(PrefferedCategory category) {
    _user = _user!.copyWith(category: category);
    update();
  }

  changeUserNumber(String phoneNumber) {
    _user = _user!.copyWith(phoneNumber: phoneNumber);
    update();
  }

}
