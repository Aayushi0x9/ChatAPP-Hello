import 'package:flutter/material.dart';
import 'package:get/get.dart';

bool validateEmail(String email) {
  final validEmail = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.(com|org|net)$',
  );
  return validEmail.hasMatch(email);
}

bool validateForm(
    {required GlobalKey<FormState> formKey,
    required riveControllerW,
    required authController}) {
  if (!formKey.currentState!.validate()) {
    riveControllerW.trigFail?.change(true);
    return false;
  }
  final password = authController.passwordController.text;
  final cPassword = authController.cPasswordController.text;

  if (password != cPassword) {
    Get.snackbar("Error", "Passwords do not match.",
        backgroundColor: Colors.red, colorText: Colors.white);
    riveControllerW.trigFail?.change(true);
    return false;
  }
  return true;
}
