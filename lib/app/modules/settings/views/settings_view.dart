import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

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
                  colors: [Color(0xFF8E2DE2), Color(0xFF4A00E0)], // Tema ungu untuk pengaturan
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
                boxShadow: [
                  BoxShadow(color: Color(0x444A00E0), blurRadius: 20, offset: Offset(0, 10)),
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
                      "Pengaturan ⚙️",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Suara & Animasi",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: EduTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // SFX Toggle
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: EduTheme.blue.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Text("🔔", style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Efek Suara (SFX)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: EduTheme.textDark,
                                  ),
                                ),
                                Text(
                                  "Suara koin, jawaban benar/salah",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: EduTheme.textMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => Switch(
                            value: controller.isSfxEnabled.value,
                            activeColor: EduTheme.blue,
                            onChanged: controller.toggleSfx,
                          )),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // TTS Toggle
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
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: EduTheme.orange.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Text("🤖", style: TextStyle(fontSize: 24)),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Suara Asisten AI (TTS)",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    color: EduTheme.textDark,
                                  ),
                                ),
                                Text(
                                  "Suara karakter yang membimbing belajar",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: EduTheme.textMedium,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Obx(() => Switch(
                            value: controller.isTtsEnabled.value,
                            activeColor: EduTheme.orange,
                            onChanged: controller.toggleTts,
                          )),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    const Center(
                      child: Text(
                        "Versi 1.0.0",
                        style: TextStyle(
                          color: EduTheme.textMedium,
                          fontWeight: FontWeight.bold,
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
