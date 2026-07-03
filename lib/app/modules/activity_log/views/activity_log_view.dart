import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/edu_theme.dart';
import '../../../services/log_service.dart';

class ActivityLogView extends StatelessWidget {
  const ActivityLogView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Refresh log saat halaman dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Get.find<LogService>().fetchLogs();
    });

    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: const Text('📜 Riwayat Petualangan'),
        centerTitle: true,
        backgroundColor: EduTheme.primary,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: "Perbarui Data",
            onPressed: () {
              Get.find<LogService>().fetchLogs();
            },
          ),
        ],
      ),
      body: Obx(() {
        final logService = Get.find<LogService>();
        if (logService.isLoading.value && logService.logs.isEmpty) {
          return const Center(child: CircularProgressIndicator(color: EduTheme.primary));
        }

        if (logService.logs.isEmpty) {
          return Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(EduTheme.radiusLg),
                border: Border.all(color: EduTheme.border, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4))],
              ),
              child: const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("📭", style: TextStyle(fontSize: 64)),
                  SizedBox(height: 16),
                  Text(
                    "Belum ada petualangan.\nAyo mulai main!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: EduTheme.textDark,
                      fontWeight: FontWeight.w900,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // Group logs by date
        final groupedLogs = <String, List<ActivityLogModel>>{};
        for (var log in logService.logs) {
          final datePart = log.timestamp.split(' ').first;
          if (groupedLogs[datePart] == null) {
            groupedLogs[datePart] = [];
          }
          groupedLogs[datePart]!.add(log);
        }

        final List<String> dates = groupedLogs.keys.toList();

        String formatDate(String dateStr) {
          try {
            if (!dateStr.contains('-')) return dateStr;
            final parts = dateStr.split('-');
            final year = parts[0];
            final month = int.parse(parts[1]);
            final day = int.parse(parts[2]);
            const months = ['Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
            
            // Cek hari ini
            final now = DateTime.now();
            if (now.year.toString() == year && now.month == month && now.day == day) {
              return "Hari Ini";
            }
            
            return '$day ${months[month - 1]} $year';
          } catch (e) {
            return dateStr;
          }
        }

        return ListView.builder(
          padding: const EdgeInsets.all(20),
          itemCount: dates.length,
          itemBuilder: (context, index) {
            final date = dates[index];
            final logsForDate = groupedLogs[date]!;
            final isFirst = index == 0; // Otomatis expand untuk tanggal paling atas

            return Theme(
              data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
              child: ExpansionTile(
                initiallyExpanded: isFirst,
                tilePadding: EdgeInsets.zero,
                iconColor: EduTheme.purple,
                collapsedIconColor: Colors.grey,
                title: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: EduTheme.purple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: EduTheme.purple.withOpacity(0.3)),
                      ),
                      child: Text(
                        formatDate(date),
                        style: const TextStyle(
                          color: EduTheme.purple,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Expanded(child: Divider(color: EduTheme.border, thickness: 1.5, indent: 10)),
                  ],
                ),
                children: logsForDate.map((log) {
                  final timePart = log.timestamp.split(' ').length > 1 ? log.timestamp.split(' ')[1] : '';
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(EduTheme.radiusMd),
                      border: Border.all(color: EduTheme.border, width: 2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFE5E5E5),
                          offset: Offset(0, 3),
                        ),
                      ],
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
                                style: const TextStyle(
                                  fontWeight: FontWeight.w900,
                                  fontSize: 16,
                                  color: EduTheme.textDark,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: EduTheme.gold,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text('⭐', style: TextStyle(fontSize: 12)),
                                  const SizedBox(width: 4),
                                  Text(
                                    '+${log.pointsEarned}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w900,
                                      fontSize: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          log.description,
                          style: const TextStyle(
                            color: EduTheme.textMedium,
                            fontWeight: FontWeight.w700,
                            height: 1.4,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.access_time_filled_rounded, size: 14, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(
                              timePart,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      }),
    );
  }
}
