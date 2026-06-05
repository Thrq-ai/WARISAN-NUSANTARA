import 'package:get/get.dart';

class KoleksiController extends GetxController {
  final koleksi = <Map<String, dynamic>>[
    {
      "name": "Rumah adat",
      "category": "Rumah Adat",
      "image": "assets/images/rumah_adat.png",
      "unlocked": true,
    },
    {
      "name": "Alat Musik Tradisional",
      "category": "Alat Musik",
      "image": "assets/images/alat_musik.png",
      "unlocked": false,
    },
    {
      "name": "Pakaian Adat",
      "category": "Baju Adat",
      "image": "assets/images/baju_adat.png",
      "unlocked": true,
    },
  ].obs;

  List<Map<String, dynamic>> getByCategory(String category) {
    return koleksi
        .where((item) => item["category"] == category)
        .toList();
  }
}