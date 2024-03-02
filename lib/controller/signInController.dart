import 'package:get/get.dart';

class SignInController extends GetxController {
  var isPasswordVisible = false.obs;
  var isEmailValid = false.obs;
  var isPasswordEntered = false.obs;

  void togglePasswordVisibility() {
    isPasswordVisible.toggle();
  }

  void checkEmail(String email) {
    isEmailValid.value =
        RegExp(r'\b[\w\.-]+@[\w\.-]+\.\w{2,4}\b').hasMatch(email);
  }

  void setPasswordEntered(String password) {
    isPasswordEntered.value = password.isNotEmpty;
  }

  void reset() {
    isEmailValid.value = false;
    isPasswordVisible.value = false;
    isPasswordEntered.value = false;
  }

  @override
  void onClose() {
    reset();
    super.onClose();
  }
}
