import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/object_hunt_controller.dart';
import '../../../routes/app_routes.dart';

class ObjectHuntIntroView extends GetView<ObjectHuntController> {
  const ObjectHuntIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Obx(() {
          final item = controller.targetItem.value;
          if (item == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              // ── HEADER ──
              Container(
                padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                  boxShadow: [
                    BoxShadow(color: Color(0x446C63FF), blurRadius: 20, offset: Offset(0, 10)),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                          onPressed: () => Get.back(),
                        ),
                        const Expanded(
                          child: Text(
                            "Detektif Benda 🔍",
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const SizedBox(height: 20),

                      // ── INSTRUKSI ──
                      const Text(
                        "Carilah benda ini di sekitarmu!",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: EduTheme.textMedium,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // ── KARTU BENDA TARGET ──
                      TweenAnimationBuilder<double>(
                        tween: Tween(begin: 0.8, end: 1.0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutBack,
                        builder: (context, value, child) => Transform.scale(scale: value, child: child),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(32),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6C63FF), Color(0xFF9D4EDD)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(32),
                            boxShadow: const [
                              BoxShadow(color: Color(0x446C63FF), blurRadius: 30, offset: Offset(0, 15)),
                            ],
                          ),
                          child: Column(
                            children: [
                              Text(item.emoji, style: const TextStyle(fontSize: 80)),
                              const SizedBox(height: 16),
                              Text(
                                item.nameId,
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                  letterSpacing: 1,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "(${item.nameEn})",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white.withValues(alpha: 0.7),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // ── PETUNJUK ──
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: EduTheme.border, width: 2),
                          boxShadow: EduTheme.softShadow(),
                        ),
                        child: Row(
                          children: [
                            const Text("💡", style: TextStyle(fontSize: 28)),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.description,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: EduTheme.textDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      // ── TOMBOL MULAI ──
                      SizedBox(
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.OBJECT_HUNT_CAMERA);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                              ),
                              borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                              boxShadow: EduTheme.buttonShadow(const Color(0xFF6C63FF)),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("📸", style: TextStyle(fontSize: 24)),
                                SizedBox(width: 12),
                                Text(
                                  "MULAI MENCARI",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w900,
                                    color: Colors.white,
                                    letterSpacing: 1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),


                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
