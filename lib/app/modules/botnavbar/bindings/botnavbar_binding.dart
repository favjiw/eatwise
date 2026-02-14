import 'package:eatwise/app/modules/community/controllers/community_controller.dart';
import 'package:eatwise/app/modules/food/controllers/food_controller.dart';
import 'package:eatwise/app/modules/history/controllers/history_controller.dart';
import 'package:eatwise/app/modules/profile/controllers/profile_controller.dart';
import 'package:get/get.dart';

// Import Controllers
import '../controllers/botnavbar_controller.dart';
import '../../home/controllers/home_controller.dart';

// Import Services
import '../../../data/services/user_service.dart';
import '../../../data/services/food_service.dart';
import '../../../data/services/community_service.dart';
import '../../../data/services/auth_service.dart';

class BotnavbarBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserService>(() => UserService(), fenix: true);
    Get.lazyPut<FoodService>(() => FoodService(), fenix: true);
    Get.lazyPut<CommunityService>(() => CommunityService(), fenix: true);
    Get.lazyPut<AuthService>(() => AuthService(), fenix: true);

    Get.lazyPut<BotnavbarController>(() => BotnavbarController(), fenix: true);

    // Home Tab
    Get.lazyPut<HomeController>(() => HomeController(), fenix: true);

    // Diary/Food Tab
    Get.lazyPut<FoodController>(() => FoodController(), fenix: true);

    // Community Tab
    Get.lazyPut<CommunityController>(() => CommunityController(), fenix: true);

    // Profile Tab
    Get.lazyPut<ProfileController>(() => ProfileController(), fenix: true);

    // history
    Get.lazyPut<HistoryController>(() => HistoryController(), fenix: true);
  }
}