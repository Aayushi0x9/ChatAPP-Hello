import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hello/model/user_model.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:hello/services/auth_services.dart';
import 'package:hello/services/firestore_service.dart';
import 'package:toastification/toastification.dart';

class LoginController extends GetxController {
  RxBool isPassword = true.obs;

  void changeVisibilityPassword() {
    isPassword.value = !isPassword.value;
  }

  Future<void> loginNewUser({
    required String email,
    required String password,
  }) async {
    var msg = await AuthService.authService.loginUser(
      email: email,
      password: password,
    );

    if (msg == "Success") {
      Get.offNamed(Routes.home);

      toastification.show(
        title: const Text("Success"),
        description: const Text(
          "login success.. 😪",
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
      );
    } else {
      toastification.show(
        title: const Text("LOGIN FAILED"),
        description: Text(
          msg,
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
    }
  }

  Future<void> signInWithGoogle() async {
    String msg = await AuthService.authService.loginWithGoogle();

    if (msg == "Success") {
      Get.offNamed(Routes.home);

      var user = AuthService.authService.currentUser;

      if (user != null) {
        await FirestoreService.firestoreService.addUser(
          user: UserModel(
            uid: user.uid,
            name: user.displayName ?? "",
            email: user.email ?? "",
            password: "",
            image: user.photoURL ?? "",
            token: await FirebaseMessaging.instance.getToken() ?? "",
          ),
        );
      }

      toastification.show(
        title: const Text("Success"),
        description: const Text(
          "login success.. 😪",
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.success,
        style: ToastificationStyle.minimal,
      );
    } else {
      toastification.show(
        title: const Text("LOGIN FAILED"),
        description: Text(
          msg,
        ),
        autoCloseDuration: const Duration(
          seconds: 3,
        ),
        type: ToastificationType.error,
        style: ToastificationStyle.minimal,
      );
    }
  }
}
