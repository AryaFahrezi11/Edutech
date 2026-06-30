import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../../data/edu_theme.dart';
import '../controllers/object_hunt_controller.dart';

class ObjectHuntCameraView extends GetView<ObjectHuntController> {
  const ObjectHuntCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isPermissionDenied.value) {
          return const Center(
            child: Text(
              "Izin kamera ditolak.\nPeriksa pengaturan aplikasi.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }
        if (!controller.isCameraReady.value) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        return _buildCameraScreen(context);
      }),
    );
  }

  Widget _buildCameraScreen(BuildContext context) {
    return Stack(
      children: [
        // ── YOLO LIVE CAMERA ──
        Positioned.fill(
          child: YOLOView(
            controller: controller.yoloController,
            modelPath: YOLO.defaultOfficialModel() ?? 'yolo11n',
            task: YOLOTask.detect,
            onResult: (results) {
              controller.onYoloResult(results);
            },
          ),
        ),

        // ── CUSTOM BOUNDING BOX OVERLAY ──
        Positioned.fill(
          child: Obx(() {
            final match = controller.matchingResult.value;
            if (match == null || controller.isFound.value) return const SizedBox.shrink();

            return LayoutBuilder(
              builder: (context, constraints) {
                final screenW = constraints.maxWidth;
                final screenH = constraints.maxHeight;

                final box = match.normalizedBox;
                final left = box.left * screenW;
                final top = box.top * screenH;
                final width = box.width * screenW;
                final height = box.height * screenH;

                return Stack(
                  children: [
                    Positioned(
                      left: left,
                      top: top,
                      width: width,
                      height: height,
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: match.confidence >= 0.7 ? Colors.greenAccent : Colors.orangeAccent,
                            width: 3,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.black.withValues(alpha: 0.6),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              controller.detectedLabel.value, // Sudah dalam bahasa Indonesia (benda anak)
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          }),
        ),

        // ── OVERLAY UI DI ATAS KAMERA ──
        Positioned.fill(
          child: Obx(() {
            final item = controller.targetItem.value;
            final found = controller.isFound.value;

            if (item == null) return const SizedBox.shrink();

            return Stack(
              children: [
                // ── Target Banner (atas) ──
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        children: [
                          // Tombol kembali
                          GestureDetector(
                            onTap: () => Get.back(),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 18),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Chip benda yang dicari
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text("🎯", style: TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      "Cari: ${item.nameId} ${item.emoji}",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w800,
                                        fontSize: 16,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Confidence Bar (bawah) ──
                if (!found)
                  Positioned(
                    bottom: 80,
                    left: 24,
                    right: 24,
                    child: Obx(() {
                      final label = controller.detectedLabel.value;
                      final conf = controller.confidence.value;
                      if (label.isEmpty) return const SizedBox.shrink();

                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Terdeteksi: $label (${(conf * 100).toStringAsFixed(0)}%)",
                              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 13),
                            ),
                            const SizedBox(height: 6),
                            LinearProgressIndicator(
                              value: conf,
                              backgroundColor: Colors.white24,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                conf >= 0.7 ? Colors.greenAccent : Colors.orangeAccent,
                              ),
                              minHeight: 8,
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ],
                        ),
                      );
                    }),
                  ),

                // ── OVERLAY SUKSES ──
                if (found)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.6),
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 600),
                          curve: Curves.easeOutBack,
                          builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
                          child: Container(
                            padding: const EdgeInsets.all(32),
                            margin: const EdgeInsets.symmetric(horizontal: 32),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(32),
                              boxShadow: const [
                                BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 10)),
                              ],
                            ),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text("🎉", style: TextStyle(fontSize: 64)),
                                const SizedBox(height: 8),
                                Text(
                                  item.nameId,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    color: EduTheme.textDark,
                                  ),
                                ),
                                const Text(
                                  "Ditemukan!",
                                  style: TextStyle(fontSize: 16, color: EduTheme.textMedium),
                                ),
                                const SizedBox(height: 20),
                                GestureDetector(
                                  onTap: () {
                                    Get.back(); // Kembali ke intro untuk item berikutnya
                                    controller.goNext();
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                                      ),
                                      borderRadius: BorderRadius.circular(50),
                                      boxShadow: EduTheme.buttonShadow(const Color(0xFF6C63FF)),
                                    ),
                                    child: const Text(
                                      "Lanjut! →",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            );
          }),
        ),
      ],
    );
  }
}
