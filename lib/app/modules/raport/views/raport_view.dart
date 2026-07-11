import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/raport_controller.dart';
import 'package:fl_chart/fl_chart.dart';

class RaportView extends GetView<RaportController> {
  const RaportView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F7FC), // Soft modern background
      appBar: AppBar(
        title: const Text("Laporan Belajar Anak 📊", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFF1CB0F6),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAISummary(),
            const SizedBox(height: 40),
            _buildSkillProgressBars(),
            const SizedBox(height: 40),
            _buildStrengths(),
            const SizedBox(height: 32),
            _buildWeaknesses(),
            const SizedBox(height: 40),
            _buildLearningTrend(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildAISummary() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(color: Colors.blue.withValues(alpha: 0.05), blurRadius: 24, offset: const Offset(0, 12))
        ],
        border: Border.all(color: const Color(0xFFE5F1FB), width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)]),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(color: const Color(0xFF6C63FF).withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 4))
                  ],
                ),
                child: const Text("🤖", style: TextStyle(fontSize: 32)),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Text(
                  "Catatan Cerdas AI",
                  style: TextStyle(color: Color(0xFF2D3142), fontSize: 20, fontWeight: FontWeight.w900),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F7FC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Obx(() => Text(
              controller.aiRecommendation.value,
              style: const TextStyle(color: Color(0xFF4A4A4A), fontSize: 15, height: 1.6, fontWeight: FontWeight.w600),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildSkillProgressBars() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📈 Level Keterampilan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
        const SizedBox(height: 8),
        const Text("Rata-rata akurasi dari semua latihan yang dikerjakan", style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))
            ],
          ),
          child: Obx(() {
            if (controller.skillData.isEmpty || controller.skillData.length < 4) {
              return _buildEmptyState("Belum cukup data untuk dihitung.");
            }
            return Column(
              children: [
                _buildProgressBar("📝 Menulis", controller.skillData[0], const Color(0xFFFF9600), const Color(0xFFFFC107)),
                const SizedBox(height: 20),
                _buildProgressBar("🔤 Mengeja", controller.skillData[1], const Color(0xFF1CB0F6), const Color(0xFF48C6EF)),
                const SizedBox(height: 20),
                _buildProgressBar("🔍 Observasi", controller.skillData[2], const Color(0xFF58CC02), const Color(0xFF89E219)),
                const SizedBox(height: 20),
                _buildProgressBar("⚔️ Duel", controller.skillData[3], const Color(0xFF6C63FF), const Color(0xFF9D94FF)),
              ],
            );
          }),
        ),
      ],
    );
  }

  Widget _buildProgressBar(String title, double value, Color color1, Color color2) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF4A4A4A))),
            Text("${value.toInt()}%", style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: color1)),
          ],
        ),
        const SizedBox(height: 10),
        LayoutBuilder(
          builder: (context, constraints) {
            return Container(
              height: 18,
              width: constraints.maxWidth,
              decoration: BoxDecoration(
                color: const Color(0xFFF0F4F8),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Stack(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 1200),
                    curve: Curves.easeOutCubic,
                    width: constraints.maxWidth * (value / 100),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [color1, color2]),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [BoxShadow(color: color1.withValues(alpha: 0.4), blurRadius: 6, offset: const Offset(0, 2))],
                    ),
                  ),
                ],
              ),
            );
          }
        ),
      ],
    );
  }

  Widget _buildStrengths() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("🌟 Kelebihan Ananda", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.strengths.isEmpty) {
            return _buildEmptyState("Belum ada data kelebihan. Ayo berlatih lebih banyak!");
          }
          return Column(
            children: controller.strengths.map((strength) => _buildFeedbackCard(
              text: strength,
              icon: Icons.check_circle_rounded,
              iconColor: const Color(0xFF58CC02),
              bgColor: const Color(0xFFE5F9E0),
            )).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildWeaknesses() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("⚠️ Area Perbaikan", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
        const SizedBox(height: 16),
        Obx(() {
          if (controller.weaknesses.isEmpty) {
            return _buildEmptyState("Hebat! Tidak ada area perbaikan kritis saat ini.");
          }
          return Column(
            children: controller.weaknesses.map((weakness) => _buildFeedbackCard(
              text: weakness,
              icon: Icons.warning_rounded,
              iconColor: const Color(0xFFFF9600),
              bgColor: const Color(0xFFFFF0D4),
            )).toList(),
          );
        }),
      ],
    );
  }

  Widget _buildLearningTrend() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("📈 Tren Belajar Terakhir", style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
        const SizedBox(height: 8),
        const Text("Melihat histori pergerakan nilai Ananda dari tiap sesi latihan terakhir.", style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
        const SizedBox(height: 24),
        Obx(() {
          if (controller.accuracyTrend.isEmpty) {
            return _buildEmptyState("Belum cukup data untuk melihat tren.");
          }

          return Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 32, right: 32, bottom: 20, left: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32),
              boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: SizedBox(
              height: 220,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: 25,
                    getDrawingHorizontalLine: (value) => FlLine(color: const Color(0xFFF0F4F8), strokeWidth: 1.5),
                  ),
                  titlesData: FlTitlesData(
                    show: true,
                    rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 30,
                        interval: 1,
                        getTitlesWidget: (value, meta) {
                          if (value % 2 != 0 && controller.accuracyTrend.length > 5) return const SizedBox(); // Reduce clutter
                          return Padding(
                            padding: const EdgeInsets.only(top: 10.0),
                            child: Text('${value.toInt() + 1}', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                          );
                        },
                      ),
                    ),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        interval: 25,
                        reservedSize: 34,
                        getTitlesWidget: (value, meta) {
                          return Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold));
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  minX: 0,
                  maxX: (controller.accuracyTrend.length - 1).toDouble(),
                  minY: 0,
                  maxY: 100,
                  lineBarsData: [
                    LineChartBarData(
                      spots: controller.accuracyTrend.asMap().entries.map((e) {
                        return FlSpot(e.key.toDouble(), e.value);
                      }).toList(),
                      isCurved: true,
                      curveSmoothness: 0.35,
                      color: const Color(0xFF1CB0F6),
                      barWidth: 5,
                      isStrokeCapRound: true,
                      dotData: FlDotData(
                        show: true,
                        getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                          radius: 5,
                          color: Colors.white,
                          strokeWidth: 3,
                          strokeColor: const Color(0xFF1CB0F6),
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            const Color(0xFF1CB0F6).withValues(alpha: 0.3),
                            const Color(0xFF1CB0F6).withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipItems: (touchedSpots) {
                        return touchedSpots.map((spot) {
                          return LineTooltipItem(
                            '${spot.y.toInt()}%',
                            const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                          );
                        }).toList();
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildFeedbackCard({required String text, required IconData icon, required Color iconColor, required Color bgColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 15,
            offset: const Offset(0, 6),
          )
        ],
        border: Border.all(color: bgColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A4A4A),
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String message) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 2, strokeAlign: BorderSide.strokeAlignOutside),
      ),
      child: Column(
        children: [
          const Icon(Icons.info_outline_rounded, color: Colors.grey, size: 32),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
