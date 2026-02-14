import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/food_model.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/food_service.dart';

class FoodDetailController extends GetxController {
  final FoodService _foodService = FoodService.to;
  final GetStorage _storage = GetStorage();

  // Data State
  late FoodModel food;
  late String mealType;
  late String date;

  var portion = 1.0.obs;
  var isLoading = false.obs;

  // State Alergi
  var hasAllergyRisk = false.obs;
  var detectedAllergies = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Ambil data dari argumen (dikirim dari Search atau Scanner)
    food = Get.arguments['food'];
    mealType = Get.arguments['meal_type'] ?? 'BREAKFAST';
    date = Get.arguments['date'] ?? DateTime.now().toString().split(' ')[0];

    checkAllergyRisk();
  }

  void checkAllergyRisk() {
    // 1. Ambil data alergi user dari storage
    final userData = _storage.read('user');
    if (userData == null) return;

    UserModel user = UserModel.fromJson(userData);
    List<String> userAllergies = user.allergies ?? [];

    if (userAllergies.isEmpty || food.ingredients == null) return;

    // 2. Bandingkan dengan ingredients makanan (case insensitive)
    String ingredients = food.ingredients!.toLowerCase();

    for (var allergy in userAllergies) {
      if (ingredients.contains(allergy.toLowerCase())) {
        hasAllergyRisk.value = true;
        detectedAllergies.add(allergy);
      }
    }
  }

  void updatePortion(double value) {
    if (portion.value + value >= 0.1) {
      portion.value += value;
    }
  }

  void addToDiary() async {
    try {
      isLoading.value = true;
      await _foodService.addToDiary(food.id!, mealType, portion.value, date);

      Get.back(result: true);
      Get.snackbar("Sukses", "${food.name} berhasil dicatat!");
    } catch (e) {
      Get.snackbar("Gagal", e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}