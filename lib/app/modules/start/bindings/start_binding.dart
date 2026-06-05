import 'package:get/get.dart';

import '../controllers/start_controller.dart';

class StartBinding extends Bindings {
  @override
  @override
  void dependencies() {
    Get.put(StartController());
  }
}
