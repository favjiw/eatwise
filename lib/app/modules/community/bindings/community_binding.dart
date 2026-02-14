import 'package:get/get.dart';
import '../controllers/community_controller.dart';
import '../../../data/services/community_service.dart';
import '../../../data/services/user_service.dart';

class CommunityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CommunityController>(() => CommunityController());
    Get.lazyPut<CommunityService>(() => CommunityService(), fenix: true);
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
  }
}