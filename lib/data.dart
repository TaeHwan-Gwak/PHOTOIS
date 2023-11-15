import 'package:get/get.dart';

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
  RxInt category = 0.obs;
}
