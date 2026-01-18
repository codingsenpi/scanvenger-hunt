import 'dart:async';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/models/game_status.dart';
import 'package:scanvenger_hunt_2/app/data/services/firestore_service.dart';
import 'package:vibration/vibration.dart';

enum GamePhase { loading, waitingToStart, inProgress, finished }

class GameGateController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final Rx<GameStatus?> gameStatus = Rx<GameStatus?>(null);
  final Rx<GamePhase> gamePhase = Rx<GamePhase>(GamePhase.loading);
  final Rx<Duration> timeUntilStart = Rx<Duration>(Duration.zero);
  Timer? _timer;
  @override
  void onInit() {
    super.onInit();
    gameStatus.bindStream(_firestoreService.getGameStatusStream());
    _timer =
        Timer.periodic(const Duration(seconds: 1), (_) => _updateGamePhase());
  }

  void _updateGamePhase() async {
    final status = gameStatus.value;
    if (status == null || status.startTime == null || status.endTime == null) {
      gamePhase.value = GamePhase.waitingToStart;
      return;
    }
    final now = DateTime.now();
    if (now.isBefore(status.startTime!)) {
      gamePhase.value = GamePhase.waitingToStart;
      timeUntilStart.value = status.startTime!.difference(now);
      if (timeUntilStart.value.inSeconds <= 60) {
        if (await Vibration.hasVibrator() ?? false) {
          Vibration.vibrate(duration: 50, amplitude: 128);
        }
      }
    } else if (now.isAfter(status.startTime!) &&
        now.isBefore(status.endTime!)) {
      gamePhase.value = GamePhase.inProgress;
    } else {
      gamePhase.value = GamePhase.finished;
    }
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
