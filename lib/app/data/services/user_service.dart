import 'package:eatwise/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserService extends GetConnect {
  static UserService get to => Get.find<UserService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['BASE_URL'];

    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('token');
      if (token != null) {
        request.headers['Authorization'] = 'Bearer $token';
      }
      return request;
    });

    super.onInit();
  }

  // Update Profile (Onboarding)
  Future<UserModel> updateProfile(UserModel user) async {
    try {
      final response = await put('/profile', user.toJson());

      if (response.isOk) {
        final updatedData = response.body['data'];
        await _storage.write('user', updatedData); // Update cache lokal
        return UserModel.fromJson(updatedData);
      } else {
        throw Exception(response.body['message'] ?? 'Gagal update profil');
      }
    } catch (e) {
      rethrow;
    }
  }
}