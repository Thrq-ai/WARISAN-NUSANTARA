import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/koleksi_controller.dart';

class KoleksiView extends GetView<KoleksiController> {
  const KoleksiView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Koleksi Budaya",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
        ),
        backgroundColor: const Color(0xFF6A5041),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Get.toNamed('/profile'),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _categorySection('Rumah Adat'),

            const SizedBox(height: 20),

            _categorySection('Baju Adat'),

            const SizedBox(height: 20),

            _categorySection("Alat Musik"),
          ],
        ),
      ),
    );
  }

  Widget _categorySection(String category) {
    final items = controller.getByCategory(category);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const SizedBox(width: 8),
            Text(
              category,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 150,
          child: GridView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              mainAxisSpacing: 10,
            ),
            itemBuilder: (context, index) {
              final item = items[index];

              return Container(
                width: 120,
                decoration: BoxDecoration(
                  color: Color(0xFFF8F6F3),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    item["unlocked"]
                        ? Image.asset(item["image"], height: 70)
                        : const Icon(Icons.lock, size: 50, color: Colors.grey),

                    const SizedBox(height: 8),

                    Text(
                      item["unlocked"] ? item["name"] : "???",
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
