import 'package:get/get.dart';
import '../controllers/register_controller.dart';
import '../../../data/services/auth_service.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(() => RegisterController());
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}