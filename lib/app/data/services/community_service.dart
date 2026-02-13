import 'package:eatwise/app/data/models/post_model.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CommunityService extends GetConnect {
  static CommunityService get to => Get.find<CommunityService>();
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

  Future<List<PostModel>> getFeed() async {
    final response = await get('/community');
    if (response.isOk) {
      final List data = response.body['data'];
      return data.map((e) => PostModel.fromJson(e)).toList();
    }
    return [];
  }

  Future<void> createPost(String content) async {
    final response = await post('/community', {'content': content});
    if (!response.isOk) throw Exception('Gagal memposting');
  }

  Future<void> deletePost(int id) async {
    final response = await delete('/community/$id');
    if (!response.isOk) throw Exception('Gagal menghapus postingan');
  }
}