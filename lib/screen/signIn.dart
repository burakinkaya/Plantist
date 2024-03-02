import '../controller/signInController.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/authController.dart';
import '../src/components/customText.dart';

class SignIn extends StatelessWidget {
  SignIn({Key? key}) : super(key: key);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final AuthController authController = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => SignInController());
    final SignInController controller = Get.find<SignInController>();

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
              onPressed: () {
                controller.reset();
                Navigator.pop(context);
              },
            ),
            elevation: 0,
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  const CustomText(
                    text: 'Sign in with email',
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
                  const SizedBox(height: 8.0),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: const CustomText(
                          text: 'Forgot password?',
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue),
                    ),
                  ),
                  const SizedBox(height: 12.0),
                  Obx(() => SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: controller.isEmailValid.value &&
                                    controller.isPasswordEntered.value
                                ? Colors.indigo[900]
                                : Colors.grey[700],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                          ),
                          onPressed: () async {
                            if (controller.isEmailValid.value &&
                                controller.isPasswordEntered.value) {
                              await authController.signInUser(
                                  emailController.text,
                                  passwordController.text);
                            } else {}
                          },
                          child: const CustomText(
                            text: 'Sign In',
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
          ),
        ));
  }
}
