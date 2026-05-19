import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileView extends GetView {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F6FA),

      // Bottom navigation removed because it is handled by HomeView's IndexedStack

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.offNamed('/home'),
                    child: const Icon(Icons.arrow_back_ios, size: 18),
                  ),

                  const Expanded(
                    child: Center(
                      child: Text(
                        'Profil Saya',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Color(0xff1565D8),
                        ),
                      ),
                    ),
                  ),

                  const Icon(Icons.settings_outlined, color: Color(0xff1565D8)),
                ],
              ),

              const SizedBox(height: 20),

              // ================= PROFILE =================
              Center(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xffF5C542),
                          width: 4,
                        ),
                      ),
                      child: const CircleAvatar(
                        radius: 42,
                        backgroundImage: AssetImage('assets/images/anak.png'),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xffF5C542),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: const Text(
                        'LVL 5',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    const Text(
                      'Adit Pratama',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),

                    const SizedBox(height: 4),

                    const Text(
                      'Kamu Hebat! 😊',
                      style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= INFO CARD =================
              Row(
                children: [
                  Expanded(
                    child: _infoCard(
                      icon: Icons.star_outline,
                      value: '1.240',
                      label: 'TOTAL BINTANG',
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: _infoCard(
                      icon: Icons.menu_book_outlined,
                      value: '24',
                      label: 'PELAJARAN',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 22),

              // ================= KEMAMPUAN =================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Kemampuan Kamu',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),

                    const SizedBox(height: 18),

                    const Text(
                      'Menulis',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: 0.85,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.green,
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      'Mengeja',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 8),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: LinearProgressIndicator(
                        value: 0.60,
                        minHeight: 12,
                        backgroundColor: Colors.grey.shade200,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= BADGE =================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'Koleksi Badge',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),

                  Text(
                    'Lihat Semua',
                    style: TextStyle(
                      color: Color(0xff1565D8),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: _badgeCard(
                      color: const Color(0xffFFE082),
                      icon: Icons.edit,
                      title: 'JAGO MENULIS',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _badgeCard(
                      color: const Color(0xffA5D6A7),
                      icon: Icons.spellcheck,
                      title: 'AHLI MENGEJA',
                    ),
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: _badgeCard(
                      color: Colors.grey.shade300,
                      icon: Icons.emoji_events_outlined,
                      title: 'BINTANG BELAJAR',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // ================= AKTIVITAS =================
              const Text(
                'Aktivitas Terakhir',
                style: TextStyle(fontWeight: FontWeight.w700),
              ),

              const SizedBox(height: 12),

              _activityTile(
                title: 'Latihan Menulis selesai',
                subtitle: '2 jam yang lalu',
                point: '+10 ⭐',
              ),

              const SizedBox(height: 10),

              _activityTile(
                title: 'Naik ke Level 5!',
                subtitle: 'Kemarin',
                point: '✓',
              ),

              const SizedBox(height: 24),

              // ================= MOTIVATION =================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 28,
                      backgroundImage: AssetImage('assets/images/anak.png'),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(color: Colors.black87, fontSize: 13),
                          children: [
                            TextSpan(
                              text: 'Terus semangat belajar ya Adit!\n',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: 'Kamu pasti bisa 🚀'),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // ================= BUTTON =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.edit),
                  label: const Text('Edit Profil'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff1565D8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 14),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.settings),
                      label: const Text('Pengaturan'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.help_outline),
                      label: const Text('Bantuan'),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 14),

              // ================= LOGOUT =================
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Navigate to Login page and remove all previous routes
                    Get.offAllNamed('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar (Logout)'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffEF4444), // Red color for logout
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(22),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String value,
    required String label,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xff1565D8)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
              color: Colors.black54,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _badgeCard({
    required Color color,
    required IconData icon,
    required String title,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Icon(icon, size: 28),
          const SizedBox(height: 10),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }

  Widget _activityTile({
    required String title,
    required String subtitle,
    required String point,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.task_alt, color: Color(0xff1565D8)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.black54, fontSize: 12),
                ),
              ],
            ),
          ),
          Text(
            point,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
