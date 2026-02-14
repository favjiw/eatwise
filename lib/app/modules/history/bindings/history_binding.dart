import 'package:get/get.dart';
import '../controllers/history_controller.dart';
import '../../../data/services/food_service.dart';

class HistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HistoryController>(() => HistoryController());
    Get.lazyPut<FoodService>(() => FoodService(), fenix: true);
  }
}