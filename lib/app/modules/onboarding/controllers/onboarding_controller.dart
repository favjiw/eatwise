import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/user_service.dart';

class OnboardingController extends GetxController {
  final UserService _userService = UserService.to;

  final pageController = PageController();
  var pageIndex = 0.obs;

  var selectedGender = ''.obs;
  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  final availableAllergies = [
    'Kacang', 'Seafood', 'Susu Sapi', 'Telur',
    'Gandum', 'Kedelai', 'Ikan', 'Kerang'
  ];
  var selectedAllergies = <String>[].obs;

  var isLoading = false.obs;

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
      submitProfile();
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

  void selectGender(String gender) {
    selectedGender.value = gender;
  }

  void toggleAllergy(String allergy) {
    if (selectedAllergies.contains(allergy)) {
      selectedAllergies.remove(allergy);
    } else {
      selectedAllergies.add(allergy);
    }
  }

  void submitProfile() async {
    // Validasi sederhana
    if (selectedGender.value.isEmpty || ageController.text.isEmpty ||
        heightController.text.isEmpty || weightController.text.isEmpty) {
      Get.snackbar("Peringatan", "Mohon lengkapi semua data wajib (*)");
      return;
    }

    try {
      isLoading.value = true;

      UserModel userUpdate = UserModel(
        age: int.tryParse(ageController.text),
        gender: selectedGender.value,
        height: double.tryParse(heightController.text),
        weight: double.tryParse(weightController.text),
        allergies: selectedAllergies.toList(),
      );

      await _userService.updateProfile(userUpdate);

      Get.snackbar("Sukses", "Profil berhasil disimpan!");
      Get.offAllNamed('/botnavbar');

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