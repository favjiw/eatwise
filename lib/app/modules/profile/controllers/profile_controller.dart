import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import '../../../data/models/user_model.dart';
import '../../../data/services/auth_service.dart';

class ProfileController extends GetxController {
  final AuthService _authService = AuthService.to;
  final GetStorage _storage = GetStorage();

  var user = UserModel().obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  void loadUserData() {
    var data = _storage.read('user');
    if (data != null) {
      user.value = UserModel.fromJson(data);
    }
  }

  void logout() async {
    try {
      isLoading.value = true;
      await _authService.logout();
      Get.offAllNamed('/login');
    } catch (e) {
      _storage.erase();
      Get.offAllNamed('/login');
    } finally {
      isLoading.value = false;
    }
  }
}