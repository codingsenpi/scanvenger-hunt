import 'package:animated_background/animated_background.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart'; // Import Google Fonts
import 'package:lottie/lottie.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class CreditsView extends StatefulWidget {
  const CreditsView({Key? key}) : super(key: key);

  @override
  State<CreditsView> createState() => _CreditsViewState();
}

class _CreditsViewState extends State<CreditsView>
    with TickerProviderStateMixin {
  // --- List of 20 Dummy Names ---
  final List<String> contributors = [
    'TGCC and TEAM',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        behaviour: RandomParticleBehaviour(
          options: const ParticleOptions(
            baseColor: AppTheme.pastelPink,
            particleCount: 50,
            spawnMaxRadius: 10.0,
            spawnMinRadius: 5.0,
            minOpacity: 0.1,
            maxOpacity: 0.4,
          ),
        ),
        vsync: this,
        child: SafeArea(
          child: Column(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: IconButton(
                  icon: const Icon(Icons.close, color: AppTheme.textDark),
                  onPressed: () => Get.back(),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // --- "Developed By" Card ---
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'Developed By',
                                style: Get.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: AppTheme.textDark.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Rahul Bagdi',
                                style: Get.textTheme.displayMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textDark,
                                ),
                              ),
                              // --- THIS IS THE CHANGE ---
                              Text(
                                "<codingsenpi>",
                                style: Get.textTheme.titleLarge?.copyWith(
                                  fontStyle: FontStyle.italic,
                                  color: AppTheme.textDark.withOpacity(0.7),
                                  // Apply the monospace font here
                                  fontFamily: GoogleFonts.firaCode().fontFamily,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),

                      // --- "With the help of" Card ---
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24.0),
                          child: Column(
                            children: [
                              Text(
                                'With the help of',
                                style: Get.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.w300,
                                  color: AppTheme.textDark.withOpacity(0.8),
                                ),
                              ),
                              const SizedBox(height: 20),
                              // Generate the list of names
                              ...contributors
                                  .map((name) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8.0),
                                        child: Text(name,
                                            style: Get.textTheme.titleMedium),
                                      ))
                                  .toList(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Lottie.asset(
                'assets/lottie/heart_animation.json',
                width: 100,
                height: 100,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
