import 'package:fix_mates_servicer/resources/widgets/button.dart';
import 'package:fix_mates_servicer/resources/widgets/text_field.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/view_model/forgot_password_controller.dart';

class ForgotPasswordScreen extends StatelessWidget {
  ForgotPasswordScreen({super.key});

  final ForgotPasswordController forgotPasswordController =
      Get.put(ForgotPasswordController());

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  height: height / 2.7,
                  child: Image.asset("assets/servicer_login.jpg"),
                ),
                Text(
                  'Forgot Password',
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFieldInput(
                  textEditingController:
                      forgotPasswordController.emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                Obx(() => MyButton(
                      onTab: forgotPasswordController.sendPasswordResetEmail,
                      text: forgotPasswordController.isLoading.value
                          ? "Loading..."
                          : "Send Reset Email",
                    )),
                SizedBox(
                  height: height / 15,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
