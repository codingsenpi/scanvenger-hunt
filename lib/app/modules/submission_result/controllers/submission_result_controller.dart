import 'dart:async';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/data/services/audio_service.dart';
import 'package:scanvenger_hunt_2/app/modules/home/views/home_view.dart';

class SubmissionResultController extends GetxController {
  late final String result;
  @override
  void onInit() {
    super.onInit();
    result = Get.arguments['result'];
    if (result == 'approved') {
    } else {}
    Timer(const Duration(seconds: 5), () {
      Get.offAll(() => const HomeView());
    });
  }
}
