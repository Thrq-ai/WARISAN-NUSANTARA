import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class ContinueController extends GetxController {
  final isLoading = true.obs;
  final hasLastPlay = false.obs;

  // Data level terakhir
  final lastKategoriNama = ''.obs;
  final lastKategoriDeskripsi = ''.obs;
  final lastKategoriImage = ''.obs;
  final lastKategoriWarna = 0xFF6A5041.obs;
  final lastLevel = 0.obs;
  final lastLevelNama = ''.obs;
  final lastBintang = 0.obs;
  final lastSelesai = false.obs;

  // Progress kategori terakhir
  final totalLevelKategori = 0.obs;
  final totalSelesaiKategori = 0.obs;

  @override
  void onReady() {
    super.onReady();
    loadLastPlay();
  }

  Future<void> loadLastPlay() async {
    isLoading.value = true;
    final prefs = await SharedPreferences.getInstance();

    final lastPlayJson = prefs.getString('last_play');
    if (lastPlayJson == null) {
      hasLastPlay.value = false;
      isLoading.value = false;
      return;
    }

    final data = Map<String, dynamic>.from(jsonDecode(lastPlayJson));
    lastKategoriNama.value = data['kategoriNama'] ?? '';
    lastKategoriDeskripsi.value = data['kategoriDeskripsi'] ?? '';
    lastKategoriImage.value = data['kategoriImage'] ?? '';
    lastKategoriWarna.value = (data['kategoriWarna'] as int?) ?? 0xFF6A5041;
    lastLevel.value = (data['level'] as int?) ?? 1;
    lastLevelNama.value = data['levelNama'] ?? '';
    lastBintang.value = (data['bintang'] as int?) ?? 0;
    lastSelesai.value = (data['selesai'] as bool?) ?? false;

    // Ambil progress kategori
    final key = 'levelData_${lastKategoriNama.value}';
    final savedLevel = prefs.getString(key);
    if (savedLevel != null) {
      final list = List<Map<String, dynamic>>.from(
        (jsonDecode(savedLevel) as List).map((e) => Map<String, dynamic>.from(e)),
      );
      totalLevelKategori.value = list.length;
      totalSelesaiKategori.value = list.where((l) => l['selesai'] == true).length;
    }

    hasLastPlay.value = true;
    isLoading.value = false;
  }

  // Dipanggil dari halaman_quiz_controller saat quiz selesai
  static Future<void> saveLastPlay({
    required String kategoriNama,
    required String kategoriDeskripsi,
    required String kategoriImage,
    required int kategoriWarna,
    required int level,
    required String levelNama,
    required int bintang,
    required bool selesai,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('last_play', jsonEncode({
      'kategoriNama': kategoriNama,
      'kategoriDeskripsi': kategoriDeskripsi,
      'kategoriImage': kategoriImage,
      'kategoriWarna': kategoriWarna,
      'level': level,
      'levelNama': levelNama,
      'bintang': bintang,
      'selesai': selesai,
    }));
  }

  void lanjutMain() {
    final targetLevel = lastSelesai.value
        ? lastLevel.value + 1
        : lastLevel.value;

    Get.toNamed(
      '/halaman-quiz',
      arguments: {
        'level': targetLevel,
        'kategoriNama': lastKategoriNama.value,
        'kategoriDeskripsi': lastKategoriDeskripsi.value,
        'kategoriImage': lastKategoriImage.value,
        'kategoriWarna': lastKategoriWarna.value,
      },
    );
  }

  void pilihKategoriLain() {
    Get.toNamed('/game-kategory');
  }
}