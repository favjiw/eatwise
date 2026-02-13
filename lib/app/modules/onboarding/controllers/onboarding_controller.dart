import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class OnboardingController extends GetxController {
  final UserService _userService = UserService.to;

  // Page Controller untuk navigasi slide
  final pageController = PageController();
  var pageIndex = 0.obs;

  // --- DATA INPUT ---
  var selectedGender = ''.obs; // 'L' atau 'P'
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  // --- DATA ALERGI ---
  // List alergi yang tersedia untuk dipilih
  final availableAllergies = [
    'Kacang', 'Seafood', 'Susu Sapi', 'Telur',
    'Gandum', 'Kedelai', 'Ikan', 'Kerang'
  ];
  var selectedAllergies = <String>[].obs;

  var isLoading = false.obs;

  // Pindah Halaman
  void updatePageIndex(int index) {
    pageIndex.value = index;
  }

  void nextPage() {
    if (pageIndex.value < 2) {
      pageController.nextPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease
      );
    } else {
      submitProfile(); // Halaman terakhir -> Submit
    }
  }

  void previousPage() {
    if (pageIndex.value > 0) {
      pageController.previousPage(
          duration: const Duration(milliseconds: 300),
          curve: Curves.ease
      );
    }
  }

  // Logika Pilih Gender
  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  // Logika Pilih Alergi (Toggle)
  void toggleAllergy(String allergy) {
    if (selectedAllergies.contains(allergy)) {
      selectedAllergies.remove(allergy);
    } else {
      selectedAllergies.add(allergy);
    }
  }

  // SUBMIT DATA KE BACKEND
  void submitProfile() async {
    // Validasi sederhana
    if (selectedGender.value.isEmpty || ageController.text.isEmpty ||
        heightController.text.isEmpty || weightController.text.isEmpty) {
      Get.snackbar("Peringatan", "Mohon lengkapi semua data wajib (*)");
      return;
    }

    try {
      isLoading.value = true;

      // Siapkan Model User
      UserModel userUpdate = UserModel(
        age: int.tryParse(ageController.text),
        gender: selectedGender.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        allergies: selectedAllergies.toList(),
      );

      // Kirim ke API
      await _userService.updateProfile(userUpdate);

      Get.snackbar("Sukses", "Profil berhasil disimpan!");
      Get.offAllNamed('/botnavbar'); // Masuk Dashboard

    } catch (e) {
      Get.snackbar("Gagal", e.toString().replaceAll('Exception: ', ''));
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    pageController.dispose();
    super.onClose();
  }
}