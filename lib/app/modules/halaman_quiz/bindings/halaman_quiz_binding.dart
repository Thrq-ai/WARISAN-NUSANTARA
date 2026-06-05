import 'package:get/get.dart';

import '../controllers/halaman_quiz_controller.dart';

class HalamanQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HalamanQuizController>(
      () => HalamanQuizController(),
    );
  }
}
