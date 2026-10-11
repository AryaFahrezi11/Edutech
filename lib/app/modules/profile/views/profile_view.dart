import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/profile_controller.dart';
import '../../../services/log_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // ================= HEADER KARTU PROFIL (Full Width) =================
              _buildProfileHeader(),
              
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Column(
                  children: [
                    // ================= KARTU INFO SINGKAT =================
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.star_rounded,
                      value: '${controller.totalPoints}',
                      label: 'Bintang',
                      color: EduTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.local_fire_department_rounded,
                      value: '${controller.streakDays} Hari',
                      label: 'Beruntun',
                      color: EduTheme.orange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      icon: Icons.diamond_rounded,
                      value: '${controller.totalMissions}',
                      label: 'Misi',
                      color: EduTheme.blue,
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 20),

              // ================= DAFTAR MENU PETUALANGAN =================
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Menu Petualangan',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: EduTheme.textDark,
                  ),
                ),
              ),
              const SizedBox(height: 14),

              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildGridMenuButton(
                    icon: Icons.palette_rounded,
                    title: 'Edit Profil',
                    color: EduTheme.blue,
                    onTap: () => Get.toNamed('/edit-profile'),
                  ),
                  _buildGridMenuButton(
                    icon: Icons.bar_chart_rounded,
                    title: 'Rapor Belajar',
                    color: EduTheme.primary,
                    onTap: () => Get.toNamed('/raport'),
                  ),
                  _buildGridMenuButton(
                    icon: Icons.history_edu_rounded,
                    title: 'Riwayat',
                    color: EduTheme.purple,
                    onTap: () => Get.toNamed('/activity-log'),
                  ),
                  _buildGridMenuButton(
                    icon: Icons.settings_rounded,
                    title: 'Pengaturan',
                    color: EduTheme.textMedium,
                    onTap: () => Get.toNamed('/settings'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // ================= TOMBOL LOGOUT =================
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    title: "Mau Istirahat?",
                    titleStyle: const TextStyle(fontWeight: FontWeight.w900, color: EduTheme.textDark),
                    middleText: "Kamu yakin ingin keluar sekarang?",
                    middleTextStyle: const TextStyle(color: EduTheme.textMedium),
                    backgroundColor: Colors.white,
                    radius: 24,
                    textConfirm: "Ya, Keluar",
                    textCancel: "Main Lagi!",
                    confirmTextColor: Colors.white,
                    cancelTextColor: EduTheme.textDark,
                    buttonColor: EduTheme.red,
                    onConfirm: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();
                      Get.offAllNamed('/login');
                    },
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: EduTheme.red,
                    borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                    boxShadow: [
                      const BoxShadow(
                        color: EduTheme.redDark,
                        offset: Offset(0, 5),
                      ),
                    ],
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.logout_rounded, color: Colors.white, size: 24),
                      SizedBox(width: 10),
                      Text(
                        'KELUAR',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ), // Closes GestureDetector
              const SizedBox(height: 16),
            ],
          ), // Closes inner Column
        ), // Closes Padding
      ],
    ), // Closes outer Column
  ), // Closes SingleChildScrollView
), // Closes SafeArea
    ); // Closes Scaffold
  }

  Widget _buildProfileHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: EduTheme.primary,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: EduTheme.primary.withOpacity(0.4),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 36,
                  backgroundColor: EduTheme.orange,
                  child: Obx(() => Text(controller.userAvatar.value, style: const TextStyle(fontSize: 40))),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: EduTheme.gold,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: EduTheme.goldDark,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Text(
                    'LEVEL 5',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 12,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Obx(() => Text(
            controller.userName.value,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          )),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Obx(() => Text(
              controller.userEmail.value,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStatCard({
    required IconData icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(EduTheme.radiusMd),
        border: Border.all(color: EduTheme.border, width: 2),
        boxShadow: EduTheme.softShadow(),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: EduTheme.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGridMenuButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(EduTheme.radiusMd),
          border: Border.all(color: EduTheme.border, width: 2),
          boxShadow: EduTheme.softShadow(),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: EduTheme.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

}