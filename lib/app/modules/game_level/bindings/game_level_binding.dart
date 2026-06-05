import 'package:get/get.dart';

import '../controllers/game_level_controller.dart';

class GameLevelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameLevelController>(
      () => GameLevelController(),  
      fenix: false,
    );
  }
}
