import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hello/controller/home_controller.dart';
import 'package:hello/controller/register_controller.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:hello/services/api_service.dart';

class AddAccount extends StatefulWidget {
  const AddAccount({super.key});

  @override
  State<AddAccount> createState() => _AddAccountState();
}

class _AddAccountState extends State<AddAccount> {
  HomeController homeController = Get.put(HomeController());
  RegisterController registerController = Get.put(RegisterController());
  TextEditingController userNameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Account'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Add Account',
              style: TextStyle(fontSize: 20.sp),
            ),
            Align(
              alignment: Alignment.center,
              child: Text(
                'Add Image',
                style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Align(
              alignment: Alignment.center,
              child: Obx(() {
                return Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    registerController.image == null
                        ? CircleAvatar(
                            radius: 60.h,
                            child: Icon(
                              Icons.person,
                              size: 45.h,
                            ),
                          )
                        : CircleAvatar(
                            foregroundImage:
                                FileImage(registerController.image!),
                            radius: 60.h,
                          ),
                    FloatingActionButton.small(
                      onPressed: () async {
                        await registerController.pickUserImage();
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      hoverColor: Colors.blue,
                      splashColor: Colors.green,
                      child: const Icon(Icons.add_a_photo_outlined),
                    ),
                  ],
                );
              }),
            ),
            SizedBox(
              height: 20.h,
            ),
            Text(
              'Enter UserName',
              style: TextStyle(fontSize: 20.sp),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.only(
                top: 8,
                bottom: 8,
                left: 16,
                right: 16,
              ),
              child: TextField(
                controller: userNameController,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  prefixIcon: Icon(Icons.person),
                  hintText: "UserName",
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    )),
                onPressed: () async {
                  if (registerController.image != null) {
                    String img = await ApiService.apiService
                        .uploadImage(image: registerController.image!);
                    log('''-------------------------------
                    email: ${registerController.email}\n
                    psw:''\n
                    name: ${registerController.username}\n
                    image: $img
                    -------------------------------------
                    ''');
                    registerController.registerNewUser(
                      email: registerController.email ?? '',
                      password: '',
                      userName: registerController.username ?? '',
                      image: img,
                    );
                    Get.offNamed(Routes.login);

                    Get.snackbar('Success', 'Registration Successful',
                        backgroundColor: Colors.green, colorText: Colors.white);
                  }
                },
                child: const Text(
                  'AddAccount',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
