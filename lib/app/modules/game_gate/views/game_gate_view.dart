import 'dart:async';

import 'package:scanvenger_hunt_2/app/modules/credits/views/credits_view.dart';
import 'package:scanvenger_hunt_2/app/modules/game_gate/controllers/game_gate_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/home/views/home_view.dart';
import 'package:scanvenger_hunt_2/app/modules/rules/views/rules_view.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class GameGateView extends GetView<GameGateController> {
  const GameGateView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      switch (controller.gamePhase.value) {
        case GamePhase.loading:
          return Scaffold(
            body: Center(
              child: Lottie.asset(
                'assets/lottie/uploading_animation.json',
                width: 150,
                height: 150,
              ),
            ),
          );
        case GamePhase.waitingToStart:
          return WaitingToStartScreen(controller: controller);
        case GamePhase.inProgress:
          return const HomeView();
        case GamePhase.finished:
          return const GameOverScreen();
      }
    });
  }
}

// --- WaitingToStartScreen with new "Credits" button ---
class WaitingToStartScreen extends StatefulWidget {
  const WaitingToStartScreen({Key? key, required this.controller})
      : super(key: key);
  final GameGateController controller;

  @override
  State<WaitingToStartScreen> createState() => _WaitingToStartScreenState();
}

class _WaitingToStartScreenState extends State<WaitingToStartScreen>
    with TickerProviderStateMixin {
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return "$hours:$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: AppTheme.pastelGreen,
            spawnOpacity: 0.0,
            opacityChangeRate: 0.25,
            minOpacity: 0.1,
            maxOpacity: 0.3,
            particleCount: 50,
            spawnMaxRadius: 15.0,
            spawnMinRadius: 10.0,
            spawnMaxSpeed: 50.0,
            spawnMinSpeed: 20.0,
          ),
        ),
        vsync: this,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 2),
                Lottie.asset(
                  'assets/lottie/flower_animation.json',
                  width: 200,
                  height: 200,
                ),
                const SizedBox(height: 16),
                Text(
                  'The Hunt Begins In:',
                  style: Get.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w300,
                    color: AppTheme.textDark.withOpacity(0.8),
                  ),
                ),
                const SizedBox(height: 8),
                Obx(() => Text(
                      _formatDuration(widget.controller.timeUntilStart.value),
                      style: Get.textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textDark),
                    )),
                const Spacer(flex: 1),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40.0),
                  child: ElevatedButton.icon(
                    icon: const Icon(Icons.rule_folder_outlined,
                        color: AppTheme.textDark),
                    label: Text('View Rules',
                        style: Get.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppTheme.textDark)),
                    onPressed: () => Get.to(() => const RulesView()),
                  ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  child: Text(
                    'View Credits',
                    style: TextStyle(color: AppTheme.textDark.withOpacity(0.6)),
                  ),
                  onPressed: () {
                    Get.to(() => const CreditsView());
                  },
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// --- GameOverScreen with automatic navigation to Credits ---
class GameOverScreen extends StatefulWidget {
  const GameOverScreen({Key? key}) : super(key: key);

  @override
  State<GameOverScreen> createState() => _GameOverScreenState();
}

class _GameOverScreenState extends State<GameOverScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    // Automatically navigate to credits after 10 seconds
    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        // Check if the widget is still on screen
        Get.off(() => const CreditsView()); // Use Get.off to replace the screen
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: ParticleOptions(
            baseColor: AppTheme.pastelPink,
            spawnOpacity: 0.0,
            opacityChangeRate: 0.25,
            minOpacity: 0.1,
            maxOpacity: 0.4,
            particleCount: 70,
            spawnMaxRadius: 20.0,
            spawnMinRadius: 10.0,
            spawnMaxSpeed: 60.0,
            spawnMinSpeed: 30.0,
          ),
        ),
        vsync: this,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Lottie.asset(
                'assets/lottie/event_over_animation.json',
                width: 250,
                height: 250,
              ),
              const SizedBox(height: 24),
              Text(
                "Time's Up!",
                style: Get.textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textDark,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "The scavenger hunt has ended.",
                textAlign: TextAlign.center,
                style: Get.textTheme.titleLarge
                    ?.copyWith(color: AppTheme.textDark.withOpacity(0.8)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
