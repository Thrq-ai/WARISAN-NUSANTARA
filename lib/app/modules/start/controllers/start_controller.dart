import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StartController extends GetxController {
  //TODO: Implement StartController

  @override
  void onInit() {
    super.onInit();
    _navigateToNext();
  }

  void _navigateToNext() {
    Future.delayed(const Duration(seconds: 3), () {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        Get.offAllNamed('/home');
      } else {
        Get.offAllNamed('/login');
      }
    });
  }

  @override
  void onClose() {
    super.onClose();
  }
}
