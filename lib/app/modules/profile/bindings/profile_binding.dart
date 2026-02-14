import 'package:get/get.dart';
import '../controllers/profile_controller.dart';
import '../../../data/services/auth_service.dart';

class ProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);
  }
}