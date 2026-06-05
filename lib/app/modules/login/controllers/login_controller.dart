import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:warisan_nusantara/services/google_auth_service.dart';

class LoginController extends GetxController {
  //TODO: Implement LoginController
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final isLoading = false.obs;
  final isPasswordHidden = true.obs;

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void togglePassword() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();

    super.onClose();
  }

  bool _isValid() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Email dan Password harus di isi!',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return false;
    }

    if (password.length < 6) {
      Get.snackbar(
        'Gagal',
        'Password minimal 6 karakter!',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );
      return false;
    }
    return true;
  }

  Future<void> login() async {
    if (!_isValid()) return;

    try {
      isLoading.value = true;
      print('Mencoba login...');

      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );

      print('Login berhasil!');

      Get.snackbar(
        'Berhasil',
        'Selamat datang kembali!',
        backgroundColor: Colors.white,
        colorText: Colors.black,
      );

      Get.offAllNamed('/home');
    } catch (e) {
      print('ERROR: $e');

      String message = 'Terjadi kesalahan';

      if (e.toString().contains('user-not-found')) {
        message = 'Akun tidak ditemukan';
      } else if (e.toString().contains('wrong-password')) {
        message = 'Password salah';
      } else if (e.toString().contains('invalid-email')) {
        message = 'Format email tidak valid';
      } else if (e.toString().contains('invalid-credential')) {
        message = 'Email atau password salah';
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

  void loginGoogle() async {
    final result = await GoogleAuthService.signInWithGoogle();
    if (result != null) {
      Get.offAllNamed('/home'); // navigasi ke home
    } else {
      Get.snackbar('Gagal', 'Login dibatalkan');
    }
  }
}
