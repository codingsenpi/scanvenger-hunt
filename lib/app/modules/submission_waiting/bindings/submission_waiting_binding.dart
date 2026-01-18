import 'package:get/get.dart';
import '../controllers/submission_waiting_controller.dart';
class SubmissionWaitingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmissionWaitingController>(
      () => SubmissionWaitingController(),
    );
  }
}
