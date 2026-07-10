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
            // --- HEADER / AI EXECUTIVE SUMMARY ---
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF48C6EF)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(32),
                boxShadow: [
                  BoxShadow(color: const Color(0xFF6C63FF).withOpacity(0.3), blurRadius: 20, offset: const Offset(0, 10))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text("🤖", style: TextStyle(fontSize: 32)),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          "Pesan AI untuk Ayah/Bunda",
                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Obx(() => Text(
                    controller.aiRecommendation.value,
                    style: const TextStyle(color: Colors.white, fontSize: 15, height: 1.5, fontWeight: FontWeight.w600),
                  )),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // --- STRENGTHS (KELEBIHAN) ---
            const Text("🌟 Kelebihan Ananda", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
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

            const SizedBox(height: 32),

            // --- WEAKNESSES (AREA PERBAIKAN) ---
            const Text("⚠️ Area Perbaikan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
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

            const SizedBox(height: 32),

            // --- LINE CHART (TREN AKURASI BIG DATA) ---
            const Text("📈 Tren Akurasi Belajar", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
            const SizedBox(height: 8),
            const Text("Melihat histori pergerakan nilai Ananda dari tiap sesi latihan terakhir yang diselesaikan.", style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4)),
            const SizedBox(height: 16),
            Obx(() {
              if (controller.accuracyTrend.isEmpty) {
                return _buildEmptyState("Belum cukup data untuk melihat tren. Ayo kerjakan Ujian Menulis!");
              }

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(32),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
                ),
                child: SizedBox(
                  height: 200,
                  child: LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 20,
                        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.1), strokeWidth: 1),
                      ),
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 26,
                            interval: 1,
                            getTitlesWidget: (value, meta) {
                              return Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text('Latihan ${value.toInt() + 1}', style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold)),
                              );
                            },
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            interval: 20,
                            reservedSize: 28,
                            getTitlesWidget: (value, meta) {
                              return Text('${value.toInt()}', style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold));
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
                          color: const Color(0xFF1CB0F6),
                          barWidth: 4,
                          isStrokeCapRound: true,
                          dotData: FlDotData(
                            show: true,
                            getDotPainter: (spot, percent, barData, index) => FlDotCirclePainter(
                              radius: 4,
                              color: Colors.white,
                              strokeWidth: 2,
                              strokeColor: const Color(0xFF1CB0F6),
                            ),
                          ),
                          belowBarData: BarAreaData(
                            show: true,
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFF1CB0F6).withOpacity(0.3),
                                const Color(0xFF1CB0F6).withOpacity(0.0),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                          ),
                        ),
                      ],
                      lineTouchData: LineTouchData(
                        touchTooltipData: LineTouchTooltipData(
                          // tooltipBgColor: Colors.blueGrey,
                          getTooltipItems: (touchedSpots) {
                            return touchedSpots.map((spot) {
                              return LineTooltipItem(
                                '${spot.y.toInt()}%',
                                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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

            const SizedBox(height: 32),
            
            // --- RADAR CHART (BIG DATA SKILL) ---
            const Text("📊 Keseimbangan Keterampilan", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF2D3142))),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(32),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10))],
              ),
              child: SizedBox(
                height: 250,
                child: Obx(() => RadarChart(
                  RadarChartData(
                    dataSets: [
                      RadarDataSet(
                        fillColor: const Color(0xFF1CB0F6).withOpacity(0.3),
                        borderColor: const Color(0xFF1CB0F6),
                        entryRadius: 4,
                        dataEntries: controller.skillData.map((e) => RadarEntry(value: e)).toList(),
                      ),
                    ],
                    radarShape: RadarShape.polygon,
                    tickCount: 4,
                    ticksTextStyle: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.bold),
                    getTitle: (index, angle) => RadarChartTitle(
                      text: controller.categories[index],
                      angle: angle,
                    ),
                  ),
                )),
              ),
            ),
            
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildFeedbackCard({required String text, required IconData icon, required Color iconColor, required Color bgColor}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
        border: Border.all(color: bgColor, width: 2),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 2),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF4A4A4A),
                  height: 1.4,
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
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 2),
      ),
      child: Center(
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.w600, fontSize: 14),
        ),
      ),
    );
  }
}

