import 'package:get/get.dart';
import 'package:hello/screen/account/add_account.dart';
import 'package:hello/screen/auth/login/login_screen.dart';
import 'package:hello/screen/auth/register/register_screen.dart';
import 'package:hello/screen/chatroom/chats_screen.dart';
import 'package:hello/screen/home/home_screen.dart';

class Routes {
  static Routes route = Routes();

  // static String splash = "/";
  static const login = "/";
  static const register = "/register";
  static const home = "/home";
  static const addAccount = "/add_account";
  static const chatScreen = "/chat_screen";

  static List<GetPage> pages = [
    // GetPage(
    //     name: splash,
    //     page: () => const SplashScreen(),
    //     transition: Transition.cupertino),
    GetPage(
        name: login,
        page: () => const LoginScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: register,
        page: () => RegisterScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: home,
        page: () => const HomeScreen(),
        transition: Transition.cupertino),
    GetPage(
        name: addAccount,
        page: () => const AddAccount(),
        transition: Transition.cupertino),
    GetPage(
        name: chatScreen,
        page: () => const ChatsScreen(),
        transition: Transition.cupertino),
  ];
}
