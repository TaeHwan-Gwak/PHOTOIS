import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:photois/common/ext.string.dart';
import 'package:photois/model/user_model.dart';
import 'package:photois/setting.dart';

class Account extends GetxService {
  UserModel? _user;
  UserModel get user => _user!;
  String get uid => _user?.uid ?? 'null';

  Future<bool> tryLogin(String uid) async {
    try {
      if (kDebugMode && kDevUseTempUser) {
        _user = UserModel.temp();
        return true;
      }

      _user = await UserModel.fetch(uid);

      'SUCCESS Account.tryLogin: ${_user!.toJson()}'.log();
      return true;
    } catch (e) {
      'FAILED Account.tryLogin: $e'.log();
    }
    return false;
  }
}
