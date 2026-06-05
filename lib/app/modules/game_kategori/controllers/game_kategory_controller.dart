import 'package:get/get.dart';

class GameKategoryController extends GetxController {
  //TODO: Implement GameKategoryController
  final kategoriList = <Map<String, dynamic>>[].obs;
  final infoTipsList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _loadKategori();
    _loadInfoTips();
  }

  void _loadKategori() {
    kategoriList.value = [
      {
        'nama': 'Baju Adat',
        'deskripsi': 'Pakaian Adat Nusantara',
        'level': '25Lvl',
        'warna': 0xFF6A5041,
        'image': 'assets/images/baju_adat.png',
      },
      {
        'nama': 'Rumah Adat',
        'deskripsi': 'Rumah Adat Nusantara',
        'level': '25Lvl',
        'warna': 0xFF6A5041,
        'image': 'assets/images/rumah_adat.png',
      },
      {
        'nama': 'Alat Musik Tradisional',
        'deskripsi': 'Alat Musik Tradisional',
        'level': '25Lvl',
        'warna': 0xFF6A5041,
        'image': 'assets/images/alat_musik.png',
      },
    ];
  }

  void _loadInfoTips() {
    infoTipsList.value = [
      {
        'judul': 'Funfact',
        'isi': 'Indonesia punya 300 suku bangsa dengan budaya yang kaya',
        'warna': 0xFFFFCC4D,
        'icon': 'star'
      },
      {
        'judul': 'Tips',
        'isi': 'Indonesia punya 300 suku bangsa dengan budaya yang kaya',
        'warna': 0xFFFFCC4D,
        'icon': 'lightbulb'
      },
    ];
  }
}
