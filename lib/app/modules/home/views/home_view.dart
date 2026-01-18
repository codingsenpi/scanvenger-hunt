import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';
import 'package:scanvenger_hunt_2/app/data/models/mystery.dart';
import 'package:scanvenger_hunt_2/app/modules/home/controllers/home_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/leaderboard/views/leaderboard_view.dart';
import 'package:scanvenger_hunt_2/app/modules/rules/views/rules_view.dart';
import 'package:scanvenger_hunt_2/app/routes/app_pages.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Obx(() {
          final isEnabled = controller.isLeaderboardEnabled.value;
          return IconButton(
            icon: Icon(
              FontAwesomeIcons.rankingStar,
              color: isEnabled ? AppTheme.textDark : Colors.grey.shade400,
            ),
            tooltip: 'View Leaderboard',
            onPressed: () {
              if (isEnabled) {
                Get.toNamed(Routes.LEADERBOARD);
              } else {
                Get.snackbar(
                  'Leaderboard Locked',
                  'The leaderboard is currently disabled by the organizers.',
                  snackPosition: SnackPosition.BOTTOM,
                );
              }
            },
          );
        }),
        title: const Text('ScanVenger Hunt'),
        actions: [
          IconButton(
            icon: const Icon(FontAwesomeIcons.scroll),
            tooltip: 'View Rules',
            onPressed: () {
              Get.toNamed(Routes.RULES);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        child: Obx(() {
          final team = controller.currentTeam.value;
          final mystery = controller.currentMystery.value;

          if (team == null) {
            return Center(
              child: Lottie.asset(
                'assets/lottie/uploading_animation.json',
                width: 150,
                height: 150,
              ),
            );
          }
          if (mystery == null) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Lottie.asset(
                  'assets/lottie/success_animation.json',
                  width: 300,
                  height: 300,
                  repeat: false,
                ),
                const SizedBox(height: 24),
                const Text(
                  'Congratulations!\nYou have completed the hunt!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ],
            ).animate().fadeIn(duration: 600.ms).scale();
          }

          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppTheme.pastelGreen.withOpacity(0.8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'Mystery #${team.currentMysteryIndex + 1}  •  Team: ${team.teamName}',
                      style: Get.textTheme.titleMedium?.copyWith(
                          color: AppTheme.textDark,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    key: ValueKey(
                        mystery.index.toString() + team.currentPart.toString()),
                    height: Get.height * 0.55,
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        color: AppTheme.cardLight,
                        border: Border.all(
                          color: AppTheme.pastelGreen.withOpacity(0.5),
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.pastelGreen.withOpacity(0.2),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          )
                        ]),
                    child: team.currentPart == MysteryPart.riddle
                        ? Center(
                            child: SingleChildScrollView(
                              padding: const EdgeInsets.all(32.0),
                              child: Text(
                                mystery.riddle,
                                textAlign: TextAlign.center,
                                style: Get.textTheme.headlineSmall?.copyWith(
                                    height: 1.6, color: AppTheme.textDark),
                              ),
                            ),
                          )
                        : Column(
                            // Use a Column for Image + Hint
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: CachedNetworkImage(
                                      imageUrl: mystery.distortedImageUrl,
                                      fit: BoxFit.contain,
                                      placeholder: (context, url) => Center(
                                          child: Lottie.asset(
                                              'assets/lottie/uploading_animation.json',
                                              width: 100)),
                                      errorWidget: (context, url, error) =>
                                          const Center(
                                              child: Icon(Icons.error)),
                                    ),
                                  ),
                                ),
                              ),
                              // The new hint text
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(16, 0, 16, 16),
                                child: Text(
                                  "Hint: Look near the ${mystery.riddleAnswerDescription}",
                                  textAlign: TextAlign.center,
                                  style: Get.textTheme.titleMedium?.copyWith(
                                      color: AppTheme.textDark.withOpacity(0.7),
                                      fontStyle: FontStyle.italic),
                                ),
                              ),
                            ],
                          ),
                  ).animate().fadeIn(duration: 600.ms),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ElevatedButton.icon(
                    icon: const FaIcon(FontAwesomeIcons.camera, size: 20),
                    label: Text(controller.buttonText),
                    style: Get.theme.elevatedButtonTheme.style?.copyWith(
                        backgroundColor: MaterialStateProperty.all(
                            controller.isButtonDisabled
                                ? Colors.grey.shade600
                                : null),
                        padding: MaterialStateProperty.all(
                          const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 32),
                        ),
                        shape: MaterialStateProperty.all(const StadiumBorder()),
                        elevation: MaterialStateProperty.all(8),
                        shadowColor: MaterialStateProperty.all(
                            AppTheme.pastelGreen.withOpacity(0.5))),
                    onPressed: controller.isButtonDisabled
                        ? null
                        : () {
                            controller.submitAnswer();
                          },
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
}
