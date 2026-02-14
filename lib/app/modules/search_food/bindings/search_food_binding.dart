import 'package:get/get.dart';
import '../controllers/search_food_controller.dart';

class SearchFoodBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SearchFoodController>(
          () => SearchFoodController(),
    );
  }
}