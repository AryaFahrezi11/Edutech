import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'writing_practice_controller.dart';
import 'handwriting_canvas_painter.dart';

class WritingPracticeView extends GetView<WritingPracticeController> {
  const WritingPracticeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50], // Pastel Blue
      body: SafeArea(
        child: Column(
          children: [
            // --- 1. HEADER & HURUF SELECTOR ---
            _buildHeader(context),
            const SizedBox(height: 10),
            
            // --- 2. MAIN SMART CANVAS (TRAINING GROUND) ---
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.blue.withOpacity(0.2), width: 3),
                  boxShadow: [
                    BoxShadow(color: Colors.blue.withOpacity(0.1), blurRadius: 20, spreadRadius: 5)
                  ],
                ),
                child: Row(
                  children: [
                    // A. Kanvas Menulis
                    Expanded(
                      child: GestureDetector(
                        onPanUpdate: (details) => controller.onPanUpdate(details),
                        onPanEnd: (details) => controller.onPanEnd(),
                        child: LayoutBuilder(builder: (context, constraints) {
                          return Obx(() => CustomPaint(
                            size: constraints.biggest,
                            painter: HandwritingCanvasPainter(
                              userPoints: controller.userPoints.toList(),
                              targetLetter: controller.selectedLetter.value,
                              targetPaths: controller.letterA_Paths,
                              currentStroke: controller.currentStroke.value,
                            ),
                          ));
                        }),
                      ),
                    ),
                    // B. Tombol Interaksi (Samping Kanvas - Lebih Game-like)
                    _buildInteractionTools(),
                  ],
                ),
              ),
            ),
            
            // --- 3. NAVIGASI HURUF & TOMBOL AUDIT (CHECK) ---
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(icon: const Icon(Icons.arrow_back_ios_new), onPressed: () => Get.back()),
              const Spacer(),
              const Icon(Icons.stars, color: Colors.yellow, size: 28),
              const SizedBox(width: 10),
              const Text("Smart Canvas", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blue)),
              const Spacer(),
              _buildStrokeProgress(), // Indikator stroke selesai
            ],
          ),
          const SizedBox(height: 15),
          // Letter Selector (A-Z) - Ceria & Bulat
          _buildLetterSelector(),
        ],
      ),
    );
  }

  Widget _buildStrokeProgress() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
      child: Row(
        children: [
          const Icon(Icons.extension_outlined, color: Colors.green),
          const SizedBox(width: 5),
          Obx(() => Text(
                "${controller.currentStroke.value}/${controller.letterA_Paths.length}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

  Widget _buildLetterSelector() {
    final letters = ['A', 'B', 'C', 'D', 'E', 'F']; // Pemanasan
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: letters.map((letter) => Obx(() {
          final isSelected = controller.selectedLetter.value == letter;
          return Container(
            margin: const EdgeInsets.only(right: 12),
            child: FilterChip(
              label: Text(letter, style: TextStyle(color: isSelected ? Colors.white : Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
              selected: isSelected,
              onSelected: (selected) => controller.selectedLetter.value = letter,
              backgroundColor: Colors.white,
              selectedColor: Colors.blue,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              side: BorderSide(color: Colors.blue.withOpacity(0.1)),
            ),
          );
        })).toList(),
      ),
    );
  }

  Widget _buildInteractionTools() {
    return Container(
      width: 70,
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.blue[50], // Pastel Blue
        borderRadius: const BorderRadius.only(topRight: Radius.circular(30), bottomRight: Radius.circular(30)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildToolButton(Icons.abc, Colors.purple, "Sound"), // Suara Huruf
          const SizedBox(height: 25),
          _buildToolButton(Icons.backspace_outlined, Colors.red, "Hapus"), // Reset Kanvas
          const Spacer(),
          // Preview Urutan Goresan (Mini)
          Image.network('https://gameplus.game/b_lowercase_handwriting_tracing_icon.png', height: 40),
        ],
      ),
    );
  }

  Widget _buildToolButton(IconData icon, Color color, String label) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: color, size: 30),
          onPressed: () => label == "Hapus" ? controller.resetCanvas() : null,
        ),
        Text(label, style: TextStyle(color: color.withOpacity(0.8), fontSize: 10, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBottomControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          IconButton(icon: const Icon(Icons.arrow_back_ios, color: Colors.grey), onPressed: () {}),
          Expanded(child: _buildCheckGoresanButton()), // Tombol Audit Utama
          IconButton(icon: const Icon(Icons.arrow_forward_ios, color: Colors.blue), onPressed: () {}),
        ],
      ),
    );
  }

  // Tombol Besar Ceria & Game-like (PSC 2 & Audit Principle)
  Widget _buildCheckGoresanButton() {
    return SizedBox(
      height: 60,
      child: ElevatedButton.icon(
        onPressed: controller.checkGoresanAudit,
        icon: const Icon(Icons.offline_pin_outlined, color: Colors.white),
        label: const Text("Check Goresan", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4CAF50), // Bubbly Green
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
          elevation: 5,
          shadowColor: Colors.green.withOpacity(0.3),
        ),
      ),
    );
  }
}