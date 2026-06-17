import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/raport_controller.dart';

import 'package:fl_chart/fl_chart.dart';

class RaportView extends GetView<RaportController> {
  const RaportView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text("Rapor Hebatku 📋", style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white)),
        backgroundColor: const Color(0xFF1CB0F6),
        centerTitle: true,
        elevation: 0,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(bottom: Radius.circular(30))),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Kekuatan Supermu 💪", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
            const SizedBox(height: 16),
            
            // --- RADAR CHART (BIG DATA SKILL) ---
            _buildChartCard(
              title: "Keseimbangan Skill",
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
                    ticksTextStyle: const TextStyle(fontSize: 8, color: Colors.grey),
                    getTitle: (index, angle) => RadarChartTitle(
                      text: controller.categories[index],
                      angle: angle,
                    ),
                  ),
                )),
              ),
            ),

            const SizedBox(height: 24),
            const Text("Semangat Mingguan 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Color(0xFF3C3C3C))),
            const SizedBox(height: 16),

            // --- BAR CHART (PROGRESS TREND) ---
            _buildChartCard(
              title: "XP yang Kamu Dapat",
              child: SizedBox(
                height: 200,
                child: Obx(() => BarChart(
                  BarChartData(
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(show: false),
                    barGroups: controller.weeklyXP.asMap().entries.map((e) {
                      return BarChartGroupData(
                        x: e.key,
                        barRods: [
                          BarChartRodData(
                            toY: e.value,
                            color: const Color(0xFF1CB0F6),
                            width: 18,
                            borderRadius: BorderRadius.circular(6),
                          )
                        ],
                      );
                    }).toList(),
                  ),
                )),
              ),
            ),

            const SizedBox(height: 24),

            // --- ANALYSIS CARD (AI INSIGHT) ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFF1CB0F6), Color(0xFF1899D6)]),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Text("🤖", style: TextStyle(fontSize: 40)),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      controller.analysisMessage,
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartCard({required String title, required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 20),
          child,
        ],
      ),
    );
  }
}
