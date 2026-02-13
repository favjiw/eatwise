import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

import '../../../data/models/user_model.dart';
import '../../../data/models/meal_log_model.dart';
import '../../../data/services/food_service.dart';

class HomeController extends GetxController {
  final FoodService _foodService = FoodService.to;
  final GetStorage _storage = GetStorage();

  var isLoading = false.obs;
  var user = UserModel().obs;

  var consumedCalories = 0.0.obs;
  var consumedCarbs = 0.0.obs;
  var consumedProtein = 0.0.obs;
  var consumedFat = 0.0.obs;
  var targetCalories = 2000.0.obs;

  var breakfastLogs = <MealLogModel>[].obs;
  var lunchLogs = <MealLogModel>[].obs;
  var dinnerLogs = <MealLogModel>[].obs;
  var snackLogs = <MealLogModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
    fetchDailySummary();
  }

  void loadUserData() {
    var userData = _storage.read('user');
    if (userData != null) {
      user.value = UserModel.fromJson(userData);
      calculateTargetCalories();
    }
  }

  void calculateTargetCalories() {
    double weight = user.value.weight ?? 60;
    double height = user.value.height ?? 170;
    int age = user.value.age ?? 25;
    double bmr = (10 * weight) + (6.25 * height) - (5 * age) + (user.value.gender == 'L' ? 5 : -161);
    targetCalories.value = bmr * 1.2;
  }

  void fetchDailySummary() async {
    try {
      isLoading.value = true;
      String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

      var result = await _foodService.getDiary(today);

      var summary = result['summary'];
      consumedCalories.value = double.parse(summary['total_calories'].toString());
      consumedCarbs.value = double.parse(summary['total_carbs'].toString());
      consumedProtein.value = double.parse(summary['total_protein'].toString());
      consumedFat.value = double.parse(summary['total_fat'].toString());

      List<MealLogModel> allLogs = (result['logs'] as List).cast<MealLogModel>();

      breakfastLogs.assignAll(allLogs.where((e) => e.mealType == 'BREAKFAST').toList());
      lunchLogs.assignAll(allLogs.where((e) => e.mealType == 'LUNCH').toList());
      dinnerLogs.assignAll(allLogs.where((e) => e.mealType == 'DINNER').toList());
      snackLogs.assignAll(allLogs.where((e) => e.mealType == 'SNACK').toList());

    } catch (e) {
      print("Error fetching home data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async => fetchDailySummary();

  double getCaloriesForSection(List<MealLogModel> logs) {
    double total = 0;
    for (var log in logs) {
      if (log.food != null) {
        total += (log.food!.calories! * log.portion!);
      }
    }
    return total;
  }
}