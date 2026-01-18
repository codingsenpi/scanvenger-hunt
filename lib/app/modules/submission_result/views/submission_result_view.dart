import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanvenger_hunt_2/app/modules/submission_result/controllers/submission_result_controller.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class SubmissionResultView extends GetView<SubmissionResultController> {
  const SubmissionResultView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final bool isApproved = controller.result == 'approved';
    final String message = isApproved ? 'APPROVED!' : 'REJECTED';
    final Color textColor = AppTheme.textDark;
    final Color backgroundColor = isApproved
        ? AppTheme.pastelGreen.withOpacity(0.8)
        : AppTheme.pastelPink.withOpacity(0.8);
    final String lottieAsset = isApproved
        ? 'assets/lottie/success_animation.json'
        : 'assets/lottie/failure_animation.json';
    return Scaffold(
      backgroundColor: AppTheme.backgroundLight,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                lottieAsset,
                width: 250,
                height: 250,
                repeat: false,
              ),
              const SizedBox(height: 32),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
                decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                    fontWeight: FontWeight.bold,
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Returning to game...',
                style: TextStyle(
                    fontSize: 16, color: AppTheme.textDark.withOpacity(0.7)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
