import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:typed_data';

class HomeController extends GetxController {
  //TODO: Implement HomeController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userPhotoBytes = Rxn<Uint8List>();

  final userName = ''.obs;
  final userPhoto = ''.obs;
  final userRank = 0.obs;
  final userPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
    loadKategoriProgress();
  }

  void _loadUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Pengguna';
      userPhoto.value = user.photoURL ?? '';

      final doc = await _firestore.collection('users').doc(user.uid).get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null) {
          userPoints.value = (data['points'] ?? 0) as int;

          if (data['photoBase64'] != null) {
            final bytes = base64Decode(data['photoBase64']);
            userPhotoBytes.value = bytes;
          }
        }
      }

      final rankSnapshot = await _firestore
          .collection('users')
          .where('points', isGreaterThan: userPoints.value)
          .count()
          .get();

      userRank.value = (rankSnapshot.count ?? 0) + 1;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }

  final lastKategoriNama = ''.obs;
  final lastLevelNama = ''.obs;
  final hasLastPlay = false.obs;

  final kategoriProgress = <Map<String, dynamic>>[].obs;

  Future<void> loadKategoriProgress() async {
  final prefs = await SharedPreferences.getInstance();

  final kategoriList = {
    'Rumah Adat': 'assets/images/rumah_adat.png',
    'Baju Adat': 'assets/images/baju_adat.png',
    'Alat Musik Tradisional': 'assets/images/alat_musik.png',
  };

  final result = <Map<String, dynamic>>[];

  for (final entry in kategoriList.entries) {
    final nama = entry.key;
    final icon = entry.value;
    final saved = prefs.getString('levelData_$nama');
    int selesai = 0;
    int total = 10;

    if (saved != null) {
      final decoded = List<Map<String, dynamic>>.from(
        (jsonDecode(saved) as List).map((e) => Map<String, dynamic>.from(e)),
      );
      total = decoded.length;
      selesai = decoded.where((l) => l['selesai'] == true).length;
    }

    result.add({
      'nama': nama,
      'icon': icon,
      'progress': total == 0 ? 0.0 : selesai / total,
      'label': '$selesai / $total level',
    });
  }

  kategoriProgress.value = result;
}

  @override
  void onReady() {
    super.onReady();
    loadLastPlay();
    loadKategoriProgress();
  }

  Future<void> loadLastPlay() async {
    final prefs = await SharedPreferences.getInstance();
    final lastPlayJson = prefs.getString('last_play');
    if (lastPlayJson == null) {
      hasLastPlay.value = false;
      return;
    }
    final data = Map<String, dynamic>.from(jsonDecode(lastPlayJson));
    lastKategoriNama.value = data['kategoriNama'] ?? '';
    lastLevelNama.value = data['levelNama'] ?? '';
    hasLastPlay.value = true;
  }
}
