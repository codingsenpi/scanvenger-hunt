import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/services/auth_service.dart';

class AuthController extends GetxController {
  final AuthService _authService = Get.find<AuthService>();
  final Rx<User?> user = Rx<User?>(null);
  final formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  @override
  void onInit() {
    super.onInit();
    user.bindStream(_authService.authStateChanges);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  Future<void> login() async {
    if (formKey.currentState!.validate()) {
      isLoading.value = true;
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
      } on FirebaseAuthException catch (e) {
        Get.snackbar(
          'Login Failed',
          e.message ?? 'An unknown error occurred.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } finally {
        isLoading.value = false;
      }
    }
  }

  Future<void> quickLogin() async {
    isLoading.value = true;
    try {
      // await FirebaseAuth.instance.signInWithEmailAndPassword(
      //   email: 'team1@tgcc.event',
      //   password: 'team1@tgcc.event',
      // );
    } on FirebaseAuthException catch (e) {
      Get.snackbar(
          'Quick Login Failed', e.message ?? 'An unknown error occurred.');
    } finally {
      isLoading.value = false;
    }
  }
}
