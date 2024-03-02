import '../controller/signUpController.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/authController.dart';
import '../src/components/customText.dart';

class SignUp extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthController authController = Get.put(AuthController());
  SignUp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignUpController());
    final SignUpController controller = Get.find<SignUpController>();

    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(height: 20.0),
                const CustomText(
                  text: 'Sign up with email',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
                const SizedBox(height: 12.0),
                const CustomText(
                    text: 'Enter your email and password',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey),
                const SizedBox(height: 32.0),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: 'E-mail',
                    filled: true,
                    fillColor: Colors.white,
                    labelStyle: const TextStyle(color: Colors.grey),
                    floatingLabelBehavior: FloatingLabelBehavior.never,
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                    ),
                    suffixIcon: Obx(() => controller.isEmailValid.value
                        ? const Icon(
                            Icons.check_circle,
                            color: Colors.black,
                            size: 25,
                          )
                        : Container(width: 0)),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.black),
                  onChanged: controller.checkEmail,
                ),
                const SizedBox(height: 16.0),
                Obx(
                  () => TextField(
                    controller: passwordController,
                    onChanged: (value) {
                      controller.setPasswordEntered(value);
                    },
                    decoration: InputDecoration(
                      labelText: 'Password',
                      filled: true,
                      fillColor: Colors.white,
                      labelStyle: const TextStyle(color: Colors.grey),
                      floatingLabelBehavior: FloatingLabelBehavior.never,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isPasswordVisible.value
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey,
                        ),
                        onPressed: controller.togglePasswordVisibility,
                      ),
                    ),
                    obscureText: !controller.isPasswordVisible.value,
                    obscuringCharacter: '•',
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
                const SizedBox(height: 48.0),
                Obx(() => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: controller.isEmailValid.value &&
                                  controller.isPasswordEntered.value
                              ? Colors.indigo[900]
                              : Colors.grey[700],
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                        ),
                        onPressed: () async {
                          if (controller.isEmailValid.value &&
                              controller.isPasswordEntered.value) {
                            await authController.signUpUser(
                                emailController.text, passwordController.text);
                          } else {}
                        },
                        child: const CustomText(
                          text: 'Create Account',
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    )),
                const SizedBox(height: 16.0),
                RichText(
                  textAlign: TextAlign.center,
                  text: const TextSpan(
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey,
                    ),
                    children: <TextSpan>[
                      TextSpan(text: 'By continuing, you agree to our '),
                      TextSpan(
                        text: 'Privacy Policy',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                      TextSpan(text: ' and '),
                      TextSpan(
                        text: 'Terms of Use.',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
