import 'package:get/get.dart';
import '../controllers/scanner_controller.dart';
import '../../../data/services/food_service.dart';

class ScannerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScannerController>(() => ScannerController());
    Get.lazyPut<FoodService>(() => FoodService(), fenix: true);
  }
}