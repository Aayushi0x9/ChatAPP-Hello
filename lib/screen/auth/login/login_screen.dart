import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hello/controller/login_controller.dart';
import 'package:hello/controller/rive_controller.dart';
import 'package:hello/extension.dart';
import 'package:hello/routes/app_routes.dart';
import 'package:rive/rive.dart' hide Image;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  RiveController riveControllerW = Get.put(RiveController());
  LoginController loginController = Get.put(LoginController());
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    riveControllerW.emailFocusNode.addListener(riveControllerW.emailFocus);
    riveControllerW.passwordFocusNode
        .addListener(riveControllerW.passwordFocus);
    super.initState();
  }

  @override
  void dispose() {
    riveControllerW.emailFocusNode.removeListener(riveControllerW.emailFocus);
    riveControllerW.passwordFocusNode
        .removeListener(riveControllerW.passwordFocus);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        backgroundColor: const Color(0xffD6E2EA),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: GetBuilder<RiveController>(builder: (ctx) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 70.h),
                  Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontFamily: GoogleFonts.poppins().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.3,
                    width: size.width * 0.8,
                    child: RiveAnimation.asset(
                      "assets/riv/teddy.riv",
                      fit: BoxFit.fitHeight,
                      stateMachines: const ["Login MAchine"],
                      onInit: (artboard) {
                        riveControllerW.controller =
                            StateMachineController.fromArtboard(
                                artboard,
                                //rive editor can see
                                "Login Machine");
                        if (riveControllerW.controller == null) return;

                        artboard.addController(riveControllerW.controller!);
                        riveControllerW.isChecking =
                            riveControllerW.controller?.findInput("isChecking");
                        riveControllerW.numLook =
                            riveControllerW.controller?.findInput("numLook");
                        riveControllerW.isHandsUp =
                            riveControllerW.controller?.findInput("isHandsUp");
                        riveControllerW.trigSuccess = riveControllerW.controller
                            ?.findInput("trigSuccess");
                        riveControllerW.trigFail =
                            riveControllerW.controller?.findInput("trigFail");
                      },
                    ),
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    margin: EdgeInsets.symmetric(horizontal: 10.w),
                    padding: const EdgeInsets.all(16),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
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
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email';
                                } else if (!validateEmail(value)) {
                                  return 'Please enter a valid email';
                                }
                                return null;
                              },
                              focusNode: riveControllerW.emailFocusNode,
                              controller: emailController,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.attach_email_outlined),
                                hintText: "Email",
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              onChanged: (value) {
                                riveControllerW.numLook
                                    ?.change(value.length.toDouble());
                              },
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 10, bottom: 10),
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
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              focusNode: riveControllerW.passwordFocusNode,
                              controller: passwordController,
                              obscureText: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                prefixIcon: Icon(Icons.password_outlined),
                                hintText: "Password",
                              ),
                              style: Theme.of(context).textTheme.bodyMedium,
                              onChanged: (value) {
                                riveControllerW.numLook
                                    ?.change(value.length.toDouble());
                              },
                            ),
                          ),
                          SizedBox(
                            width: size.width,
                            height: size.height * 0.06,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  )),
                              onPressed: () async {
                                riveControllerW.emailFocusNode.unfocus();
                                riveControllerW.passwordFocusNode.unfocus();
                                final email = emailController.text;
                                final password = passwordController.text;
                                if (formKey.currentState!.validate()) {
                                  riveControllerW.trigSuccess?.change(true);
                                  loginController.loginNewUser(
                                      email: email, password: password);
                                } else {
                                  riveControllerW.trigFail?.change(true);
                                }
                              },
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  const Row(
                    children: [
                      Expanded(
                        child: Divider(),
                      ),
                      Text('  OR  '),
                      Expanded(
                        child: Divider(),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                          onTap: () {
                            loginController.signInWithGoogle();
                          },
                          child: Image.asset(
                            'asset/icons/google.png',
                            height: 50.h,
                            width: 50.w,
                          )),
                      Image.asset(
                        'asset/icons/github.png',
                        height: 50.h,
                        width: 50.w,
                      ),
                      Image.asset(
                        'asset/icons/apple.png',
                        height: 50.h,
                        width: 50.w,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 110.h,
                  ),
                  Text.rich(
                    TextSpan(
                      text: "Don't have an account ? ",
                      children: [
                        TextSpan(
                          text: "Register",
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Get.toNamed(Routes.register);
                            },
                          style: TextStyle(
                            color: const Color(0xff4C7690),
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline,
                            decorationColor: const Color(0xff4C7690),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
