import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_level_controller.dart';

class GameLevelView extends GetView<GameLevelController> {
  const GameLevelView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          // Header
          Obx(
            () => Container(
              width: double.infinity,
              padding: EdgeInsets.only(
                top: 50,
                left: 20,
                right: 20,
                bottom: 24,
              ),
              decoration: BoxDecoration(
                color: Color(controller.kategoriWarna.value),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                image: controller.kategoriBackground.value.isNotEmpty
                    ? DecorationImage(
                        image: AssetImage(controller.kategoriBackground.value),
                        fit: BoxFit.cover,
                        opacity: 0.2,
                      )
                    : null,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () => Get.toNamed('/game-kategory'),
                    icon: Icon(Icons.arrow_back, color: Colors.white),
                    padding: EdgeInsets.zero,
                  ),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              controller.kategoriName.value,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              controller.kategoriDeskripsi.value,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontFamily: 'Poppins',
                              ),
                            ),
                          ],
                        ),
                      ),
                      Image.asset(
                        controller.kategoriImage.value,
                        width: 80,
                        height: 80,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image, color: Colors.white, size: 60),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Progress',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      Text(
                        '${controller.totalLevel.value == 0 ? 0 : ((controller.totalSelesai.value / controller.totalLevel.value) * 100).toInt()}%',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  // PROGRESS BAR
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: controller.totalLevel.value == 0
                          ? 0.0
                          : controller.totalSelesai.value /
                                controller.totalLevel.value,
                      backgroundColor: Colors.white30,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      minHeight: 8,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // List Level
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(20),
              child: Obx(() {
                final selesai = controller.levelList
                    .where((l) => l['selesai'] == true)
                    .toList();
                final terbuka = controller.levelList
                    .where(
                      (l) => l['selesai'] == false && l['unlocked'] == true,
                    )
                    .toList();
                final terkunci = controller.levelList
                    .where((l) => l['unlocked'] == false)
                    .toList();

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (selesai.isNotEmpty) ...[
                      Text(
                        'Sudah selesai',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: selesai
                            .map((l) => _buildLevelCard(l, true, controller))
                            .toList(),
                      ),
                      SizedBox(height: 24),
                    ],
                    if (terbuka.isNotEmpty) ...[
                      Text(
                        'Belum selesai',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: terbuka
                            .map((l) => _buildLevelCard(l, false, controller))
                            .toList(),
                      ),
                      SizedBox(height: 24),
                    ],
                    if (terkunci.isNotEmpty) ...[
                      Text(
                        'Terkunci',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          fontFamily: 'Poppins',
                        ),
                      ),
                      SizedBox(height: 12),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: 1.8,
                        children: terkunci
                            .map((l) => _buildLevelCard(l, false, controller))
                            .toList(),
                      ),
                    ],
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLevelCard(
    Map<String, dynamic> level,
    bool selesai,
    GameLevelController ctrl,
  ) {
    final unlocked = level['unlocked'] == true;
    return GestureDetector(
      onTap: () async {
        if (!unlocked) return;
        final result = await Get.toNamed(
          '/halaman-quiz',
          arguments: {
            'level': level['level'],
            'kategori': ctrl.kategoriName.value,
            'kategoriNama': ctrl.kategoriName.value,
            'kategoriDeskripsi': ctrl.kategoriDeskripsi.value,
            'kategoriImage': ctrl.kategoriImage.value,
            'kategoriWarna': ctrl.kategoriWarna.value,
          },
        );

        print('=== result: $result');
        if (result != null && result is Map) {
          print('=== memanggil updateLevel');
          ctrl.updateLevel(result['level'] as int, result['bintang'] as int);
        }
      },
      child: Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: unlocked ? Colors.black : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${level['level']}',
                  style: TextStyle(
                    color: unlocked ? Colors.white60 : Colors.grey,
                    fontSize: 11,
                    fontFamily: 'Poppins',
                  ),
                ),
                if (!unlocked) Icon(Icons.lock, color: Colors.grey, size: 14),
              ],
            ),
            Text(
              level['nama'],
              style: TextStyle(
                color: selesai ? Colors.white : Colors.grey,
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
