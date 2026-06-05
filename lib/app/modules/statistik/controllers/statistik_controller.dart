import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class StatistikController extends GetxController {
  //TODO: Implement StatistikController

  final isLoadinhg = true.obs;

  final totalBenar = 0.obs;
  final totalSoal = 0.obs;
  final totalQuiz = 0.obs;
  final totalWaktu = 0.obs;
  final maxStreakJawaban = 0.obs;
  final currentStreak = 0.obs;
  final longestStreak = 0.obs;

  final totalPoin = 0.obs;
  final userRank = 0.obs;

  double get akurasi =>
      totalSoal.value == 0 ? 0 : (totalBenar.value / totalSoal.value) * 100;

  double get rataWaktu =>
      totalSoal.value == 0 ? 0 : totalWaktu.value / totalSoal.value;

  @override
  void onInit() {
    super.onInit();
    loadStatistik();
  }

  Future<void> loadStatistik() async {
    isLoadinhg.value = true;
    await Future.wait([_loadLokal(), _loadFirestore()]);
    isLoadinhg.value = false;
  }

  Future<void> _loadLokal() async {
    final prefs = await SharedPreferences.getInstance();

    totalBenar.value = prefs.getInt('total_benar') ?? 0;
    totalSoal.value = prefs.getInt('total_soal') ?? 0;
    totalQuiz.value = prefs.getInt('total_quiz') ?? 0;
    totalWaktu.value = prefs.getInt('total_waktu') ?? 0;
    maxStreakJawaban.value = prefs.getInt('max_streak') ?? 0;
    currentStreak.value = prefs.getInt('current_streak') ?? 0;
    longestStreak.value = prefs.getInt('longest_streak') ?? 0;
  }

  Future<void> _loadFirestore() async {
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) return;

      final doc = await FirebaseFirestore.instance
      .collection('users').doc(user.uid).get();

      if (doc.exists) {
        totalPoin.value = (doc.data()?['points'] ?? 0) as int;
      }

      final snapshot = await FirebaseFirestore.instance
      .collection('users').orderBy('points', descending: true).get();

      final index = snapshot.docs.indexWhere((d) => d.id == user.uid);
      userRank.value = index == 1 ? 0 : index + 1;
    } catch (e) {
      print('=== Error load firestore statistik: $e');
    }
  }
}
