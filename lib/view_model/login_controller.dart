import 'package:fix_mates_servicer/utils/current_worker_helper.dart';
import 'package:fix_mates_servicer/view/main_screen.dart';
import 'package:fix_mates_servicer/view/opening_screens/rejected_screen.dart';
import 'package:fix_mates_servicer/view/opening_screens/verification_screen.dart';
import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth

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
      // Get the current user from FirebaseAuth
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        // Use the user's email to fetch the worker document from Firestore
        var userDoc = await FirebaseFirestore.instance
            .collection('workers')
            .where('userEmail', isEqualTo: currentUser.email)
            .get();

        if (userDoc.docs.isNotEmpty) {
          // Get the worker document ID
          var workerDocId = userDoc.docs.first.id;

          // Debug print the workerDocId
          print('Worker Document ID: $workerDocId');

          // Store the workerDocId using SharedPrefsHelper
          await SharedPrefsHelper.storeUserDocumentId(workerDocId);

          // Check the verification status
          var userStatus = userDoc.docs.first['status'];

          // Register the SignUpController if needed
          if (!Get.isRegistered<SignUpController>()) {
            Get.put(SignUpController());
          }

          if (userStatus == 'pending') {
            // If the user is not verified, navigate to the VerificationScreen
            Get.off(() => VerificationScreen());
          } else if (userStatus == 'rejected') {
            // If the user is rejected, navigate to the RejectionScreen
            Get.off(() => RejectionScreen());
          } else {
            // If the user is verified, navigate to the HomeScreen
            Get.off(() => MainScreen());
          }
        } else {
          // Handle the case where the user document is not found
          showSnackBar(Get.context!, 'Worker not found');
          isLoading.value = false;
        }
      } else {
        // Handle the case where the current user is null
        showSnackBar(Get.context!, 'User authentication failed');
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
