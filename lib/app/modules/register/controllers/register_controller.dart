import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/services/auth_service.dart';

class RegisterController extends GetxController {
  final AuthService _authService = AuthService.to;

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;
  var isObscure = true.obs;

  void toggleObscure() {
    isObscure.value = !isObscure.value;
  }

  void register() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      Get.snackbar("Peringatan", "Semua data wajib diisi");
      return;
    }

    try {
      isLoading.value = true;

      final user = await _authService.register(
        nameController.text,
        emailController.text,
        passwordController.text,
      );

      if (user != null) {
        Get.snackbar("Berhasil", "Akun berhasil dibuat! Silakan lengkapi profil Anda.");
        Get.offAllNamed('/onboarding');
      }
    } catch (e) {
      Get.snackbar("Gagal Daftar", e.toString().replaceAll('Exception: ', ''));
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