import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';

class SignUpController extends GetxController {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  var nameController = TextEditingController();
  var isLoading = false.obs;

  void signUpUser() async {
    isLoading.value = true;
    String res = await AuthServices().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      name: nameController.text,
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
    nameController.dispose();
    super.onClose();
  }
}
