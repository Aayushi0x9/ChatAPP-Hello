import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hello/routes/app_routes.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
    return ScreenUtilInit(
        designSize: Size(width, height),
        builder: (context, _) {
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            getPages: Routes.pages,
          );
        });
  }
}
