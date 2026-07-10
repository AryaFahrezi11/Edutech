import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../controllers/profile_controller.dart';
import '../../../services/log_service.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: EduTheme.bgLight,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // ================= HEADER KARTU PROFIL =================
              _buildProfileCard(),
              
              const SizedBox(height: 24),

              // ================= KARTU INFO SINGKAT =================
              Obx(() => Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '⭐',
                      value: '${controller.totalPoints}',
                      label: 'Bintang',
                      color: EduTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '🔥',
                      value: '${controller.streakDays} Hari',
                      label: 'Beruntun',
                      color: EduTheme.orange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '💎',
                      value: '${controller.totalMissions}',
                      label: 'Misi',
                      color: EduTheme.blue,
                    ),
                  ),
                ],
              )),

              const SizedBox(height: 28),

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

              _buildMenuButton(
                emoji: '🎨',
                title: 'Edit Profil',
                subtitle: 'Ganti nama atau avatarmu',
                color: EduTheme.blue,
                onTap: () {
                  Get.toNamed('/edit-profile');
                },
              ),

              _buildMenuButton(
                emoji: '🏆',
                title: 'Pencapaianku',
                subtitle: 'Lihat piala dan medali',
                color: EduTheme.gold,
                onTap: () {},
              ),

              _buildMenuButton(
                emoji: '📊',
                title: 'Rapor Belajar',
                subtitle: 'Cek perkembangan hebatmu',
                color: EduTheme.primary,
                onTap: () {
                  Get.toNamed('/raport');
                },
              ),

              _buildMenuButton(
                emoji: '📜',
                title: 'Riwayat Petualangan',
                subtitle: 'Lihat log poin dan aktivitasmu',
                color: EduTheme.purple,
                onTap: () {
                  Get.toNamed('/activity-log');
                },
              ),

              _buildMenuButton(
                emoji: '⚙️',
                title: 'Pengaturan',
                subtitle: 'Suara, musik, dan privasi',
                color: EduTheme.textLight,
                onTap: () {},
              ),

              const SizedBox(height: 20),

              // ================= TOMBOL LOGOUT =================
              GestureDetector(
                onTap: () {
                  Get.defaultDialog(
                    title: "Mau Istirahat? 😴",
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
                    onConfirm: () => Get.offAllNamed('/login'),
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
                      Text('🚪', style: TextStyle(fontSize: 20)),
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
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: EduTheme.primaryGradient,
        borderRadius: BorderRadius.circular(EduTheme.radiusLg),
        boxShadow: EduTheme.buttonShadow(EduTheme.primary),
      ),
      child: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                padding: const EdgeInsets.all(5),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 42,
                  backgroundColor: const Color(0xFFFFD166),
                  child: Obx(() => Text(controller.userAvatar.value, style: const TextStyle(fontSize: 48))),
                ),
              ),
              Positioned(
                bottom: -10,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  decoration: BoxDecoration(
                    color: EduTheme.gold,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 3),
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
          const SizedBox(height: 22),
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
    required String emoji,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(EduTheme.radiusMd),
        border: Border.all(color: EduTheme.border, width: 2),
        boxShadow: EduTheme.softShadow(),
      ),
      child: Column(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 24)),
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

  Widget _buildMenuButton({
    required String emoji,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(EduTheme.radiusMd),
            border: Border.all(color: EduTheme.border, width: 2),
            boxShadow: EduTheme.softShadow(),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Text(emoji, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        color: EduTheme.textDark,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: EduTheme.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: EduTheme.bgLight,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.arrow_forward_ios_rounded, size: 14, color: color),
              ),
            ],
          ),
        ),
      ),
    );
  }

}