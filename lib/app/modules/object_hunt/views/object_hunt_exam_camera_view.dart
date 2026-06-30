import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../../data/edu_theme.dart';
import '../controllers/object_hunt_exam_controller.dart';

class ObjectHuntExamCameraView extends StatefulWidget {
  const ObjectHuntExamCameraView({super.key});

  @override
  State<ObjectHuntExamCameraView> createState() => _ObjectHuntExamCameraViewState();
}

class _ObjectHuntExamCameraViewState extends State<ObjectHuntExamCameraView> {
  final controller = Get.find<ObjectHuntExamController>();
  bool isCameraReady = false;
  bool isPermissionDenied = false;

  @override
  void initState() {
    super.initState();
    _requestPermission();
  }

  Future<void> _requestPermission() async {
    final status = await Permission.camera.request();
    if (mounted) {
      if (status.isGranted) {
        setState(() {
          isCameraReady = true;
        });
      } else {
        setState(() {
          isPermissionDenied = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: () {
        if (isPermissionDenied) {
          return const Center(
            child: Text(
              "Izin kamera ditolak.\nPeriksa pengaturan aplikasi.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }
        if (!isCameraReady) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.white),
          );
        }
        return _buildCameraScreen(context);
      }(),
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
            if (match == null || controller.isFound.value || controller.isExamFinished.value) {
              return const SizedBox.shrink();
            }

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
                              controller.detectedLabel.value, // Sudah dalam bahasa anak
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
                          // Chip Timer dan Benda
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.65),
                                borderRadius: BorderRadius.circular(40),
                                border: Border.all(color: Colors.white.withValues(alpha: 0.3), width: 1.5),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Text("⏱️", style: TextStyle(fontSize: 16)),
                                      const SizedBox(width: 6),
                                      Text(
                                        "${controller.timeLeft.value}s",
                                        style: TextStyle(
                                          color: controller.timeLeft.value <= 10 ? Colors.redAccent : Colors.white,
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${controller.foundCount.value}/${controller.totalTarget}",
                                    style: const TextStyle(
                                      color: Colors.yellowAccent,
                                      fontWeight: FontWeight.w900,
                                      fontSize: 16,
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

                // ── Benda Target Tengah Atas ──
                Positioned(
                  top: 90,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(colors: [Color(0xFFFC5C7D), Color(0xFF6A3093)]),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10)],
                        ),
                        child: Row(
                          children: [
                            Text(item.emoji, style: const TextStyle(fontSize: 24)),
                            const SizedBox(width: 10),
                            Text(
                              item.nameId,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // ── Confidence Bar (bawah) ──
                if (!found && !controller.isExamFinished.value)
                  Positioned(
                    bottom: 40,
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

                // ── OVERLAY SUKSES ITEM ──
                if (found && !controller.isExamFinished.value)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.4),
                      child: Center(
                        child: TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0.5, end: 1.0),
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeOutBack,
                          builder: (ctx, v, child) => Transform.scale(scale: v, child: child),
                          child: Container(
                            padding: const EdgeInsets.all(24),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(color: Colors.black26, blurRadius: 30, offset: Offset(0, 10)),
                              ],
                            ),
                            child: const Text("✅", style: TextStyle(fontSize: 64)),
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                 // OVERLAY TIME UP
                 if (controller.isExamFinished.value)
                  Positioned.fill(
                    child: Container(
                      color: Colors.black.withValues(alpha: 0.8),
                      child: const Center(
                        child: Text(
                          "WAKTU HABIS!",
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.w900,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  )
              ],
            );
          }),
        ),
      ],
    );
  }
}
