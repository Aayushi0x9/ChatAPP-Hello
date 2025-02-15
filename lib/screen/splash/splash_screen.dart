import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:hello/services/auth_services.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Timer(const Duration(seconds: 7), () {
      log('${AuthService.authService.currentUser}');
      (AuthService.authService.currentUser != null)
          ? Get.offNamed(Routes.home)
          : Get.offNamed(Routes.login);
    });
    return Scaffold(
      backgroundColor: const Color(0xffD6E2EA),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Image.asset(
              'assets/gif/splash.gif',
              height: 150.h,
            ),
          ),
          Text('Hello!!', style: TextStyle(fontSize: 22.sp)),
        ],
      ),
    );
  }
}
