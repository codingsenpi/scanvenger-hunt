import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_waiting/controllers/submission_waiting_controller.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class SubmissionWaitingView extends GetView<SubmissionWaitingController> {
  const SubmissionWaitingView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Get.snackbar('Please Wait', 'Verification is in progress.',
            snackPosition: SnackPosition.BOTTOM);
        return false;
      },
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(flex: 2),
              _buildStatusWidget(),
              const SizedBox(height: 40),
              _buildInfoRow(),
              const Spacer(flex: 3),
              const Text(
                'You will be automatically redirected once verification is complete.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusWidget() {
    return Column(
      children: [
        Lottie.asset(
          'assets/lottie/verifying_animation.json',
          width: 200,
          height: 200,
          repeat: true,
        ),
        const SizedBox(height: 20),
        Obx(() {
          final seconds = controller.cooldown.value.inSeconds;
          if (seconds > 0) {
            return Text(
              '$seconds',
              textAlign: TextAlign.center,
              style: Get.textTheme.displayMedium?.copyWith(
                  fontWeight: FontWeight.bold, color: AppTheme.textDark),
            );
          } else {
            return Text(
              'Verification Pending...\nThis should be quick!',
              textAlign: TextAlign.center,
              style: Get.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold, color: AppTheme.textDark),
            );
          }
        }),
      ],
    );
  }

  Widget _buildInfoRow() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Your Submission For:',
                      style: Get.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  SizedBox(
                    height: 120,
                    child: SingleChildScrollView(
                      child: Text(controller.riddleText,
                          style: Get.textTheme.bodyLarge),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  Text('Your Photo',
                      style: Get.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.file(
                      File(controller.localImagePath),
                      fit: BoxFit.cover,
                      height: 120,
                      width: double.infinity,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
