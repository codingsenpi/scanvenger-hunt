import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/services/audio_service.dart';
import 'package:scanvenger_hunt_2/app/data/services/auth_service.dart';
import 'package:scanvenger_hunt_2/app/data/services/firestore_service.dart';
import 'package:scanvenger_hunt_2/app/data/services/supabase_service.dart';
import 'package:scanvenger_hunt_2/app/modules/auth/controllers/auth_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/game_gate/controllers/game_gate_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/home/controllers/home_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_waiting/controllers/submission_waiting_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_result/controllers/submission_result_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/leaderboard/controllers/leaderboard_controller.dart';

class InitialBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
    Get.lazyPut<FirestoreService>(() => FirestoreService(), fenix: true);
    Get.lazyPut<SupabaseService>(() => SupabaseService(), fenix: true);
    Get.lazyPut<AuthController>(() => AuthController(), fenix: true);
    Get.lazyPut<GameGateController>(() => GameGateController(), fenix: true);
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);
    Get.lazyPut<SubmissionWaitingController>(
      () => SubmissionWaitingController(),
      fenix: true,
    );
    Get.lazyPut<SubmissionResultController>(
      () => SubmissionResultController(),
      fenix: true,
    );
    Get.lazyPut<LeaderboardController>(() => LeaderboardController(),
        fenix: true);
  }
}
