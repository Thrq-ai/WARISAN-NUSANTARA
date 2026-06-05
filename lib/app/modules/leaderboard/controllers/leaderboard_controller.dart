import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LeaderboardController extends GetxController {
  //TODO: Implement LeaderboardController
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final leaderboardList = <Map<String, dynamic>>[].obs;
  final isLoading = false.obs;

  final currentUserRank = 0.obs;
  final currentUserPoints = 0.obs;
  final currentUserName = ''.obs;
  final currentUserId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    currentUserId.value = _auth.currentUser?.uid ?? '';
    loadLeaderboard();
  }

  Future<void> loadLeaderboard() async {
    try {
      isLoading.value = true;
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('points', descending: true)
          .limit(100)
          .get();

      List<Map<String, dynamic>> list = [];
      int rank = 1;
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['rank'] = rank;
        data['uid'] = doc.id;
        list.add(data);
        rank++;
      }

      leaderboardList.value = list;

      final currentUser = _auth.currentUser;
      if (currentUser != null) {
        final userIndex = list.indexWhere(
          (u) => u['uid'] == currentUser.uid,
        );
        if (userIndex != -1) {
          currentUserRank.value = list[userIndex]['rank'];
          currentUserPoints.value = list[userIndex]['points'] ?? 0;
          currentUserName.value = list[userIndex]['name'] ?? 'Pengguna';
        }
      }
    } catch (e) {
      print('Error load leaderboard: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
