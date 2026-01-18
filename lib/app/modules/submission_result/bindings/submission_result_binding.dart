import 'package:get/get.dart';
import '../controllers/submission_result_controller.dart';
class SubmissionResultBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubmissionResultController>(
      () => SubmissionResultController(),
    );
  }
}
