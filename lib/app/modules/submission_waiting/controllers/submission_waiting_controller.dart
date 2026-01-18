import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/models/submission.dart';
import 'package:scanvenger_hunt_2/app/data/services/firestore_service.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_result/views/submission_result_view.dart';
import 'package:scanvenger_hunt_2/app/routes/app_pages.dart';

class SubmissionWaitingController extends GetxController {
  final FirestoreService _firestoreService = Get.find();
  final Rx<Duration> cooldown = Rx<Duration>(Duration.zero);
  Timer? _cooldownTimer;
  Timer? _pollingTimer;
  bool _isNavigating = false;
  late final String submissionId;
  late final String riddleText;
  late final String localImagePath;
  @override
  void onInit() {
    super.onInit();
    submissionId = Get.arguments['submissionId'];
    riddleText = Get.arguments['riddleText'];
    localImagePath = Get.arguments['localImagePath'];
    _startCooldown();
    _startPollingForStatus();
  }

  void _startCooldown() {
    final duration =
        kDebugMode ? const Duration(seconds: 5) : const Duration(seconds: 30);
    cooldown.value = duration;
    _cooldownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (cooldown.value.inSeconds > 0) {
        cooldown.value = cooldown.value - const Duration(seconds: 1);
      } else {
        timer.cancel();
      }
    });
  }

  void _startPollingForStatus() {
    _checkStatus();
    _pollingTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      _checkStatus();
    });
  }

  Future<void> _checkStatus() async {
    if (_isNavigating) return;
    final submission =
        await _firestoreService.getSingleSubmission(submissionId);
    if (submission?.status == 'approved') {
      _navigateToResult('approved');
    } else if (submission?.status == 'rejected') {
      if (cooldown.value.inSeconds == 0) {
        _navigateToResult('rejected');
      }
    }
  }

  void _navigateToResult(String result) {
    if (_isNavigating) return;
    _isNavigating = true;
    _cooldownTimer?.cancel();
    _pollingTimer?.cancel();
    Get.offNamed(Routes.SUBMISSION_RESULT, arguments: {'result': result});
  }

  @override
  void onClose() {
    _cooldownTimer?.cancel();
    _pollingTimer?.cancel();
    super.onClose();
  }
}
