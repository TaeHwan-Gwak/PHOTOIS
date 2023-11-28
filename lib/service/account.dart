import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/model/user_model.dart';
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

  // 계정 변경 가정했을 때
  changeUser() async {
    _user = UserModel(
      uid: 'uid',
      nickname: 'nickname',
      email: 'email',
      type: UserType.normal,
      category: PrefferedCategory.family,
      createdAt: DateTime.now(),
    );
    update();
  }
}
