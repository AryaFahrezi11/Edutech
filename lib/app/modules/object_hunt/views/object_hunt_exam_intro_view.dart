import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/object_hunt_exam_controller.dart';
import '../../../routes/app_routes.dart';

class ObjectHuntExamIntroView extends GetView<ObjectHuntExamController> {
  const ObjectHuntExamIntroView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER ──
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 20, 24),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                boxShadow: [
                  BoxShadow(color: Color(0x44FC5C7D), blurRadius: 20, offset: Offset(0, 10)),
                ],
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                    onPressed: () => Get.back(),
                  ),
                  const Expanded(
                    child: Text(
                      "Ujian Berburu ⏱️",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Siap untuk Ujian?",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: EduTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      "Kamu punya waktu 60 detik untuk menemukan 5 benda secara berurutan!",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: EduTheme.textMedium,
                      ),
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: EduTheme.border, width: 2),
                        boxShadow: EduTheme.softShadow(),
                      ),
                      child: const Column(
                        children: [
                          Text("🎯", style: TextStyle(fontSize: 48)),
                          SizedBox(height: 16),
                          Text(
                            "Aturan Ujian:",
                            style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                          SizedBox(height: 8),
                          Text(
                            "Arahkan kameramu ke benda yang diminta secepat mungkin. Waktu terus berjalan!",
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 14, color: EduTheme.textMedium),
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
                          Get.toNamed(Routes.OBJECT_HUNT_EXAM_CAMERA);
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFFFC5C7D), Color(0xFF6A3093)],
                            ),
                            borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                            boxShadow: EduTheme.buttonShadow(const Color(0xFFFC5C7D)),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("🚀", style: TextStyle(fontSize: 24)),
                              SizedBox(width: 12),
                              Text(
                                "MULAI UJIAN",
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
        ),
      ),
    );
  }
}
