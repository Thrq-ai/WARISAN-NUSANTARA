import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:warisan_nusantara/app/routes/app_pages.dart';
import 'package:get/get.dart';

class RegisterController extends GetxController {
  //TODO: Implement RegisterController
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  bool _isValid() {
    final name = nameController.text.trim();
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Semua field harus di isi',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return false;
    }
    if (password.length < 6) {
      Get.snackbar(
        'Gagal',
        'Password minimal 6 karakter',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return false;
    }
    return true;
  }

  Future<void> register() async {
    if (!_isValid()) return;

    try {
      isLoading.value = true;

      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(nameController.text.trim());

      // Simpan data user ke Firestore
      await _firestore.collection('users').doc(userCredential.user?.uid).set({
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'points': 0,
        'rank': 0,
        'createdAt': DateTime.now(),
      });

      Get.snackbar(
        'Berhasil',
        'Akun berhasil dibuat',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      Get.offAllNamed(Routes.LOGIN);
    } catch (e) {
      String message = 'Terjadi kesalahan';

      if (e.toString().contains('email-already-in-use')) {
        message = 'Email sudah digunakan';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Format email tidak valid';
      }

      Get.snackbar(
        'Gagal',
        message,
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
