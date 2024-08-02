import 'package:fix_mates_servicer/view_model/upload_document_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';

class UploadDocumentsScreen extends StatelessWidget {
  final String category;

  const UploadDocumentsScreen({required this.category, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final UploadDocumentsController controller =
        Get.put(UploadDocumentsController(category));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Upload Documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUploadSection(
              context: context,
              icon: Icons.photo_camera,
              title: 'Upload Photo',
              onPressed: () => controller.pickImage(true),
              imageFile: controller.photo,
            ),
            const SizedBox(height: 20),
            _buildUploadSection(
              context: context,
              icon: Icons.credit_card,
              title: 'Upload ID Card',
              onPressed: () => controller.pickImage(false),
              imageFile: controller.idCard,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: controller.submitDocuments,
              child: const Text('Submit'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadSection({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onPressed,
    required Rx<File?> imageFile,
  }) {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: Colors.blue),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineMedium),
                Obx(() {
                  if (imageFile.value != null) {
                    print("Displaying image: ${imageFile.value!.path}");
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Image.file(imageFile.value!, height: 100),
                    );
                  } else {
                    return Container();
                  }
                }),
                ElevatedButton(
                  onPressed: onPressed,
                  child: const Text('Choose Image'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
