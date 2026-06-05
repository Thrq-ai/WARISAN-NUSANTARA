import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GameLevelController extends GetxController {
  final kategoriName = ''.obs;
  final kategoriDeskripsi = ''.obs;
  final kategoriImage = ''.obs;
  final kategoriWarna = 0xFF6A5041.obs;
  final kategoriBackground = ''.obs;

  final levelList = <Map<String, dynamic>>[].obs;
  final totalSelesai = 0.obs;
  final totalLevel = 0.obs;

  @override
  void onInit() {
    super.onInit();
    final rawArgs = Get.arguments;
    print('=== onInit arguments: $rawArgs');
    final args = rawArgs != null
        ? Map<String, dynamic>.from(rawArgs as Map)
        : null;

    if (args != null && args.isNotEmpty) {
      kategoriName.value = args['nama'] ?? '';
      kategoriDeskripsi.value = args['deskripsi'] ?? '';
      kategoriImage.value = args['image'] ?? '';
      kategoriWarna.value = args['warna'] ?? 0xFF6A5041;
      kategoriBackground.value = args['background'] ?? '';
      print('=== kategoriName: ${kategoriName.value}');
    }
  }

  @override
  void onReady() {
    super.onReady();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadLevel();
    });
  }

  void _loadLevel() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'levelData_${kategoriName.value}';
    final saved = prefs.getString(key);

    print('=== _loadLevel key: $key');
    print('=== saved data: $saved');

    final _defaultPerKategori = {
      'Rumah Adat': [
        {
          'level': 1,
          'nama': 'Rumah Gadang',
          'bintang': 0,
          'selesai': false,
          'unlocked': true,
        },
        {
          'level': 2,
          'nama': 'Rumah Joglo',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 3,
          'nama': 'Rumah Honai',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 4,
          'nama': 'Rumah Tongkonan',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 5,
          'nama': 'Rumah Sasadu',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 6,
          'nama': 'Rumah Krong Bade',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 7,
          'nama': 'Rumah Limas',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 8,
          'nama': 'Rumah Bolon',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 9,
          'nama': 'Rumah Kebaya',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 10,
          'nama': 'Rumah Betang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
      ],
      'Baju Adat': [
        {
          'level': 1,
          'nama': 'Kebaya Jawa',
          'bintang': 0,
          'selesai': false,
          'unlocked': true,
        },
        {
          'level': 2,
          'nama': 'Kebaya Encim',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 3,
          'nama': 'Payas Agung',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 4,
          'nama': 'Ulos',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 5,
          'nama': 'Baju Bodo',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 6,
          'nama': 'Koteka',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 7,
          'nama': 'Cele',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 8,
          'nama': 'Baju Kurung',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 9,
          'nama': 'Ulee Balang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 10,
          'nama': 'Bundo Kanduang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
      ],
      'Alat Musik Tradisional': [
        {
          'level': 1,
          'nama': 'Angklung',
          'bintang': 0,
          'selesai': false,
          'unlocked': true,
        },
        {
          'level': 2,
          'nama': 'Gamelan',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 3,
          'nama': 'Sasando',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 4,
          'nama': 'Kolintang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 5,
          'nama': 'Tifa',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 6,
          'nama': 'Serunai',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 7,
          'nama': 'Gendang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 8,
          'nama': 'Celempung',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 9,
          'nama': 'Talempong',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
        {
          'level': 10,
          'nama': 'Saluang',
          'bintang': 0,
          'selesai': false,
          'unlocked': false,
        },
      ],
    };

    final defaultList = _defaultPerKategori[kategoriName.value] ?? [];

    if (saved != null) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(saved) as List).map((e) => Map<String, dynamic>.from(e)),
      );
      levelList.assignAll(decoded);
    } else {
      levelList.assignAll(defaultList);
      await prefs.setString(key, jsonEncode(defaultList));
    }

    levelList.refresh();
    totalLevel.value = levelList.length;
    totalSelesai.value = levelList.where((l) => l['selesai'] == true).length;
  }

  void updateLevel(int level, int bintang) async {
    final newList = List<Map<String, dynamic>>.from(levelList);
    final index = newList.indexWhere((l) => l['level'] == level);

    if (index != -1) {
      final bintangLama = (newList[index]['bintang'] as int?) ?? 0;
      newList[index] = {
        ...newList[index],
        'selesai': true,
        'bintang': bintang > bintangLama ? bintang : bintangLama,
        'unlocked': true,
      };

      if (index + 1 < newList.length) {
        newList[index + 1] = {...newList[index + 1], 'unlocked': true};
      }
    }

    levelList.clear();
    levelList.addAll(newList);
    totalSelesai.value = levelList.where((l) => l['selesai'] == true).length;

    final prefs = await SharedPreferences.getInstance();
    final key = 'levelData_${kategoriName.value}';
    await prefs.setString(key, jsonEncode(newList));

    print(
      '=== updateLevel selesai level: $level, totalSelesai: ${totalSelesai.value}',
    );
  }
}
