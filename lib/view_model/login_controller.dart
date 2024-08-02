import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';

class LoginController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var isLoading = false.obs;

  var emailError = RxString('');
  var passwordError = RxString('');

  void loginUsers() async {
    emailError.value = '';
    passwordError.value = '';

    if (emailController.text.isEmpty) {
      emailError.value = 'Email cannot be empty';
      return;
    }

    if (passwordController.text.isEmpty) {
      passwordError.value = 'Password cannot be empty';
      return;
    }

    isLoading.value = true;
    String res = await AuthServices().loginUser(
      email: emailController.text,
      password: passwordController.text,
    );

    if (res == "success") {
      Get.off(() => HomeScreen());
    } else {
      isLoading.value = false;
      showSnackBar(Get.context!, res);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
