import 'package:eatwise/app/data/models/user_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService extends GetConnect {
  static AuthService get to => Get.find<AuthService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['BASE_URL'];
    httpClient.timeout = const Duration(seconds: 30);
    super.onInit();
  }

  // LOGIN
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await post('/login', {
        'email': email,
        'password': password,
      });

      if (response.isOk) {
        final token = response.body['access_token'];
        final userData = response.body['data'];

        await _storage.write('token', token);
        await _storage.write('user', userData);

        return UserModel.fromJson(userData);
      } else {
        throw Exception(response.body['message'] ?? 'Gagal Login');
      }
    } catch (e) {
      rethrow;
    }
  }

  // REGISTER
  Future<UserModel> register(String name, String email, String password) async {
    try {
      final response = await post('/register', {
        'name': name,
        'email': email,
        'password': password,
      });

      if (response.isOk) {
        final token = response.body['access_token'];
        final userData = response.body['data'];

        await _storage.write('token', token);
        await _storage.write('user', userData);

        return UserModel.fromJson(userData);
      } else {
        throw Exception(response.body['message'] ?? 'Gagal Daftar');
      }
    } catch (e) {
      rethrow;
    }
  }

  // LOGOUT
  Future<void> logout() async {
    final token = _storage.read('token');
    await post('/logout', {}, headers: {'Authorization': 'Bearer $token'});
    _storage.erase();
  }
}