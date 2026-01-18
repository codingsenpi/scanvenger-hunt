import 'package:get/get.dart';
import '../controllers/game_gate_controller.dart';
class GameGateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<GameGateController>(
      () => GameGateController(),
    );
  }
}
