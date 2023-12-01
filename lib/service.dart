import 'package:get/get.dart';
import 'package:photois/service/account.dart';

void initServices() {
  Get.put(Account());
  Get.put(AccountController(accountService: Get.find<Account>()),permanent: true);
}
