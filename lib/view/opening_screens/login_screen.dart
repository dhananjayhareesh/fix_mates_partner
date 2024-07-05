import 'package:fix_mates_servicer/resources/widgets/button.dart';
import 'package:fix_mates_servicer/resources/widgets/text_field.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';
import 'package:fix_mates_servicer/view/opening_screens/signup_screen.dart';
import 'package:fix_mates_servicer/view/opening_screens/forgot_password_screen.dart';
import 'package:fix_mates_servicer/view_model/login_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController loginController = Get.put(LoginController());

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
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Fix',
                        style: GoogleFonts.lobster(
                          color: Colors.blue,
                          fontSize: 80,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: ' Mates',
                        style: GoogleFonts.lobster(
                          color: Colors.grey,
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  'Partner',
                  style: GoogleFonts.caveat(
                    color: Colors.grey,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                TextFieldInput(
                  textEditingController: loginController.emailController,
                  hintText: "Enter your email",
                  icon: Icons.email,
                ),
                TextFieldInput(
                  isPass: true,
                  textEditingController: loginController.passwordController,
                  hintText: "Enter your password",
                  icon: Icons.lock,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35),
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: GestureDetector(
                      onTap: () {
                        Get.to(() => ForgotPasswordScreen());
                      },
                      child: Text(
                        "Forgot Password?",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(() => MyButton(
                      onTab: loginController.loginUsers,
                      text: loginController.isLoading.value
                          ? "Loading..."
                          : "Log In",
                    )),
                SizedBox(
                  height: height / 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Register as Fix Mates Partner? ",
                      style: TextStyle(fontSize: 16),
                    ),
                    GestureDetector(
                      onTap: () {
                        Get.to(() => SignUpScreen());
                      },
                      child: Text(
                        "SignUp",
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
