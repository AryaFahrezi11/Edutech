import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class MultiplayerMenuView extends StatelessWidget {
  const MultiplayerMenuView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF0F7FF), // Same background as Home
      child: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(28)),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF1CB0F6).withOpacity(0.3), blurRadius: 16, offset: const Offset(0, 6)),
                ],
              ),
              child: const Text(
                "Arena Duel ⚔️",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                textAlign: TextAlign.center,
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
                  color: Color(0xFF2C3E50),
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
                    emoji: "🧩",
                    gradient: const [Color(0xFFFF416C), Color(0xFFFF4B2B)],
                    onTap: () => Get.toNamed(Routes.MULTIPLAYER_LOBBY),
                  ),
                  _buildMenuBox(
                    title: "Balap Nulis",
                    emoji: "✏️",
                    gradient: [Colors.grey.shade400, Colors.grey.shade500],
                    isLocked: true,
                    onTap: () => _showLockedMsg(),
                  ),
                  _buildMenuBox(
                    title: "Adu Eja",
                    emoji: "🗣️",
                    gradient: [Colors.grey.shade400, Colors.grey.shade500],
                    isLocked: true,
                    onTap: () => _showLockedMsg(),
                  ),
                  _buildMenuBox(
                    title: "Detektif Cepat",
                    emoji: "🔍",
                    gradient: [Colors.grey.shade400, Colors.grey.shade500],
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
    required String emoji,
    required List<Color> gradient,
    required VoidCallback onTap,
    bool isLocked = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradient,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            if (!isLocked)
              BoxShadow(
                color: gradient[0].withOpacity(0.4),
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
                Text(emoji, style: const TextStyle(fontSize: 50)),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
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
