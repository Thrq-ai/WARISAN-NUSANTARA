import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/profile_settings_controller.dart';

class ProfileSettingsView extends GetView<ProfileSettingsController> {
  const ProfileSettingsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.grey[100],
        elevation: 0,
        centerTitle: true,
        title: Text(
          'ProfileSettingsView',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Poppins',
          ),
        ),

        leading: IconButton(
          onPressed: () => Get.offAllNamed('/profile'),
          icon: Icon(Icons.arrow_back, color: Colors.black),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 30),

          Center(
            child: Stack(
              children: [
                Obx(() {
                  if (controller.selectedImageBytes.value != null) {
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: MemoryImage(
                        controller.selectedImageBytes.value!,
                      ),
                    );
                  } else if (controller.userPhoto.value.isNotEmpty) {
                    return CircleAvatar(
                      radius: 60,
                      backgroundImage: NetworkImage(controller.userPhoto.value),
                    );
                  } else {
                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: Color(0xFF),
                      child: Icon(Icons.person, size: 60, color: Colors.white),
                    );
                  }
                }),

                Positioned(
                  bottom: 0,
                  right: 0,
                  child: GestureDetector(
                    onTap: () => controller.showImageOpdtions(context),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          SizedBox(height: 8),

          Obx(
            () => Text(
              controller.userEmail.value,
              style: TextStyle(
                color: Colors.grey,
                fontSize: 13,
                fontFamily: 'Poppins',
              ),
            ),
          ),

          SizedBox(height: 32),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Username',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Poppins,',
                  ),
                ),
                SizedBox(height: 8),
                TextField(
                  controller: controller.nameController,
                  decoration: InputDecoration(
                    hintText: 'Masukkan Username',
                    prefixIcon: Icon(
                      Icons.person_outline,
                      color: Color(0xFF6A5041),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF6A5041)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Color(0xFF6A5041)),
                    ),
                  ),
                ),

                SizedBox(height: 48),
                SizedBox(height: 20),

                // Email (read only)
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextField(
                    enabled: false, // ← tidak bisa diedit
                    decoration: InputDecoration(
                      hintText: controller.userEmail.value,
                      prefixIcon: Icon(
                        Icons.email_outlined,
                        color: Color(0xFF6A5041),
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade200,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      disabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.grey.shade300),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Password lama
                Text(
                  'Password Lama',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextField(
                    controller: controller.oldPasswordController,
                    obscureText: controller.isOldPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password lama',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6A5041),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isOldPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => controller.isOldPasswordHidden.value =
                            !controller.isOldPasswordHidden.value,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Password baru
                Text(
                  'Password Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextField(
                    controller: controller.newPasswordController,
                    obscureText: controller.isNewPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Masukkan password baru',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6A5041),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isNewPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () => controller.isNewPasswordHidden.value =
                            !controller.isNewPasswordHidden.value,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Konfirmasi password baru
                Text(
                  'Konfirmasi Password Baru',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                    fontFamily: 'Poppins',
                  ),
                ),
                SizedBox(height: 8),
                Obx(
                  () => TextField(
                    controller: controller.confirmPasswordController,
                    obscureText: controller.isConfirmPasswordHidden.value,
                    decoration: InputDecoration(
                      hintText: 'Ulangi password baru',
                      prefixIcon: Icon(
                        Icons.lock_outline,
                        color: Color(0xFF6A5041),
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          controller.isConfirmPasswordHidden.value
                              ? Icons.visibility_off
                              : Icons.visibility,
                          color: Colors.grey,
                        ),
                        onPressed: () =>
                            controller.isConfirmPasswordHidden.value =
                                !controller.isConfirmPasswordHidden.value,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Color(0xFF6A5041)),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Obx(
                    () => SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.saveProfile,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6A5041),
                          disabledBackgroundColor: Color(
                            0xFF6A5041,
                          ).withValues(alpha: 0.6),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: controller.isLoading.value
                            ? CircularProgressIndicator(color: Colors.white)
                            : Text(
                                'Simpan Perubahan',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontFamily: 'Poppins',
                                ),
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
