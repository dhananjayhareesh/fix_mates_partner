import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:permission_handler/permission_handler.dart';

class UploadDocumentsController extends GetxController {
  final String category;
  final ImagePicker _picker = ImagePicker();

  var photo = Rx<File?>(null);
  var idCard = Rx<File?>(null);

  UploadDocumentsController(this.category);

  Future<void> pickImage(bool isPhoto) async {
    var status = await Permission.storage.status;
    if (!status.isGranted) {
      await Permission.storage.request();
    }

    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        if (isPhoto) {
          photo.value = File(pickedFile.path);
        } else {
          idCard.value = File(pickedFile.path);
        }
        print("Image picked: ${pickedFile.path}");
      } else {
        print("No image selected.");
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  Future<void> submitDocuments() async {
    if (photo.value != null && idCard.value != null) {
      try {
        String photoUrl = await _uploadFile(
            photo.value!, '${category.toLowerCase()}Workers/photo');
        String idCardUrl = await _uploadFile(
            idCard.value!, '${category.toLowerCase()}Workers/idCard');

        await FirebaseFirestore.instance
            .collection('${category.toLowerCase()}Workers')
            .add({
          'userName': Get.find<SignUpController>().nameController.text,
          'userEmail': Get.find<SignUpController>().emailController.text,
          'photoUrl': photoUrl,
          'idCardUrl': idCardUrl,
        });
        Get.offAll(() => HomeScreen());
      } catch (e) {
        showSnackBar(Get.context!, 'Failed to upload documents: $e');
      }
    } else {
      showSnackBar(Get.context!, 'Please upload both photo and ID card.');
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
}
