import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:scanvenger_hunt_2/app/data/models/team.dart';
import 'package:scanvenger_hunt_2/app/modules/leaderboard/controllers/leaderboard_controller.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Live Leaderboard'),
      ),
      body: Obx(() {
        if (controller.teams.value.isEmpty) {
          return Center(
            child: Lottie.asset(
              'assets/lottie/uploading_animation.json',
              width: 150,
              height: 150,
            ),
          );
        }
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          itemCount: controller.teams.value.length,
          itemBuilder: (context, index) {
            final team = controller.teams.value[index];
            final rank = index + 1;
            Widget leadingIcon;
            if (rank == 1) {
              leadingIcon = const CircleAvatar(
                radius: 22,
                backgroundColor: AppTheme.pastelGreen,
                child: Icon(Icons.star, color: Colors.white, size: 28),
              );
            } else if (rank == 2) {
              leadingIcon = CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.pastelBlue.withOpacity(0.8),
                child: Text('$rank',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              );
            } else if (rank == 3) {
              leadingIcon = CircleAvatar(
                radius: 20,
                backgroundColor: AppTheme.pastelPink.withOpacity(0.8),
                child: Text('$rank',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: AppTheme.textDark)),
              );
            } else {
              leadingIcon = CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: Text('$rank',
                    style: const TextStyle(color: Colors.black54)),
              );
            }
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: ListTile(
                leading: leadingIcon,
                title: Text(
                  team.teamName,
                  style: Get.textTheme.titleLarge
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  '${team.score} Solved',
                  style: Get.textTheme.titleMedium,
                ),
              ),
            )
                .animate()
                .fadeIn(duration: 400.ms, delay: (100 * index).ms)
                .slideX(begin: 0.2, duration: 400.ms);
          },
        );
      }),
    );
  }
}
