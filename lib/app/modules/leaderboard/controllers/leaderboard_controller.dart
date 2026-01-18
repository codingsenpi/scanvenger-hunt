import 'dart:async';

import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';
import 'package:scanvenger_hunt_2/app/data/services/firestore_service.dart';

class LeaderboardController extends GetxController {
  final FirestoreService _firestoreService = Get.find();

  final Rx<List<Team>> teams = Rx<List<Team>>([]);
  StreamSubscription? _gameStatusSubscription;

  @override
  void onInit() {
    super.onInit();
    teams.bindStream(_firestoreService.getAllTeamsStream());

    _gameStatusSubscription =
        _firestoreService.getGameStatusStream().listen((status) {
      final isEnabled = status?.isLeaderboardEnabled ?? false;

      if (!isEnabled && !isClosed) {
        Get.back();
      }
    });
  }

  @override
  void onClose() {
    _gameStatusSubscription?.cancel();
    super.onClose();
  }
}
