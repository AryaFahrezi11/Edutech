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
              Row(
                children: [
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '⭐',
                      value: '1.240',
                      label: 'Bintang',
                      color: EduTheme.gold,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '🔥',
                      value: '7 Hari',
                      label: 'Beruntun',
                      color: EduTheme.orange,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildQuickStatCard(
                      emoji: '💎',
                      value: '42',
                      label: 'Misi',
                      color: EduTheme.blue,
                    ),
                  ),
                ],
              ),

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
                onTap: () {},
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

              const SizedBox(height: 10),
              
              // ================= TIMELINE JEJAK PETUALANGAN =================
              _buildActivityLogsTimeline(),

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
                child: const CircleAvatar(
                  radius: 42,
                  backgroundColor: Color(0xFFFFD166),
                  child: Text("🧒", style: TextStyle(fontSize: 48)),
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
          const Text(
            'Gilang',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Text(
              'Si Petualang Hebat! 🚀',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 13,
              ),
            ),
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

  Widget _buildActivityLogsTimeline() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Row(
          children: [
            Text('🕵️', style: TextStyle(fontSize: 22)),
            SizedBox(width: 8),
            Text(
              'Jejak Petualangan',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w900,
                color: EduTheme.textDark,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Obx(() {
          final logService = Get.find<LogService>();
          if (logService.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (logService.logs.isEmpty) {
            return Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(EduTheme.radiusMd),
                border: Border.all(color: EduTheme.border, width: 2),
              ),
              child: const Center(
                child: Text(
                  "Belum ada petualangan.\nAyo mulai main!",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: EduTheme.textMedium, fontWeight: FontWeight.bold),
                ),
              ),
            );
          }

          return ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: logService.logs.length,
            itemBuilder: (context, index) {
              final log = logService.logs[index];
              final isLast = index == logService.logs.length - 1;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Timeline Line & Dot
                  Column(
                    children: [
                      Container(
                        width: 16,
                        height: 16,
                        decoration: BoxDecoration(
                          color: EduTheme.purple,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
                        ),
                      ),
                      if (!isLast)
                        Container(
                          width: 4,
                          height: 60,
                          color: EduTheme.purple.withOpacity(0.3),
                        ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  // Content Card
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(EduTheme.radiusMd),
                        border: Border.all(color: EduTheme.border, width: 1.5),
                        boxShadow: const [BoxShadow(color: Color(0x0A000000), offset: Offset(0, 2), blurRadius: 4)],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  log.action,
                                  style: const TextStyle(fontWeight: FontWeight.w900, color: EduTheme.textDark, fontSize: 14),
                                ),
                              ),
                              Text(
                                "+${log.pointsEarned} XP",
                                style: const TextStyle(fontWeight: FontWeight.w900, color: EduTheme.gold, fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            log.description,
                            style: const TextStyle(fontSize: 12, color: EduTheme.textMedium, fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            log.timestamp,
                            style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              );
            },
          );
        }),
      ],
    );
  }
}