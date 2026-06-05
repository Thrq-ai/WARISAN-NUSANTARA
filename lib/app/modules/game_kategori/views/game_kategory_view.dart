import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/game_kategory_controller.dart';

class GameKategoryView extends GetView<GameKategoryController> {
  const GameKategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF6A5041),
        centerTitle: true,
        leading: IconButton (
          icon: Icon(Icons.arrow_back_ios, color: Colors.white,),
          onPressed: () => Get.offAllNamed('/home'),
        ),
        title: Text(
          'KATEGORI GAME',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18,
            fontFamily: 'Poppins',
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 20),
            Obx(
              () => Column(
                children: controller.kategoriList.map((kategori) {
                  return _buildKategoriCard(kategori);
                }).toList(),
              ),
            ),

            SizedBox(height: 100),
            Row(
              children: [
                Expanded(child: Divider(color: Colors.black)),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'INFO & TIPS',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                Expanded(child: Divider(color: Colors.black)),
              ],
            ),

            SizedBox(height: 16),

            // List Info & Tips
            Obx(
              () => Column(
                children: controller.infoTipsList.map((info) {
                  return _buildInfoCard(info);
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKategoriCard(Map<String, dynamic> kategori) {
    return GestureDetector(
      onTap: () { 
        Get.offAllNamed(
        '/game-level',
        arguments: {
          'nama': kategori['nama'],
          'deskripsi': kategori['deskripsi'],
          'image': kategori['image'],
          'warna': kategori['warna'],
          'background': kategori['background'],
        },
      );
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 16),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Color(kategori['warna'] as int),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                color: Color(0xFFFAEEDA),
                borderRadius: BorderRadius.circular(12),
              ),  
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  kategori['image'],
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      Icon(
                        Icons.image,color: Colors.white, size: 32),
                ),
              ),
            ),
            SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    kategori['nama'],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    kategori['deskripsi'],
                    style: TextStyle(
                      color: Colors.white54,
                      fontWeight: FontWeight.w500,
                      fontSize: 12,
                      fontFamily: 'Poppins',
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.6),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      kategori['level'],
                      style: TextStyle(
                        color: Color(0xFF6A5041),
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Icon(Icons.chevron_right, color: Colors.white),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(Map<String, dynamic> info) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Color(info['warna']).withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Color(info['warna']).withOpacity(0.5)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Color(info['warna']).withOpacity(0.4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              info['icon'] == 'star' ? Icons.star : Icons.lightbulb,
              color: Color(
                info['warna'] == 0xFFFFD700 ? 0xFFB8860B : 0xFF6A5041,
              ),
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  info['judul'],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  info['isi'],
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.black87,
                    fontFamily: 'Poppins',
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
