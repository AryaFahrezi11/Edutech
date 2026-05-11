import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // SafeArea agar tidak nabrak notch/kamera depan
      body: SafeArea(
        child: Column(
          children: [
            // 1. Header (Profil & Notifikasi)
            _buildHeader(),
            
            // Garis pembatas biru tipis di bawah header
            Container(height: 1, color: Colors.blue.withOpacity(0.2)),

            // 2. Konten Utama (Bisa discroll)
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _buildGiftCard(),
                    const SizedBox(height: 20),
                    _buildRankingCard(),
                    const SizedBox(height: 20),
                    _buildMenuGrid(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      // 3. Bottom Navigation
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  // --- WIDGET HEADER ---
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      child: Row(
        children: [
          // Foto Profil
          CircleAvatar(
            radius: 25,
            backgroundColor: Colors.blue[100],
            child: Image.network('https://api.dicebear.com/7.x/avataaars/png?seed=Amrull', width: 40),
          ),
          const SizedBox(width: 15),
          // Teks Nama & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Edutech",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF1E52D0)),
                ),
                Text(
                  "Halo! Yuk Belajar!",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.blue[800]),
                ),
              ],
            ),
          ),
          // Tombol Notifikasi
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue.withOpacity(0.2), width: 1.5),
            ),
            child: const Icon(Icons.notifications_outlined, color: Colors.blue),
          )
        ],
      ),
    );
  }

  // --- WIDGET GIFT CARD ---
  Widget _buildGiftCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(color: Colors.blue.withOpacity(0.05), blurRadius: 20, spreadRadius: 5, offset: const Offset(0, 10))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.card_giftcard, color: Color(0xFFFFC107), size: 28),
              const SizedBox(width: 10),
              const Text("Hadiah Hari Ini", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: Colors.black87)),
              const Spacer(),
              Row(children: List.generate(3, (index) => const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 20))),
            ],
          ),
          const SizedBox(height: 15),
          // Progress Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: 0.66,
              backgroundColor: Colors.grey[200],
              color: const Color(0xFF4CAF50),
              minHeight: 12,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("2 dari 3 tugas\nselesai!", style: TextStyle(color: Colors.black54, height: 1.5, fontWeight: FontWeight.w500)),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0056D2), // Biru gelap
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  elevation: 0,
                ),
                child: Column(
                  children: const [
                    Text("Lihat Ranking", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 16),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  // --- WIDGET RANKING CARD ---
  Widget _buildRankingCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      decoration: BoxDecoration(
        color: const Color(0xFFFFD54F), // Kuning
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.orange.withOpacity(0.2), blurRadius: 10, offset: const Offset(0, 5))
        ]
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15)),
            child: const Icon(Icons.emoji_events, color: Color(0xFF795548), size: 30),
          ),
          const SizedBox(width: 15),
          const Text("Papan Peringkat", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF5D4037))),
          const Spacer(),
          const Icon(Icons.arrow_forward_ios, color: Color(0xFF5D4037), size: 18),
        ],
      ),
    );
  }

  // --- WIDGET GRID MENU (4 Kotak) ---
  Widget _buildMenuGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      shrinkWrap: true, // Penting agar bisa di dalam SingleChildScrollView
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 0.75, // Mengatur agar kotaknya memanjang ke bawah (potrait)
      children: [
        _buildMenuCardItem(
          bgColor: const Color(0xFFFFE082), // Kuning muda
          iconBgColor: const Color(0xFFFFCA28),
          title: "Latihan\nMengeja",
          subtitle: "Mengeja itu\nseru!",
          iconText: "ABC",
          textColor: const Color(0xFF5D4037),
          onTap: () => Get.toNamed('/spelling'),
        ),
        _buildMenuCardItem(
          bgColor: const Color(0xFFFFCDD2), // Merah muda
          iconBgColor: const Color(0xFFD32F2F),
          title: "Ujian\nMengeja",
          subtitle: "Tebak\nsuaranya!",
          iconData: Icons.mic_none,
          textColor: const Color(0xFFB71C1C),
          onTap: () {}, // Tambahkan fungsi onTap jika ingin ada aksi saat diklik
        ),
        _buildMenuCardItem(
          bgColor: const Color(0xFFE3F2FD), // Biru muda
          iconBgColor: const Color(0xFF1976D2),
          title: "Latihan\nMenulis",
          subtitle: "Yuk nulis!",
          iconData: Icons.edit,
          textColor: const Color(0xFF0D47A1),
          onTap: () => Get.toNamed('/writing'),
        ),
        _buildMenuCardItem(
          bgColor: const Color(0xFFC8E6C9), // Hijau muda
          iconBgColor: const Color(0xFF388E3C),
          title: "Ujian Menulis",
          subtitle: "Uji\nkemampuanmu!",
          iconData: Icons.insert_drive_file_outlined,
          textColor: const Color(0xFF1B5E20),
          onTap: () {}, // Tambahkan fungsi onTap jika ingin ada aksi saat diklik
        ),
      ],
    );
  }

  // Komponen Item untuk Grid
  // Komponen Item untuk Grid
  Widget _buildMenuCardItem({
    required Color bgColor,
    required Color iconBgColor,
    required String title,
    required String subtitle,
    required Color textColor,
    IconData? iconData,
    String? iconText,
    required VoidCallback onTap, // <--- 1. Tambahkan parameter ini
  }) {
    return GestureDetector( // <--- 2. Bungkus Container dengan GestureDetector
      onTap: onTap, // <--- 3. Panggil fungsi onTap di sini
      child: Container(
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.black.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(color: bgColor.withOpacity(0.5), blurRadius: 10, offset: const Offset(0, 5))
          ]
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              decoration: BoxDecoration(
                color: iconBgColor,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 5, offset: const Offset(0, 3))
                ]
              ),
              child: Center(
                child: iconData != null 
                    ? Icon(iconData, color: Colors.white, size: 30)
                    : Text(iconText!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
              ),
            ),
            const SizedBox(height: 15),
            Text(title, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: textColor)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: TextStyle(fontSize: 12, color: textColor.withOpacity(0.8))),
          ],
        ),
      ),
    );
  }

  // --- CUSTOM BOTTOM NAVIGATION BAR ---
  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.blue.withOpacity(0.2), width: 2)),
      ),
      child: Obx(() => BottomNavigationBar(
        currentIndex: controller.tabIndex.value,
        onTap: controller.changeTabIndex,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.transparent,
        elevation: 0,
        selectedItemColor: Colors.blue[700],
        unselectedItemColor: Colors.grey[400],
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
        items: [
          BottomNavigationBarItem(
            icon: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: controller.tabIndex.value == 0 ? Colors.blue[100] : Colors.transparent, borderRadius: BorderRadius.circular(10)),
              child: Icon(Icons.home, color: controller.tabIndex.value == 0 ? Colors.blue[700] : Colors.grey[400]),
            ),
            label: 'HOME',
          ),
          const BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'BELAJAR'),
          const BottomNavigationBarItem(icon: Icon(Icons.quiz_outlined), label: 'UJIAN'),
          const BottomNavigationBarItem(icon: Icon(Icons.emoji_events_outlined), label: 'RANKING'),
          const BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'PROFILE'),
        ],
      )),
    );
  }
}