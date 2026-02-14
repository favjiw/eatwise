import 'package:get/get.dart';
import '../controllers/food_detail_controller.dart';
import '../../../data/services/food_service.dart';

class FoodDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FoodDetailController>(() => FoodDetailController());
    Get.lazyPut<FoodService>(() => FoodService(), fenix: true);
  }
}