import 'package:get/get.dart';

class RegisterController extends GetxController {
  RxString deviceId = ''.obs;
  RxString fullname = ''.obs;
  RxString username = ''.obs;
  RxString password = ''.obs;

  void updateDeviceId(String value) => deviceId.value = value;
  void updateFullname(String value) => fullname.value = value;
  void updateUsername(String value) => username.value = value;
  void updatePassword(String value) => password.value = value;
}
