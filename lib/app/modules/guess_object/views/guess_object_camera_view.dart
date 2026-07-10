import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ultralytics_yolo/ultralytics_yolo.dart';
import '../../../data/edu_theme.dart';
import '../controllers/guess_object_controller.dart';

class GuessObjectCameraView extends GetView<GuessObjectController> {
  const GuessObjectCameraView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Obx(() {
        if (controller.isPermissionDenied.value) {
          return const Center(
            child: Text(
              "Izin kamera atau mikrofon ditolak.\nIzinkan di pengaturan untuk bermain.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 16),
            ),
          );
        }

        if (!controller.isCameraReady.value) {
          return const Center(
            child: CircularProgressIndicator(color: EduTheme.primary),
          );
        }

        return Stack(
          children: [
            // 1. Camera Feed & YOLO
            Positioned.fill(
              child: YOLOView(
                controller: controller.yoloController,
                modelPath: YOLO.defaultOfficialModel() ?? 'yolo11n',
                task: YOLOTask.detect,
                onResult: controller.onYoloResult,
              ),
            ),

            // 2. Bounding Box Overlay (jika sedang scanning atau locked)
            if (controller.currentState.value != GuessState.success)
              Positioned.fill(
                child: Obx(() {
                  final result = controller.matchingResult.value;
                  if (result == null) return const SizedBox.shrink();

                  return LayoutBuilder(
                    builder: (context, constraints) {
                      final screenW = constraints.maxWidth;
                      final screenH = constraints.maxHeight;

                      final box = result.normalizedBox;
                      final left = box.left * screenW;
                      final top = box.top * screenH;
                      final width = box.width * screenW;
                      final height = box.height * screenH;

                      final isLocked = controller.currentState.value != GuessState.scanning;

                      return Stack(
                        children: [
                          Positioned(
                            left: left,
                            top: top,
                            width: width,
                            height: height,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: isLocked ? Colors.greenAccent : const Color(0xFFFF416C),
                                  width: isLocked ? 6.0 : 4.0,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                color: isLocked 
                                    ? Colors.greenAccent.withValues(alpha: 0.2)
                                    : Colors.transparent,
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
                                    isLocked ? "Benda Dikunci! 🔒" : "Memindai... 🔍",
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

            // 3. Header & Back Button
            Positioned(
              top: 50,
              left: 20,
              child: InkWell(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_back, color: Colors.white),
                ),
              ),
            ),
            
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.6),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const Text(
                    "Tebak Benda 🎤",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),

            // 4. Instructions / UI bawah
            Positioned(
              bottom: 40,
              left: 20,
              right: 20,
              child: _buildBottomUI(),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildBottomUI() {
    final state = controller.currentState.value;

    if (state == GuessState.scanning) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.7),
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Text(
          "Arahkan kameramu ke benda apa saja di sekitarmu!",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
      );
    }

    if (state == GuessState.locked) {
      return Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: EduTheme.primary,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          children: const [
            Icon(Icons.lock, color: Colors.white, size: 32),
            SizedBox(height: 8),
            Text(
              "Benda dikunci! Tunggu aba-aba...",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      );
    }

    if (state == GuessState.listening || state == GuessState.failed) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            Text(
              state == GuessState.failed 
                  ? "Coba ucapkan lagi!" 
                  : "Benda apakah ini?",
              style: TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.w900, 
                color: state == GuessState.failed ? Colors.red : EduTheme.textDark,
              ),
            ),
            const SizedBox(height: 16),
            
            // Microphone Button
            GestureDetector(
              onTap: () {
                if (state == GuessState.failed) {
                  controller.retryListening();
                }
              },
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: state == GuessState.listening ? Colors.redAccent : Colors.grey.shade300,
                  shape: BoxShape.circle,
                  boxShadow: state == GuessState.listening 
                      ? [BoxShadow(color: Colors.redAccent.withValues(alpha: 0.5), blurRadius: 20, spreadRadius: 5)]
                      : [],
                ),
                child: Icon(
                  state == GuessState.listening ? Icons.mic : Icons.mic_none,
                  color: state == GuessState.listening ? Colors.white : Colors.grey.shade600,
                  size: 48,
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            Text(
              controller.recognizedText.value.isEmpty 
                  ? (state == GuessState.listening ? "Mendengarkan..." : "Ketuk mic untuk mengulang")
                  : '"${controller.recognizedText.value}"',
              style: const TextStyle(fontSize: 18, color: EduTheme.textMedium, fontStyle: FontStyle.italic),
              textAlign: TextAlign.center,
            ),

            if (state == GuessState.failed)
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: TextButton(
                  onPressed: controller.resetScan,
                  child: const Text("Cari benda lain", style: TextStyle(color: Colors.grey)),
                ),
              )
          ],
        ),
      );
    }

    if (state == GuessState.success) {
      final item = controller.targetItem.value!;
      return Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
        ),
        child: Column(
          children: [
            const Text("🎉", style: TextStyle(fontSize: 64)),
            const SizedBox(height: 8),
            const Text(
              "BENAR!",
              style: TextStyle(color: Colors.green, fontSize: 24, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              "Ini adalah ${item.nameId}",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text("⭐", style: TextStyle(fontSize: 24)),
                  const SizedBox(width: 8),
                  Text(
                    "+${item.xpReward} Bintang",
                    style: TextStyle(
                      color: Colors.orange.shade800,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
