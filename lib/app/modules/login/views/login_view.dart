import 'package:flutter/material.dart';
import 'package:warisan_nusantara/app/routes/app_pages.dart';
import 'package:get/get.dart';
import 'package:warisan_nusantara/services/google_auth_service.dart';
import '../controllers/login_controller.dart';


class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(''), centerTitle: true),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 40),
            Center(
              child: Image.asset(
                'assets/images/logoApp.png',
                width: 180,
                height: 180,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'WARISAN NUSANTARA',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF6A5041),
              ),
            ),
            SizedBox(height: 80),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Column(
                children: [
                  TextField(
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Obx(
                    () => TextField(
                      controller: controller.passwordController,
                      obscureText: controller.isPasswordHidden.value,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.isPasswordHidden.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: controller.togglePassword,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),

                  Obx(
                    () => SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.isLoading.value
                            ? null
                            : controller.login,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF6A5041),
                          padding: EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text(
                          'LOGIN',
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          'Or Continue With',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 13,
                            fontFamily: 'Poppins,',
                          ),
                        ),
                      ),
                      Expanded(
                        child: Divider(color: Colors.black, thickness: 1),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                      ),
                      SizedBox(width: 24),

                      InkWell(
                        onTap: () async {
                          final result =
                              await GoogleAuthService.signInWithGoogle();
                          if (result != null) {
                            Get.offAllNamed(
                              '/home',
                            ); 
                          } else {
                            Get.snackbar('Gagal', 'Login dibatalkan');
                          }
                        },
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                          child: Image.asset(
                            'assets/images/google.png',
                            width: 30,
                            height: 30,
                          ),
                        ),
                      ),
                      SizedBox(width: 24),
                      InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don have an account?",
                        style: TextStyle(
                          color: Colors.black,
                          fontFamily: 'Poppins',
                          fontSize: 14,
                        ),
                      ),
                      GestureDetector(
                        onTap: () => Get.offAllNamed(Routes.REGISTER),
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            fontFamily: 'Poppins',
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
