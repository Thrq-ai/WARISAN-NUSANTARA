import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/statistik_controller.dart';

class StatistikView extends GetView<StatistikController> {
  const StatistikView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF6A5041),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.offNamed('/home'),
        ),
        title: const Text(
          'Statisktik',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w400,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Obx(() {
                if (controller.isLoadinhg.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: Color(0xFF6A5041)),
                  );
                }
                return SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(height: 34,),
                      _buildCircles(),
                      SizedBox(height: 34,),
                      const Divider(height: 32),
                      _buildStatList(),
                    ],
                  ),
                );
              }),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildCircles() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _circleItem(
          value: '${controller.totalQuiz.value}',
          label: 'Quiz',
          sub: 'Selesai',
          color: const Color(0xFF6A5041),
        ),
        _circleItem(
          value: '${controller.akurasi.toStringAsFixed(0)}%',
          label: 'Akurasi',
          sub: 'Ketepatan',
          color: const Color(0xFFE07B39),
        ),
        _circleItem(
          value: '${controller.totalBenar.value}',
          label: 'Benar',
          sub: 'dari ${controller.totalSoal.value} soal',
          color: const Color(0xFF1D9E75),
        ),
      ],
    );
  }

  Widget _circleItem({
    required String value,
    required String label,
    required String sub,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: color, width: 2.5),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
              Text(
                label,
                style: TextStyle(
                  fontSize: 9,
                  color: color,
                  fontFamily: 'Poppins',
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Text(
          sub,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }

  Widget _buildStatList() {
    return Column(
      children: [
        _statItem(
          icon: Icons.emoji_events,
          iconColor: const Color(0xFF854F0B),
          iconBg: const Color(0xFFFAEEDA),
          label: 'Total Poin',
          value: '${controller.totalPoin.value}',
        ),
        _statItem(
          icon: Icons.local_fire_department,
          iconColor: const Color(0xFF993C1D),
          iconBg: const Color(0xFFFAECE7),
          label: 'Streak Harian',
          value: '${controller.currentStreak.value} hari',
        ),
        _statItem(
          icon: Icons.military_tech,
          iconColor: const Color(0xFF3C3489),
          iconBg: const Color(0xFFEEEDFE),
          label: 'Rekor Streak',
          value: '${controller.longestStreak.value} hari',
        ),
        _statItem(
          icon: Icons.bolt,
          iconColor: const Color(0xFF3B6D11),
          iconBg: const Color(0xFFEAF3DE),
          label: 'Max Streak Jawaban',
          value: '${controller.maxStreakJawaban.value}x berturutan',
        ),
        _statItem(
          icon: Icons.timer,
          iconColor: const Color(0xFF185FA5),
          iconBg: const Color(0xFFE6F1FB),
          label: 'Rata-rata Waktu',
          value: '${controller.rataWaktu.toStringAsFixed(1)} detik / soal',
        ),
        _statItem(
          icon: Icons.person,
          iconColor: const Color(0xFF0F6E56),
          iconBg: const Color(0xFFE1F5EE),
          label: 'Rank',
          value: '#${controller.userRank.value}',
          isLast: true,
        ),
      ],
    );
  }

  Widget _statItem({
    required IconData icon,
    required Color iconColor,
    required Color iconBg,
    required String label,
    required String value,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 11),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: iconBg,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: iconColor, size: 18),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.grey,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1a1a1a),
                      fontFamily: 'Poppins',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(height: 0, thickness: 0.5, color: Color(0xFFF0F0F0)),
      ],
    );
  }
}
