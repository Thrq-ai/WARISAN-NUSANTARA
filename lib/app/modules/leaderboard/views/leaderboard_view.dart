import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/leaderboard_controller.dart';

class LeaderboardView extends GetView<LeaderboardController> {
  const LeaderboardView({super.key});

  Widget _buildTopCard(
    double width,
    double height,
    Color color,
    String rank,
    String name,
    String score,
  ) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Column(
            children: [
              const SizedBox(height: 40),
              Text(
                name,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Icon(
                Icons.emoji_events,
                color: rank == "1" ? Colors.amber : Colors.grey[400],
                size: 30,
              ),
              Text(
                score,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ),
        Positioned(
          top: -30,
          child: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 3),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: CircleAvatar(
              radius: 35,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 28, color: Colors.grey[400]),
            ),
          ),
        ),
      ],
    );
  }


  Widget _buildRankItem(
    String rank,
    String name,
    String score, [
    bool isCurrentUser = false,
  ]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.symmetric(horizontal: 15),
      width: double.infinity,
      height: 70,
      decoration: BoxDecoration(
        color: isCurrentUser ? Color(0xFF6A5041) : Colors.grey[200], // ← tambah
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            rank,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isCurrentUser ? Colors.white : Colors.black, // ← tambah
            ),
          ),
          const SizedBox(width: 15),
          CircleAvatar(
            radius: 22,
            backgroundColor: Colors.white,
            child: Icon(Icons.person, color: Colors.grey[400]),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isCurrentUser ? Colors.white : Colors.black, // ← tambah
              ),
            ),
          ),
          Text(
            "$score Pts",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: isCurrentUser ? Colors.white : Colors.brown, // ← tambah
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(
          top: 100,
          left: 20,
          right: 20,
          bottom: 20,
        ),
        child: Column(
          children: [
            // TIGA BESAR
            Obx(() {
              final list = controller.leaderboardList;
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  list.length > 1
                      ? _buildTopCard(
                          100,
                          150,
                          Colors.blue.shade200,
                          "2",
                          list[1]['name'] ?? '-',
                          '${list[1]['points'] ?? 0}',
                        )
                      : _buildTopCard(
                          100,
                          150,
                          Colors.blue.shade200,
                          "2",
                          "-",
                          "-",
                        ),
                  list.isNotEmpty
                      ? _buildTopCard(
                          110,
                          180,
                          Colors.amber.shade200,
                          "1",
                          list[0]['name'] ?? '-',
                          '${list[0]['points'] ?? 0}',
                        )
                      : _buildTopCard(
                          110,
                          180,
                          Colors.amber.shade200,
                          "1",
                          "-",
                          "-",
                        ),
                  list.length > 2
                      ? _buildTopCard(
                          100,
                          150,
                          Colors.orange.shade200,
                          "3",
                          list[2]['name'] ?? '-',
                          '${list[2]['points'] ?? 0}',
                        )
                      : _buildTopCard(
                          100,
                          150,
                          Colors.orange.shade200,
                          "3",
                          "-",
                          "-",
                        ),
                ],
              );
            }),
            const SizedBox(height: 50),

            // JUDUL DAFTAR
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Peringkat Lainnya",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 20),

            // DAFTAR PERINGKAT BAWAH
            Obx(() {
              final list = controller.leaderboardList;
              final rest = list.skip(3).toList();

              if (rest.isEmpty) {
                return Center(
                  child: Text(
                    'Belum ada data',
                    style: TextStyle(color: Colors.grey, fontFamily: 'Poppins'),
                  ),
                );
              }

              return Column(
                children: rest.map((user) {
                  final isCurrentUser =
                      user['uid'] == controller.currentUserId.value;
                  return _buildRankItem(
                    '${user['rank']}',
                    isCurrentUser
                        ? '${user['name']} (YOU)'
                        : user['name'] ?? '-',
                    '${user['points'] ?? 0}',
                    isCurrentUser,
                  );
                }).toList(),
              );
            }),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        selectedItemColor: Color(0xFF6A5041),
        unselectedItemColor: Colors.grey,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        type: BottomNavigationBarType.fixed, 
        items: [
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8), 
              child: Icon(Icons.home),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.bar_chart),
            ),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Padding(
              padding: EdgeInsets.only(top: 8),
              child: Icon(Icons.person),
            ),
            label: '',
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Get.toNamed('/home');
          } else if (index == 2) {
            Get.toNamed('/profile');
          }
        },
      ),
    );
  }
}
