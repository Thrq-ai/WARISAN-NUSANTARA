import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';

class ProfileSettingsController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final nameController = TextEditingController();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final isLoading = false.obs;
  final isOldPasswordHidden = true.obs;
  final isNewPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final userName = ''.obs;
  final userEmail = ''.obs;
  final userPhoto = ''.obs;

  final ImagePicker _picker = ImagePicker();
  final selectedImageBytes = Rxn<Uint8List>();

  @override
  void onInit() {
    super.onInit();
    _loadUserData();
  }

  void _loadUserData() {
    final user = _auth.currentUser;
    if (user != null) {
      userName.value = user.displayName ?? '';
      userEmail.value = user.email ?? '';
      userPhoto.value = user.photoURL ?? '';
      nameController.text = user.displayName ?? '';
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final XFile? image = await _picker.pickImage(
      source: source,
      imageQuality: 80,
    );
    if (image != null) {
      final bytes = await image.readAsBytes();
      selectedImageBytes.value = bytes;
    }
  }

  void showImageOpdtions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            ListTile(
              leading: Icon(Icons.photo_library, color: Color(0xFF6A5041)),
              title: Text('Pilih dari galeri'),
              onTap: () {
                Get.back();
                pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: Icon(Icons.delete, color: Color(0xFF6A5041)),
              title: Text('Hapus Foto', style: TextStyle(color: Colors.red)),
              onTap: () {
                Get.back();
                selectedImageBytes.value = null;
              },
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  String? _imageToBase64() {
    if (selectedImageBytes.value != null) {
      return base64Encode(selectedImageBytes.value!);
    }
    return null;
  }

  Future<void> saveProfile() async {
    if (nameController.text.trim().isEmpty) {
      Get.snackbar(
        'Gagal',
        'Nama tidak boleh kosong',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user != null) {
        await user.updateDisplayName(nameController.text.trim());
        userName.value = nameController.text.trim();

        Map<String, dynamic> updateData = {
          'name': nameController.text.trim(),
        };

        final base64Image = _imageToBase64();
        if (base64Image != null) {
          updateData['photoBase64'] = base64Image;
          userPhoto.value = 'base64:$base64Image';
        }

        await _firestore
            .collection('users')
            .doc(user.uid)
            .set(updateData, SetOptions(merge: true));

        Get.snackbar(
          'Berhasil',
          'Profil berhasil diperbarui!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        Get.offAllNamed('/profile');
      }
    } catch (e) {
      Get.snackbar(
        'Gagal',
        'Terjadi kesalahan, coba lagi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword() async {
    final oldPassword = oldPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (oldPassword.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      Get.snackbar(
        'Gagal',
        'Semua field password harus diisi',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword.length < 6) {
      Get.snackbar(
        'Gagal',
        'Password baru minimal 6 karakter',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (newPassword != confirmPassword) {
      Get.snackbar(
        'Gagal',
        'Konfirmasi password tidak cocok',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    try {
      isLoading.value = true;

      final user = _auth.currentUser;
      if (user != null && user.email != null) {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: oldPassword,
        );
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(newPassword);

        oldPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();

        Get.snackbar(
          'Berhasil',
          'Password berhasil diubah!',
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      String message = 'Terjadi kesalahan';
      if (e.toString().contains('wrong-password') ||
          e.toString().contains('invalid-credential')) {
        message = 'Password lama salah';
      }
      Get.snackbar(
        'Gagal',
        message,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}