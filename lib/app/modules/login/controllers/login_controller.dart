import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class LoginController extends GetxController {
  final AuthService _authService = AuthService.to;

  final emailController = TextEditingController(text: "budi@gmail.com");
  final passwordController = TextEditingController(text: "password123");

  var isLoading = false.obs;
  var isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar(
        "Peringatan",
        "Email dan kata sandi tidak boleh kosong",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
      );
      return;
    }

    try {
      isLoading.value = true;
      final user = await _authService.login(
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        Get.snackbar("Sukses", "Selamat datang kembali, ${user.name}!");
        if (user.isOnboarded) {
          Get.offAllNamed('/botnavbar');
        } else {
          Get.offAllNamed('/onboarding');
        }
      }
    } catch (e) {
      Get.snackbar(
        "Gagal Masuk",
        e.toString().replaceAll('Exception: ', ''),
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red.withOpacity(0.1),
        colorText: Colors.red,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}