import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/food_model.dart';
import '../../../data/services/food_service.dart';

class SearchFoodController extends GetxController {
  final FoodService _foodService = FoodService.to;

  final searchController = TextEditingController();
  var searchResults = <FoodModel>[].obs;
  var isLoading = false.obs;
  var selectedItems = <int, double>{}.obs;

  late String mealType;
  late String date;

  final Map<String, String> mealTypeLabels = {
    'BREAKFAST': 'Sarapan',
    'LUNCH': 'Makan Siang',
    'DINNER': 'Makan Malam',
    'SNACK': 'Cemilan',
  };

  String get displayTitle => mealTypeLabels[mealType] ?? mealType;

  @override
  void onInit() {
    super.onInit();

    date = DateFormat('yyyy-MM-dd').format(DateTime.now());

    var args = Get.arguments;
    if (args is Map) {
      mealType = args['meal_type'] ?? 'BREAKFAST';
      if (args['date'] != null) date = args['date'];
    } else if (args is String) {
      mealType = args;
    } else {
      mealType = 'BREAKFAST';
    }
  }

  void search(String query) async {
    if (query.isEmpty) {
      searchResults.clear();
      return;
    }
    try {
      isLoading.value = true;
      var results = await _foodService.searchFood(query);
      searchResults.assignAll(results);
    } catch (e) {
      debugPrint(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  bool isSelected(int foodId) => selectedItems.containsKey(foodId);

  void toggleSelection(FoodModel food) {
    if (isSelected(food.id!)) {
      selectedItems.remove(food.id);
    } else {
      selectedItems[food.id!] = 1.0;
    }
  }

  void updateQuantity(int foodId, double delta) {
    if (selectedItems.containsKey(foodId)) {
      double current = selectedItems[foodId]!;
      double newValue = current + delta;
      if (newValue >= 0.1) {
        selectedItems[foodId] = newValue;
      }
    }
  }

  void saveSelectedFoods() async {
    if (selectedItems.isEmpty) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator(color: Colors.white)),
        barrierDismissible: false,
      );

      for (var entry in selectedItems.entries) {
        await _foodService.addToDiary(entry.key, mealType, entry.value, date);
      }

      Get.back();
      Get.back(result: true);
      Get.snackbar("Berhasil", "Catatan makan disimpan");
    } catch (e) {
      Get.back();
      Get.snackbar("Gagal", e.toString());
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}