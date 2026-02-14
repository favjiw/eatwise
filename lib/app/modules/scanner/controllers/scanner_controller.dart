import 'package:get/get.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../../../data/services/food_service.dart';

class ScannerController extends GetxController {
  final FoodService _foodService = FoodService.to;
  final MobileScannerController scannerController = MobileScannerController();

  var isLoading = false.obs;

  void onDetect(BarcodeCapture capture) async {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final String code = barcode.rawValue!;
        scannerController.stop();
        await fetchScannedFood(code);
        break;
      }
    }
  }

  Future<void> fetchScannedFood(String code) async {
    try {
      isLoading.value = true;
      final food = await _foodService.scanBarcode(code);

      if (food != null) {
        Get.offNamed('/food-detail', arguments: food);
      }
    } catch (e) {
      Get.snackbar("Gagal", "Produk tidak ditemukan di database atau OpenFoodFacts");
      scannerController.start();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    scannerController.dispose();
    super.onClose();
  }
}