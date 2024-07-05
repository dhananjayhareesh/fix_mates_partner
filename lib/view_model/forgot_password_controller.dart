import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';

class ForgotPasswordController extends GetxController {
  var emailController = TextEditingController();
  var isLoading = false.obs;

  void sendPasswordResetEmail() async {
    isLoading.value = true;
    String res = await AuthServices().sendPasswordResetEmail(
      email: emailController.text,
    );

    if (res == "success") {
      showSnackBar(Get.context!, "Password reset email sent!");
      Get.back();
    } else {
      isLoading.value = false;
      showSnackBar(Get.context!, res);
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }
}
