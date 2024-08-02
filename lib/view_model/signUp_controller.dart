import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fix_mates_servicer/view/opening_screens/upload_document_screen.dart';
import 'package:fix_mates_servicer/view/opening_screens/work_detail_screen.dart';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:fix_mates_servicer/repositories/authentication.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
      // Navigate to WorkCategory and register SignUpController
      Get.to(() => WorkCategory(), binding: BindingsBuilder(() {
        Get.put(SignUpController()); // Register SignUpController
      }));
    } else {
      isLoading.value = false;
      showSnackBar(Get.context!, res);
    }
  }

  void addWorkCategory(String category) {
    Get.off(() => UploadDocumentsScreen(category: category));
  }

  Future<void> addDocuments(String category, File photo, File idCard) async {
    try {
      String photoUrl =
          await _uploadFile(photo, '${category.toLowerCase()}Workers/photo');
      String idCardUrl =
          await _uploadFile(idCard, '${category.toLowerCase()}Workers/idCard');

      await FirebaseFirestore.instance
          .collection('${category.toLowerCase()}Workers')
          .add({
        'userName': nameController.text,
        'userEmail': emailController.text,
        'photoUrl': photoUrl,
        'idCardUrl': idCardUrl,
      });
      Get.offAll(() => HomeScreen());
    } catch (e) {
      showSnackBar(Get.context!, 'Failed to upload documents: $e');
    }
  }

  Future<String> _uploadFile(File file, String path) async {
    try {
      UploadTask uploadTask =
          FirebaseStorage.instance.ref().child(path).putFile(file);
      TaskSnapshot taskSnapshot = await uploadTask;
      return await taskSnapshot.ref.getDownloadURL();
    } catch (e) {
      throw 'Error uploading file: $e';
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
