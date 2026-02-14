import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../data/models/meal_log_model.dart';
import '../../../data/services/food_service.dart';

class HistoryController extends GetxController {
  final FoodService _foodService = FoodService.to;

  var isLoading = false.obs;
  var selectedDate = DateTime.now().obs;

  var logs = <MealLogModel>[].obs;
  var summary = {
    'total_calories': 0.0,
    'total_carbs': 0.0,
    'total_protein': 0.0,
    'total_fat': 0.0,
  }.obs;

  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  void fetchHistory() async {
    try {
      isLoading.value = true;
      String formattedDate = DateFormat('yyyy-MM-dd').format(selectedDate.value);

      var result = await _foodService.getDiary(formattedDate);
      logs.assignAll(result['logs']);
      var s = result['summary'];
      summary.value = {
        'total_calories': double.parse(s['total_calories'].toString()),
        'total_carbs': double.parse(s['total_carbs'].toString()),
        'total_protein': double.parse(s['total_protein'].toString()),
        'total_fat': double.parse(s['total_fat'].toString()),
      };

    } catch (e) {
      print("Error fetch history: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void changeDate(int days) {
    selectedDate.value = selectedDate.value.add(Duration(days: days));
    fetchHistory();
  }

  void pickDate() async {

  }
}