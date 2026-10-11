import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../../../data/edu_theme.dart';

class MultiplayerMenuView extends StatelessWidget {
  const MultiplayerMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final missionIndex = Get.arguments?['mission_index'] as int?;

    return Container(
      color: EduTheme.bgPrimaryTint,
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                color: EduTheme.primary,
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
                boxShadow: [
                  BoxShadow(color: EduTheme.primary.withOpacity(0.4), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sports_esports_rounded, color: Colors.white, size: 28),
                  const SizedBox(width: 8),
                  const Text(
                    "Arena Duel",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 30),
            
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                "Pilih Kategori Duel!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: EduTheme.textDark,
                ),
              ),
            ),
            
            const SizedBox(height: 30),
            
            // Grid Menu
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(24),
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                children: [
                  _buildMenuBox(
                    title: "Susun Kata",
                    icon: Icons.extension_rounded,
                    color: EduTheme.red,
                    onTap: () => Get.toNamed(Routes.MULTIPLAYER_LOBBY, arguments: {'mission_index': missionIndex}),
                  ),
                  _buildMenuBox(
                    title: "Balap Nulis",
                    icon: Icons.edit_note_rounded,
                    color: Colors.grey.shade400,
                    isLocked: true,
                    onTap: () => _showLockedMsg(),
                  ),
                  _buildMenuBox(
                    title: "Adu Eja",
                    icon: Icons.record_voice_over_rounded,
                    color: Colors.grey.shade400,
                    isLocked: true,
                    onTap: () => _showLockedMsg(),
                  ),
                  _buildMenuBox(
                    title: "Detektif Cepat",
                    icon: Icons.search_rounded,
                    color: Colors.grey.shade400,
                    isLocked: true,
                    onTap: () => _showLockedMsg(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuBox({
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: color.withOpacity(0.4),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Icon(icon, size: 50, color: Colors.white),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.lock_rounded, color: Colors.white, size: 28),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showLockedMsg() {
    Get.snackbar(
      "Terkunci",
      "Mode ini masih dalam pengembangan!",
      backgroundColor: Colors.white,
      colorText: const Color(0xFF2C3E50),
      margin: const EdgeInsets.all(16),
      icon: const Icon(Icons.lock, color: Colors.orange),
    );
  }
}
