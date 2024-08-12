import 'package:fix_mates_servicer/view/opening_screens/verification_screen.dart';
import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

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
      // Fetch the user document from Firestore
      var userDoc = await FirebaseFirestore.instance
          .collection('workers')
          .where('userEmail', isEqualTo: emailController.text)
          .get();

      if (userDoc.docs.isNotEmpty) {
        // Check the verification status
        var userStatus = userDoc.docs.first['status'];

        // Register the SignUpController if needed
        if (!Get.isRegistered<SignUpController>()) {
          Get.put(SignUpController());
        }

        if (userStatus == 'pending') {
          // If the user is not verified, navigate to the VerificationScreen
          Get.off(() => VerificationScreen());
        } else {
          // If the user is verified, navigate to the HomeScreen
          Get.off(() => HomeScreen());
        }
      } else {
        // Handle the case where the user document is not found
        showSnackBar(Get.context!, 'User not found');
        isLoading.value = false;
      }
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
