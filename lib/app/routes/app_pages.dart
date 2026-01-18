import 'package:get/get.dart';

import '../modules/auth/bindings/auth_binding.dart';
import '../modules/auth/views/auth_view.dart';
import '../modules/credits/bindings/credits_binding.dart';
import '../modules/credits/views/credits_view.dart';
import '../modules/game_gate/bindings/game_gate_binding.dart';
import '../modules/game_gate/views/game_gate_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/leaderboard/bindings/leaderboard_binding.dart';
import '../modules/leaderboard/views/leaderboard_view.dart';
import '../modules/rules/bindings/rules_binding.dart';
import '../modules/rules/views/rules_view.dart';
import '../modules/submission_result/bindings/submission_result_binding.dart';
import '../modules/submission_result/views/submission_result_view.dart';
import '../modules/submission_waiting/bindings/submission_waiting_binding.dart';
import '../modules/submission_waiting/views/submission_waiting_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();
  static const INITIAL = Routes.AUTH;
  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.SUBMISSION_WAITING,
      page: () => const SubmissionWaitingView(),
      binding: SubmissionWaitingBinding(),
      transition: Transition.zoom,
    ),
    GetPage(
      name: _Paths.SUBMISSION_RESULT,
      page: () => const SubmissionResultView(),
      binding: SubmissionResultBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.LEADERBOARD,
      page: () => const LeaderboardView(),
      binding: LeaderboardBinding(),
      transition: Transition.downToUp,
    ),
    GetPage(
      name: _Paths.GAME_GATE,
      page: () => const GameGateView(),
      binding: GameGateBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: _Paths.RULES,
      page: () => const RulesView(),
      binding: RulesBinding(),
      transition: Transition.rightToLeft,
    ),
    GetPage(
      name: _Paths.CREDITS,
      page: () => const CreditsView(),
      binding: CreditsBinding(),
    ),
  ];
}
