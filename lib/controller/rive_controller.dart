import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:rive/rive.dart';

class RiveController extends GetxController {
  FocusNode emailFocusNode = FocusNode();

  FocusNode passwordFocusNode = FocusNode();
  FocusNode cPasswordFocusNode = FocusNode();
  //rive controller
  StateMachineController? controller;

  SMIInput<bool>? isChecking;
  SMIInput<double>? numLook;
  SMIInput<bool>? isHandsUp;
  SMIInput<bool>? trigFail;
  SMIInput<bool>? trigSuccess;

  void emailFocus() {
    isChecking?.change(emailFocusNode.hasFocus);
    update();
  }

  void passwordFocus() {
    isHandsUp?.change(passwordFocusNode.hasFocus);
    update();
  }

  void cPasswordFocus() {
    isHandsUp?.change(cPasswordFocusNode.hasFocus);
    update();
  }
}
