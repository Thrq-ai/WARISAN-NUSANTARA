import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF6A5041),
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 250,
            child: Image.asset(
              'assets/images/background.png',
              fit: BoxFit.cover,
              width: 450,
               color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
          Column(
            children: [
              Spacer(),
              Stack(
                alignment: AlignmentGeometry.topCenter,
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 650,
                    width: double.infinity,
                    padding: EdgeInsets.only(top: 150),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(60),
                        topRight: Radius.circular(60),
                      ),
                    ),

                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              vertical: 16,
                              horizontal: 24,
                            ),
                            margin: EdgeInsets.only(bottom: 20),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 5,
                                  offset: Offset(0, 5),
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
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.amber,
                                          size: 30,
                                        ),
                                        SizedBox(width: 8),
                                        Obx(
                                          () => Text(
                                            '${controller.userRank.value} / 100',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  width: 1,
                                  height: 40,
                                  color: Colors.black,
                                ),
                                Column(
                                  children: [
                                    Text(
                                      'Points',
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          'assets/images/coins.png',
                                          width: 50,
                                          height: 50,
                                        ),
                                        SizedBox(width: 4),
                                        Obx(
                                          () => Text(
                                            '${controller.userPoints.value} / 100',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
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

                          GestureDetector(
                            onTap: () => Get.toNamed('/profile-settings'),
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),

                              child: Row(
                                children: [
                                  Padding(
                                    padding: EdgeInsetsGeometry.only(left: 20),
                                  ),
                                  Icon(Icons.person, color: Color(0xFF6A5041)),
                                  SizedBox(width: 20),
                                  Text(
                                    "Profile Setting",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => Get.toNamed('/history'),
                            child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 20)),
                                Icon(Icons.history, color: Color(0xFF6A5041)),
                                SizedBox(width: 20),
                                Text(
                                  "Riwayat bermain",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          ),
                          SizedBox(height: 15),
                          GestureDetector(
                            onTap: () => Get.toNamed('/koleksi'),
                            child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              color: Color(0xFFF5F5F5),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              children: [
                                Padding(padding: EdgeInsets.only(left: 20)),
                                Icon(Icons.military_tech, color: Color(0xFF6A5041)),
                                SizedBox(width: 20),
                                Text(
                                  "Riwayat bermain",
                                  style: TextStyle(fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ),
                          ),
                          SizedBox(height: 20),
                          GestureDetector(
                            onTap: controller.logout,
                            child: Container(
                              width: double.infinity,
                              height: 50,
                              decoration: BoxDecoration(
                                color: Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.1),
                                    blurRadius: 5,
                                    offset: Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  Padding(padding: EdgeInsets.only(left: 20)),
                                  Icon(Icons.logout, color: Colors.black),
                                  SizedBox(width: 20),
                                  Text(
                                    "Log Out",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: -75,
                    child: Column(
                      children: [
                        Obx(() {
                          if (controller.userPhotoBytes.value != null) {
                            return CircleAvatar(
                              radius: 60,
                              backgroundImage: MemoryImage(
                                controller.userPhotoBytes.value!,
                              ),
                            );
                          } else {
                            return CircleAvatar(
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: CircleAvatar(
                                radius: 57,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.person,
                                  color: Colors.grey[400],
                                ),
                              ),
                            );
                          }
                        }),

                        SizedBox(height: 20),
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF6A5041),
                            ),
                          ),
                        ),
                        SizedBox(height: 4),
                        Obx(
                          () => Text(
                            controller.userEmail.value,
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
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
            Get.offAllNamed('/home');
          } else if (index == 1) {
            Get.toNamed('/leaderboard');
          }
        },
      ),
    );
  }
}
