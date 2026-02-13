import 'package:eatwise/app/data/services/user_service.dart';
import 'package:get/get.dart';

import '../controllers/onboarding_controller.dart';

class OnboardingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<OnboardingController>(
      () => OnboardingController(),
    );
    Get.lazyPut<UserService>(
          () => UserService(),
    );
  }
}
