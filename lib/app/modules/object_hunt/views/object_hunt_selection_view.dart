import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/object_hunt_selection_controller.dart';

class ObjectHuntSelectionView extends GetView<ObjectHuntSelectionController> {
  const ObjectHuntSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: Obx(() {
                // Konversi ke list di luar itemBuilder agar GetX bisa men-track perubahannya,
                // karena itemBuilder berjalan secara malas (lazy)
                final completedItems = controller.progressService.completedObjectHuntItems.toList();
                
                return GridView.builder(
                  padding: const EdgeInsets.all(20),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3, 
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 0.9,
                  ),
                  itemCount: controller.items.length,
                  itemBuilder: (context, index) {
                    final item = controller.items[index];
                    final isCompleted = completedItems.contains(index);
                    
                    final colors = [
                      const Color(0xFFFF6B6B), 
                      const Color(0xFF4ECDC4), 
                      const Color(0xFFFFD166), 
                      const Color(0xFF9D4EDD), 
                      const Color(0xFFFF9F1C), 
                      const Color(0xFF11998E), 
                    ];
                    final bgColor = colors[index % colors.length];

                    return TweenAnimationBuilder<double>(
                      tween: Tween(begin: 0, end: 1),
                      duration: Duration(milliseconds: 300 + (index % 10) * 50),
                      curve: Curves.easeOutBack,
                      builder: (context, value, child) => Transform.scale(
                        scale: value,
                        child: child,
                      ),
                      child: _HuntItemCard(
                        emoji: item.emoji,
                        name: item.nameId,
                        bgColor: bgColor,
                        isCompleted: isCompleted,
                        onTap: isCompleted ? () {
                          Get.snackbar(
                            "Sudah Ditemukan ✅", 
                            "Kamu sudah menemukan ${item.nameId}!",
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.green.withValues(alpha: 0.9),
                            colorText: Colors.white,
                            borderRadius: 20,
                            margin: const EdgeInsets.all(16),
                          );
                        } : () {
                          controller.speakItemName(item.nameId);
                          Get.toNamed(Routes.OBJECT_HUNT_INTRO, arguments: {
                            'item': item,
                            'index': index,
                            'mission_index': controller.missionIndex,
                          });
                        },
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 20, 24),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(color: Color(0x4458CC02), blurRadius: 15, offset: Offset(0, 8))
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  "Pilih Benda",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1.5,
                  ),
                ),
              ),
              const SizedBox(width: 48), // Balance for back button
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Benda mana yang ingin kamu cari hari ini?",
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _HuntItemCard extends StatelessWidget {
  final String emoji;
  final String name;
  final Color bgColor;
  final bool isCompleted;
  final VoidCallback onTap;

  const _HuntItemCard({
    required this.emoji,
    required this.name,
    required this.bgColor,
    required this.isCompleted,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isCompleted ? Colors.grey.shade300 : bgColor,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!isCompleted)
              BoxShadow(
                color: bgColor.withValues(alpha: 0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              )
          ],
        ),
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    emoji,
                    style: TextStyle(
                      fontSize: 48,
                      color: isCompleted ? Colors.grey.shade500 : Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: isCompleted ? Colors.grey.shade500 : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            if (isCompleted)
              Positioned(
                right: 8,
                bottom: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
