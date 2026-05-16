import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';
import '../controllers/letter_selection_controller.dart';

class LetterSelectionView extends GetView<LetterSelectionController> {
  const LetterSelectionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4FF),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(20),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 kotak per baris
                  crossAxisSpacing: 14,
                  mainAxisSpacing: 14,
                  childAspectRatio: 1.0,
                ),
                itemCount: controller.letters.length,
                itemBuilder: (context, index) {
                  final letter = controller.letters[index];
                  
                  // Palet warna yang ceria untuk anak-anak
                  final colors = [
                    const Color(0xFFFF6B6B), // Merah Semangka
                    const Color(0xFF4ECDC4), // Tosca
                    const Color(0xFFFFD166), // Kuning Mangga
                    const Color(0xFF9D4EDD), // Ungu Anggur
                    const Color(0xFFFF9F1C), // Oranye Jeruk
                    const Color(0xFF11998E), // Hijau Daun
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
                    child: _LetterCard(
                      letter: letter,
                      bgColor: bgColor,
                      onTap: () {
                        // Pergi ke halaman Writing Practice dan bawa data huruf yang dipilih
                        Get.toNamed(Routes.WRITING, arguments: {'letter': letter});
                      },
                    ),
                  );
                },
              ),
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
          colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(36)),
        boxShadow: [
          BoxShadow(color: Color(0x446C63FF), blurRadius: 15, offset: Offset(0, 8))
        ]
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 22),
                onPressed: () => Get.back(),
              ),
              const Expanded(
                child: Text(
                  "Pilih Huruf 🔠",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                const Text("🦁", style: TextStyle(fontSize: 38)),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Huruf apa yang ingin dipelajari?",
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Colors.white),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "Pilih salah satu kotak di bawah ya!",
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── WIDGET CARD KOTAK-KOTAK ────────────────────────────────────────────────
class _LetterCard extends StatefulWidget {
  final String letter;
  final Color bgColor;
  final VoidCallback onTap;

  const _LetterCard({
    required this.letter,
    required this.bgColor,
    required this.onTap,
  });

  @override
  State<_LetterCard> createState() => _LetterCardState();
}

class _LetterCardState extends State<_LetterCard> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 120), lowerBound: 0, upperBound: 0.15);
    _scale = Tween<double>(begin: 1.0, end: 0.85).animate(_ctrl);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap(); // Panggil fungsi pindah navigasi
      },
      onTapCancel: () => _ctrl.reverse(),
      child: AnimatedBuilder(
        animation: _scale,
        builder: (context, child) => Transform.scale(scale: _scale.value, child: child),
        child: Container(
          decoration: BoxDecoration(
            color: widget.bgColor,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: widget.bgColor.withOpacity(0.5),
                blurRadius: 10,
                offset: const Offset(0, 6),
              ),
            ],
            // Border tebal untuk kesan kartun/fun
            border: Border.all(color: Colors.white.withOpacity(0.6), width: 3),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Efek Cahaya / Shine di pojok
              Positioned(
                top: 4,
                right: 4,
                child: Icon(Icons.star_rounded, color: Colors.white.withOpacity(0.4), size: 14),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: CircleAvatar(backgroundColor: Colors.white.withOpacity(0.2), radius: 6),
              ),
              // Huruf Besar
              Text(
                widget.letter,
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  shadows: [
                    Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 2))
                  ]
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
