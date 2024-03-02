import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../auth/authentication.dart';
import '../screen/remindersPage.dart';

class AuthController extends GetxController {
  AuthenticationService authService = AuthenticationService();

  Future<void> signInUser(String email, String password) async {
    try {
      UserCredential userCredential = await authService.signIn(email, password);
      if (userCredential.user != null) {
        Get.offAll(() => RemindersPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Your email or password is incorrect',
        'Try again please',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  Future<void> signUpUser(String email, String password) async {
    try {
      UserCredential userCredential = await authService.signUp(email, password);
      if (userCredential.user != null) {
        Get.offAll(() => RemindersPage());
      }
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
        'Sign Up Error',
        e.message ?? 'An error occurred during sign up.',
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
