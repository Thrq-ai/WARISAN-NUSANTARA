import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A5041),
      body: Column(
        children: [
          Stack(
            children: [
              Positioned.fill(
                top: 0,
            left: 0,
            right: 0,
                child: Center(
                  child: Image.asset(
                    'assets/images/background.png',
                    fit: BoxFit.cover,
                    width: 450,
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 120,
                ),
                color: Color(0xFF6A5041).withValues(alpha: 0.85),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Obx(() {
                          if (controller.userPhotoBytes.value != null) {
                            return CircleAvatar(
                              radius: 25,
                              backgroundImage: MemoryImage(
                                controller.userPhotoBytes.value!,
                              ),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 25,
                              backgroundImage: AssetImage(
                                'assets/images/user.png',
                              ),
                            );
                          }
                        }),
                        SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Selamat datang',
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            Obx(
                              () => Text(
                                controller.userName.value,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    IconButton(
                      onPressed: controller.logout,
                      icon: Icon(Icons.settings, color: Colors.white),
                    ),
                  ],
                ),
              ),
            ],
          ),

          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                children: [
                  Transform.translate(
                    offset: Offset(0, -30),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Rank',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      backgroundImage: AssetImage(
                                        'assets/images/mahkota.png',
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Obx(
                                      () => Text(
                                        '${controller.userRank.value} / 100',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              height: 50,
                              width: 1,
                              color: Colors.grey.shade300,
                            ),
                            Column(
                              children: [
                                Text(
                                  'Points',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontFamily: 'Poppins',
                                  ),
                                ),
                                SizedBox(height: 8),
                                Row(
                                  children: [
                                    Icon(
                                      Icons.emoji_events,
                                      color: Colors.amber,
                                      size: 36,
                                    ),
                                    SizedBox(width: 8),
                                    Obx(
                                      () => Text(
                                        '${controller.userPoints.value}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          fontFamily: 'Poppins',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: GridView.count(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              crossAxisCount: 2,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                              childAspectRatio: 2.0,
                              children: [
                                GestureDetector(
                                  onTap: () => Get.offAllNamed('/continue'),
                                  child: Container(
                                    padding: EdgeInsets.all(16),
                                    decoration: BoxDecoration(
                                      color: Color(0xFF6A5041),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(height: 4),
                                        Text(
                                          'Continue',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                        Obx(
                                          () => Text(
                                            controller.hasLastPlay.value
                                                ? '${controller.lastKategoriNama.value} - ${controller.lastLevelNama.value}'
                                                : 'Belum ada progress',
                                            style: TextStyle(
                                              color: Colors.white70,
                                              fontSize: 11,
                                              fontFamily: 'Poppins',
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                _menuCard(
                                  color: Colors.orange,
                                  icon: Icons.quiz,
                                  title: 'Daily Quiz',
                                  subtitle: Text(
                                    'Tantangan hari ini',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  onTap: () => Get.toNamed('/daily-quiz'),
                                ),
                                _menuCard(
                                  color: Colors.blue,
                                  icon: Icons.pie_chart,
                                  title: 'Statistic',
                                  subtitle: Text(
                                    'Lihat progres kamu',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  onTap: () => Get.toNamed('/statistik'),
                                ),
                                _menuCard(
                                  color: Colors.teal,
                                  icon: Icons.category,
                                  title: 'Kategori',
                                  subtitle: Text(
                                    'Lihat progres kamu',
                                    style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 11,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  onTap: () => Get.toNamed('/game-kategory'),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 34),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 12),
                                Obx(
                                  () => Column(
                                    children: controller.kategoriProgress.map((
                                      k,
                                    ) {
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: 12,
                                        ),
                                        child: QuizProgressCard(
                                          title: k['nama'],
                                          subtitle: k['label'],
                                          progress: k['progress'],
                                          icon: k['icon'],
                                          color: const Color(0xFF6A5041),
                                        ),
                                      );
                                    }).toList(),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
          if (index == 1) {
            Get.toNamed('/leaderboard');
          } else if (index == 2) {
            Get.toNamed('/profile');
          }
        },
      ),
    );
  }

  Widget _menuCard({
    required Color color,
    required IconData icon,
    required String title,
    required Widget subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: color.withValues(alpha: 0.4),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 24),
            SizedBox(height: 4),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Poppins',
              ),
            ),
            subtitle,
          ],
        ),
      ),
    );
  }
}

class QuizProgressCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final double progress; // 0.0 - 1.0
  final Color color;
  final String icon;

  const QuizProgressCard({
    super.key,
    this.title = 'Daily Quiz',
    this.subtitle = 'Lihat progres kamu',
    this.progress = 0.0,
    this.color = const Color(0xFF7C4DFF),
    this.icon = 'assets/images/flame.png',
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.4),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: Color(0xFFFAEEDA),
              borderRadius: BorderRadius.circular(
                10,
              ),
            ),
            child: Image.asset(
              icon,
              width: 50,
              height: 50  ,
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + persentase
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    Text(
                      '${(progress * 100).toInt()}%',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),

                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.75),
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 8),

                // Progress bar
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 6,
                    backgroundColor: Colors.white.withOpacity(0.3),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      Colors.white,
                    ),
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
