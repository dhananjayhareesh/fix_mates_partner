import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:fix_mates_servicer/view_model/verification_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class VerificationScreen extends StatelessWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Initialize VerificationController with the user's email
    Get.put(VerificationController(
        Get.find<SignUpController>().emailController.text));

    return Scaffold(
      appBar: AppBar(
        title: Text("Verification"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.verified_user, size: 100, color: Colors.blue),
            SizedBox(height: 20),
            Text(
              "You are being verified",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text(
              "Please wait for the admin to verify your documents.",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
