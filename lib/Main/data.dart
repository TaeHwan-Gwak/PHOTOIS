import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SizeController extends GetxController {
  RxDouble screenWidth = MediaQuery.of(Get.context!).size.width.obs;
  RxDouble screenHeight = MediaQuery.of(Get.context!).size.height.obs;

  RxDouble bigFontSize = (MediaQuery.of(Get.context!).size.width * 0.07).obs;
  RxDouble middleFontSize = (MediaQuery.of(Get.context!).size.width * 0.04).obs;
  RxDouble mainFontSize = (MediaQuery.of(Get.context!).size.width * 0.05).obs;
}

class UserInfo extends GetxController {
  final nickname = ''.obs;
  //회원 닉네임(필수 입력)
  RxInt checkPhotographer = 0.obs;
  //1이면 포토그래퍼, 2면 일반 사용자
  final instagramID = ''.obs;
  //회원 인스타그램 아이디(선택)
  RxInt checkCategory = 0.obs;
  //1이면 나홀로 인생샷, 2면 애인과 커플샷, 3이면 친구와 우정샷, 4면 가족과 추억샷

  @override
  void onInit() {
    super.onInit();

    once(nickname, (_) {
      print('닉네임이 $_으로 처음 설정되었습니다.');
    });

    ever(nickname, (_) {
      print('닉네임이 $_으로 변경되었습니다.');
    });
  }
}

class PhotoSpotInfo extends GetxController {
  RxBool checkPickedFile = false.obs;
  RxInt spotCategory = 0.obs;
  Rx<DateTime> spotDate = DateTime(0, 0, 0, 0, 0).obs;
  RxInt spotTimeHour = 0.obs;
  RxInt spotTimeMinute = 0.obs;
  List<bool> spotTimePeriod = [true, false].obs; // [AM, PM]
  RxInt spotWeather = 0.obs;
  RxString spotMainAddress = ''.obs;
  RxString spotExtraAddress = ''.obs;
  RxString spotContent = ''.obs;
  RxDouble spotLatitude = 0.0.obs;
  RxDouble spotLongitude = 0.0.obs;

  int getStartHour() {
    if (spotTimePeriod[0] == true) {
      return 0;
    } else {
      return 12;
    }
  }

  void removeData() {
    checkPickedFile.value = false;
    spotCategory.value = 0;
    spotDate.value = DateTime(0, 0, 0, 0, 0);
    spotTimeHour.value = 0;
    spotTimeMinute.value = 0;
    spotTimePeriod = [true, false]; // [AM, PM]
    spotWeather.value = 0;
    spotMainAddress.value = '';
    spotExtraAddress.value = '';
    spotContent.value = '';
    spotLatitude.value = 0.0;
    spotLongitude.value = 0.0;
  }

  void printInfo() {
    print('checkPickedFile: ${checkPickedFile.value}');
    print('spotCategory: ${spotCategory.value}');
    print('spotDate: ${spotDate.value}');
    print('spotTimeHour: ${spotTimeHour.value}');
    print('spotTimeMinute: ${spotTimeMinute.value}');
    print('spotTimePeriod: $spotTimePeriod');
    print('spotWeather: ${spotWeather.value}');
    print('spotMainAddress: ${spotMainAddress.value}');
    print('spotExtraAddress: ${spotExtraAddress.value}');
    print('spotLatitude: ${spotLatitude.value}');
    print('spotLongitude: ${spotLongitude.value}');
  }
}
