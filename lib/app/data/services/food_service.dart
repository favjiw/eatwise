import 'package:eatwise/app/data/models/food_model.dart';
import 'package:eatwise/app/data/models/meal_log_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class FoodService extends GetConnect {
  static FoodService get to => Get.find<FoodService>();
  final _storage = GetStorage();

  @override
  void onInit() {
    httpClient.baseUrl = dotenv.env['BASE_URL'];
    httpClient.addRequestModifier<dynamic>((request) {
      final token = _storage.read('token');
      if (token != null) request.headers['Authorization'] = 'Bearer $token';
      return request;
    });
    super.onInit();
  }

  // Cari makanan via Teks
  Future<List<FoodModel>> searchFood(String query) async {
    final response = await get('/foods/search', query: {'k': query});
    if (response.isOk) {
      final List data = response.body['data'];
      return data.map((e) => FoodModel.fromJson(e)).toList();
    }
    return [];
  }

  // Cari makanan via Barcode
  Future<FoodModel> scanBarcode(String code) async {
    final response = await get('/foods/scan', query: {'code': code});
    if (response.isOk) {
      return FoodModel.fromJson(response.body['data']);
    } else {
      throw Exception('Produk tidak ditemukan');
    }
  }

  // Ambil History Diary
  Future<Map<String, dynamic>> getDiary(String date) async {
    final response = await get('/diary', query: {'date': date});
    if (response.isOk) {
      final List logs = response.body['data'];
      return {
        'summary': response.body['summary'],
        'logs': logs.map((e) => MealLogModel.fromJson(e)).toList(),
      };
    }
    throw Exception('Gagal memuat diary');
  }

  // Tambah ke Diary
  Future<void> addToDiary(int foodId, String mealType, double portion, String date) async {
    final response = await post('/diary', {
      'food_id': foodId,
      'meal_type': mealType,
      'portion': portion,
      'date': date,
    });
    if (!response.isOk) throw Exception('Gagal mencatat makanan');
  }
}