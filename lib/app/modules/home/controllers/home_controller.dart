import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:scanvenger_hunt_2/app/data/hardcoded_data.dart';
import 'package:scanvenger_hunt_2/app/data/models/game_status.dart';
import 'package:scanvenger_hunt_2/app/data/models/mystery.dart';
import 'package:scanvenger_hunt_2/app/data/models/submission.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';
import 'package:scanvenger_hunt_2/app/data/services/firestore_service.dart';
import 'package:scanvenger_hunt_2/app/data/services/supabase_service.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_waiting/views/submission_waiting_view.dart';
import 'package:scanvenger_hunt_2/app/routes/app_pages.dart';

class HomeController extends GetxController {
  // Dependencies
  final FirestoreService _firestoreService = Get.find<FirestoreService>();
  final SupabaseService _supabaseService = Get.find<SupabaseService>();
  final user = FirebaseAuth.instance.currentUser;
  final ImagePicker _picker = ImagePicker();

  // State Variables
  final Rx<Team?> currentTeam = Rx<Team?>(null);
  final Rx<Mystery?> currentMystery = Rx<Mystery?>(null);
  final Rx<Submission?> lastSubmission = Rx<Submission?>(null);
  final RxBool isLeaderboardEnabled = false.obs;
  StreamSubscription? _submissionSubscription;
  StreamSubscription? _gameStatusSubscription;

  // Computed Properties for the UI
  bool get isButtonDisabled => lastSubmission.value?.status == 'pending';
  String get buttonText => 'Solve with Photo';

  @override
  void onInit() {
    super.onInit();
    if (user != null) {
      currentTeam.bindStream(_firestoreService.getTeamStream(user!.uid));
      ever(currentTeam, _onTeamDataChanged);
      _gameStatusSubscription =
          _firestoreService.getGameStatusStream().listen((status) {
        isLeaderboardEnabled.value = status?.isLeaderboardEnabled ?? false;
      });
    }
  }

  void _onTeamDataChanged(Team? team) {
    if (team == null) return;
    _updateCurrentMystery(team);
    _listenToLastSubmission(team);
  }

  void _updateCurrentMystery(Team team) {
    if (team.currentMysteryIndex < allMysteries.length) {
      final actualMysteryIndex = team.mysteryOrder[team.currentMysteryIndex];
      currentMystery.value =
          allMysteries.firstWhere((m) => m.index == actualMysteryIndex);
    } else {
      currentMystery.value = null; // Game over
    }
  }

  void _listenToLastSubmission(Team team) {
    _submissionSubscription?.cancel();
    final mystery = currentMystery.value;
    if (mystery == null) {
      lastSubmission.value = null;
      return;
    }
    _submissionSubscription = _firestoreService
        .getLastSubmissionStream(
      teamId: team.id,
      mysteryIndex: mystery.index,
      part: team.currentPart,
    )
        .listen((submission) {
      lastSubmission.value = submission;
    });
  }

  Future<XFile> _compressImage(XFile file) async {
    try {
      final tempDir = await getTemporaryDirectory();
      final targetPath =
          '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final result = await FlutterImageCompress.compressAndGetFile(
        file.path,
        targetPath,
        quality: 60,
      );
      if (result != null) return result;
    } catch (e) {
      print("Compression failed: $e");
    }
    return file;
  }

  Future<void> submitAnswer() async {
    try {
      final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
      if (photo == null) return;

      final XFile photoToUpload = await _compressImage(photo);

      Get.dialog(
        Center(
          child: Lottie.asset(
            'assets/lottie/uploading_animation.json',
            width: 150,
            height: 150,
          ),
        ),
        barrierDismissible: false,
      );

      final team = currentTeam.value!;
      final mystery = currentMystery.value!;

      final imageUrl = await _supabaseService.uploadImage(
        imageFile: photoToUpload,
        teamId: team.id,
        mysteryIndex: mystery.index,
        part: team.currentPart,
      );

      if (imageUrl == null) throw Exception('Failed to upload image.');

      final newSubmission = Submission(
        teamId: team.id,
        teamName: team.teamName,
        mysteryIndex: mystery.index,
        part: team.currentPart,
        imageUrl: imageUrl,
        timestamp: DateTime.now(),
      );

      final submissionId = await _firestoreService.addSubmission(newSubmission);

      if (Get.isDialogOpen ?? false) Get.back();

      await Get.toNamed(
        Routes.SUBMISSION_WAITING,
        arguments: {
          'submissionId': submissionId,
          'riddleText': mystery.riddle,
          'localImagePath': photoToUpload.path,
        },
      );
      _onTeamDataChanged(currentTeam.value);
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  @override
  void onClose() {
    _submissionSubscription?.cancel();
    _gameStatusSubscription?.cancel();
    super.onClose();
  }
}
