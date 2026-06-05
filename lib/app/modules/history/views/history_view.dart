import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A5041),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Riwayat Aktivitas',
          style: TextStyle(color: Colors.white),
        ),
      ),

      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        ),

        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Waktu pemakaian perangkat',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    SizedBox(width: 10),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),

              const SizedBox(height: 25),

              Obx(
                () => Text(
                  controller.formatDuration(controller.totalPlayTime.value),
                  style: const TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ),

              const Text(
                'Hari ini',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),

              const SizedBox(height: 20),

              SizedBox(
                height: 220,
                child: Obx(
                  () => BarChart(
                    BarChartData(
                      maxY: 1500,
                      borderData: FlBorderData(show: false),

                      gridData: FlGridData(show: true),

                      titlesData: FlTitlesData(
                        topTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        rightTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),

                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 30,
                          ),
                        ),

                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final days = [
                                'Min',
                                'Sen',
                                'Sel',
                                'Rab',
                                'Kam',
                                'Jum',
                                'Sab',
                              ];

                              if (value.toInt() >= days.length) {
                                return const SizedBox();
                              }

                              return Text(days[value.toInt()]);
                            },
                          ),
                        ),
                      ),

                      barGroups: controller
                          .getWeeklyChartData()
                          .asMap()
                          .entries
                          .map(
                            (entry) => BarChartGroupData(
                              x: entry.key,
                              barRods: [
                                BarChartRodData(
                                  toY: entry.value['durasi'],
                                  width: 24,
                                  borderRadius: BorderRadius.circular(4),
                                  color: const Color(0xFF0C8A7B),
                                ),
                              ],
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 25),

              const Text('Sel, 2 Jun', style: TextStyle(fontSize: 26)),

              const SizedBox(height: 20),

              Obx(
                () => ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: controller.getCategorySummary().length,
                  itemBuilder: (context, index) {
                    final item = controller.getCategorySummary()[index];

                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(vertical: 10),

                      leading: CircleAvatar(
                        radius: 24,
                        backgroundColor: Colors.grey.shade200,
                        child: const Icon(Icons.sports_esports),
                      ),

                      title: Text(
                        item['kategori'],
                        style: const TextStyle(fontSize: 18),
                      ),

                      subtitle: Text(
                        controller.formatDuration(item['durasi']),
                        style: const TextStyle(fontSize: 16),
                      ),

                      trailing: const Icon(
                        Icons.hourglass_empty,
                        color: Colors.grey,
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
