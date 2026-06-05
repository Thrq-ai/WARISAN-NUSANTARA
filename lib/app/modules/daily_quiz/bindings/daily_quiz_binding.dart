import 'package:get/get.dart';

import '../controllers/daily_quiz_controller.dart';

class DailyQuizBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DailyQuizController>(
      () => DailyQuizController(),
    );
  }
}
