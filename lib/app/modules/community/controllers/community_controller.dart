import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../data/models/post_model.dart';
import '../../../data/services/community_service.dart';

class CommunityController extends GetxController {
  final CommunityService _communityService = CommunityService.to;

  var tabIndex = 0.obs;
  var isLoading = false.obs;

  var posts = <PostModel>[].obs;
  final postController = TextEditingController();

  var leaderboard = [
    {'name': 'Budi Sehat', 'points': 1250, 'rank': 1},
    {'name': 'Ani Fit', 'points': 1100, 'rank': 2},
    {'name': 'Favian', 'points': 950, 'rank': 3},
    {'name': 'Siti Diet', 'points': 800, 'rank': 4},
  ].obs;

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  void fetchPosts() async {
    try {
      isLoading.value = true;
      var data = await _communityService.getFeed();
      posts.assignAll(data);
    } catch (e) {
      print(e);
    } finally {
      isLoading.value = false;
    }
  }

  void createPost() async {
    if (postController.text.isEmpty) return;

    try {
      isLoading.value = true;
      await _communityService.createPost(postController.text);
      postController.clear();
      Get.back();
      fetchPosts();
      Get.snackbar("Berhasil", "Thread kamu telah dipublikasikan");
    } catch (e) {
      Get.snackbar("Gagal", "Gagal mengirim postingan");
    } finally {
      isLoading.value = false;
    }
  }

  void deletePost(int id) async {
    try {
      await _communityService.deletePost(id);
      fetchPosts();
      Get.snackbar("Terhapus", "Postingan berhasil dihapus");
    } catch (e) {
      Get.snackbar("Gagal", "Tidak bisa menghapus postingan");
    }
  }
}