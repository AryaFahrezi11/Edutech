import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:video_player/video_player.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // or any color that matches the video borders
      body: Center(
        child: Obx(() {
          if (controller.isVideoInitialized.value) {
            return SizedBox.expand(
              child: FittedBox(
                fit: BoxFit.cover,
                child: SizedBox(
                  width: controller.videoController.value.size.width == 0.0 ? 1920 : controller.videoController.value.size.width,
                  height: controller.videoController.value.size.height == 0.0 ? 1080 : controller.videoController.value.size.height,
                  child: VideoPlayer(controller.videoController),
                ),
              ),
            );
          } else {
            return const CircularProgressIndicator(color: Colors.white);
          }
        }),
      ),
    );
  }
}
