import 'package:get/get.dart';
import 'package:hello/services/auth_services.dart';

class HomeController extends GetxController {
  void signOut() {
    AuthService.authService.logOut();
  }
}
