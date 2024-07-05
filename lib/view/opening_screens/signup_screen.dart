import 'package:fix_mates_servicer/resources/widgets/button.dart';
import 'package:fix_mates_servicer/resources/widgets/text_field.dart';
import 'package:fix_mates_servicer/view/opening_screens/login_screen.dart';
import 'package:fix_mates_servicer/view_model/signUp_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class SignUpScreen extends StatelessWidget {
  SignUpScreen({super.key});

  final SignUpController signUpController = Get.put(SignUpController());

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
                  'Register as Partner',
                  style: GoogleFonts.rowdies(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFieldInput(
                  textEditingController: signUpController.nameController,
                  hintText: "Enter your name",
                  icon: Icons.person,
                ),
                TextFieldInput(
                  textEditingController: signUpController.emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                TextFieldInput(
                  textEditingController: signUpController.passwordController,
                  hintText: "Enter your password",
                  isPass: true,
                  icon: Icons.lock,
                ),
                Obx(() => MyButton(
                      onTab: signUpController.signUpUser,
                      text: signUpController.isLoading.value
                          ? "Loading..."
                          : "Sign Up",
                    )),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have an account ? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => LoginScreen());
                      },
                      child: Text(
                        "Log In",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
