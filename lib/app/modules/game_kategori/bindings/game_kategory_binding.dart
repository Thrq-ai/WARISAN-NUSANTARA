import 'package:get/get.dart';

import '../controllers/game_kategory_controller.dart';

class GameKategoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameKategoryController>(
      () => GameKategoryController(),
    );
  }
}
