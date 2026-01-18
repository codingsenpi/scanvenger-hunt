import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:feather_icons/feather_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:scanvenger_hunt_2/app/modules/auth/controllers/auth_controller.dart';
import 'package:scanvenger_hunt_2/app/modules/game_gate/views/game_gate_view.dart';
import 'package:scanvenger_hunt_2/app/utils/app_theme.dart';

class AuthView extends GetView<AuthController> {
  const AuthView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return controller.user.value != null
          ? const GameGateView()
          : const CustomLoginScreen();
    });
  }
}

class CustomLoginScreen extends GetView<AuthController> {
  const CustomLoginScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Form(
              key: controller.formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        height: 150,
                        width: 150,
                      ),
                      SizedBox(
                        height: 24,
                      ),
                      AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText(
                            'ScanVenger',
                            textStyle: Get.textTheme.displaySmall?.copyWith(
                              // --- THIS IS THE FIX ---
                              // Using the correct 'pastelGreen' variable
                              color: AppTheme.pastelGreen,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 200),
                          ),
                          TypewriterAnimatedText(
                            'Hunt',
                            textStyle: Get.textTheme.displaySmall?.copyWith(
                              // --- THIS IS THE FIX ---
                              // Using the correct 'pastelGreen' variable
                              color: AppTheme.pastelGreen,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 200),
                          ),
                          TypewriterAnimatedText(
                            'BY TGCC',
                            textStyle: Get.textTheme.displaySmall?.copyWith(
                              // --- THIS IS THE FIX ---
                              // Using the correct 'pastelGreen' variable
                              color: AppTheme.pastelGreen,
                              fontWeight: FontWeight.bold,
                            ),
                            speed: const Duration(milliseconds: 200),
                          ),
                        ],
                        isRepeatingAnimation: true,
                        pause: const Duration(milliseconds: 900),
                      )
                    ],
                  ),
                  const SizedBox(height: 48),
                  TextFormField(
                    controller: controller.emailController,
                    decoration: const InputDecoration(
                      labelText: 'Team Email',
                      prefixIcon: Icon(FeatherIcons.mail),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || !GetUtils.isEmail(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: controller.passwordController,
                    decoration: const InputDecoration(
                      labelText: 'Password',
                      prefixIcon: Icon(FeatherIcons.lock),
                    ),
                    obscureText: true,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 24),
                  Obx(() => ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : () => controller.login(),
                        child: controller.isLoading.value
                            ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  color: AppTheme.textDark,
                                  strokeWidth: 2.0,
                                ))
                            : const Text('Login'),
                      )),
                  if (kDebugMode) ...[
                    const SizedBox(height: 16),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange),
                      onPressed: () => controller.quickLogin(),
                      child: const Text('QUICK LOGIN (DEBUG ONLY)'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
