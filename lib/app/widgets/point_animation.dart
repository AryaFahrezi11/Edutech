import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/sfx_service.dart';

class PointAnimation {
  static void showPointAnimation(int earnedPoints, {VoidCallback? onComplete}) {
    if (earnedPoints <= 0) {
      if (onComplete != null) onComplete();
      return;
    }
    
    try {
      Get.find<SfxService>().playCoin();
    } catch (e) {
      // Ignore if not initialized
    }
    
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        child: Center(
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0.0, end: 1.0),
            duration: const Duration(milliseconds: 600),
            curve: Curves.elasticOut,
            builder: (context, value, child) {
              return Transform.scale(
                scale: value,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("⭐", style: TextStyle(fontSize: 100)),
                    const SizedBox(height: 16),
                    Text(
                      "+$earnedPoints Bintang!",
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFFFFD700),
                        shadows: [
                          Shadow(
                            offset: Offset(0, 4),
                            blurRadius: 10,
                            color: Colors.black45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.3),
    );

    // Auto close after 1.5 seconds
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }
      if (onComplete != null) {
        onComplete();
      }
    });
  }
}
