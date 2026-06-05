import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'dart:typed_data';

class ProfileController extends GetxController {
  //TODO: Implement ProfileController
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final userPhotoBytes = Rxn<Uint8List>();

  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhoto = ''.obs;
  final userRank = 0.obs;
  final userPoints = 0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData()  async{
    final user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? 'Pengguna';
      userEmail.value = user.email ?? '';
      userPhoto.value = user.photoURL ?? '';
      userRank.value = 65;
      userPoints.value = 1250;

      final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

      if (doc.exists) {
        final data = doc.data();
        if (data != null && data['photoBase64'] != null) {
          final bytes = base64Decode(data['photoBase64']);
          userPhotoBytes.value = bytes;
        }
      }
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
    Get.offAllNamed('/login');
  }
}
