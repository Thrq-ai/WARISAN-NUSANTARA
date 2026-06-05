import 'package:get/get.dart';

import '../controllers/continue_controller.dart';

class ContinueBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContinueController>(
      () => ContinueController(),
    );
  }
}
