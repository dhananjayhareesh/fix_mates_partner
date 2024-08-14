import 'package:fix_mates_servicer/view/opening_screens/verification_screen.dart';
import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_mates_servicer/resources/widgets/snackBar.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:uuid/uuid.dart';

class UploadDocumentsController extends GetxController {
  final String category;
  final ImagePicker _picker = ImagePicker();

  var photo = Rx<File?>(null);
  var idCard = Rx<File?>(null);
  var description = ''.obs; // Observable for the work experience description

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
    if (photo.value != null && idCard.value != null && description.isNotEmpty) {
      try {
        final uniqueId = Uuid().v4();

        String photoUrl = await _uploadFile(
            photo.value!, 'workers/${category.toLowerCase()}/photo_$uniqueId');
        String idCardUrl = await _uploadFile(idCard.value!,
            'workers/${category.toLowerCase()}/idCard_$uniqueId');

        await FirebaseFirestore.instance.collection('workers').add({
          'userName': Get.find<SignUpController>().nameController.text,
          'userEmail': Get.find<SignUpController>().emailController.text,
          'photoUrl': photoUrl,
          'idCardUrl': idCardUrl,
          'category': category,
          'description': description.value, // Storing the description
          'status': 'pending',
        });

        Get.offAll(() => VerificationScreen());
      } catch (e) {
        showSnackBar(Get.context!, 'Failed to upload documents: $e');
      }
    } else {
      showSnackBar(Get.context!, 'Please complete all fields.');
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
