import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/community_controller.dart';

class CommunityView extends GetView<CommunityController> {
  const CommunityView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        title: Text("Komunitas", style: AppTextStyles.headingAppBar),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.h),
          child: _buildTabBar(),
        ),
      ),
      body: Obx(() => controller.tabIndex.value == 0
          ? _buildFeedTab()
          : _buildLeaderboardTab()),
      floatingActionButton: Obx(() => controller.tabIndex.value == 0
          ? FloatingActionButton(
        onPressed: () => _showCreatePostSheet(),
        backgroundColor: AppColors.mainBlack,
        child: const Icon(Icons.add_comment_rounded, color: Colors.white),
      )
          : const SizedBox()),
    );
  }

  Widget _buildTabBar() {
    return Container(
      color: AppColors.mainWhite,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
      child: Row(
        children: [
          _tabItem(0, "Terbaru"),
          SizedBox(width: 16.w),
          _tabItem(1, "Leaderboard"),
        ],
      ),
    );
  }

  Widget _tabItem(int index, String label) {
    return Obx(() {
      bool isSelected = controller.tabIndex.value == index;
      return GestureDetector(
        onTap: () => controller.tabIndex.value = index,
        child: Column(
          children: [
            Text(
              label,
              style: AppTextStyles.labelBold.copyWith(
                color: isSelected ? AppColors.primary : AppColors.lightGrey,
              ),
            ),
            if (isSelected)
              Container(
                margin: EdgeInsets.only(top: 4.h),
                height: 3.h,
                width: 20.w,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(2),
                ),
              )
          ],
        ),
      );
    });
  }

  Widget _buildFeedTab() {
    return Obx(() {
      if (controller.isLoading.value && controller.posts.isEmpty) {
        return const Center(child: CircularProgressIndicator(color: AppColors.primary));
      }

      return RefreshIndicator(
        onRefresh: () async => controller.fetchPosts(),
        child: ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: controller.posts.length,
          itemBuilder: (context, index) {
            final post = controller.posts[index];
            return Container(
              margin: EdgeInsets.only(bottom: 16.h),
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.mainWhite,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 18.r,
                        backgroundColor: AppColors.primary.withOpacity(0.1),
                        child: Image.asset('assets/images/male_ic.png', width: 20.w),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(post.userName ?? "User", style: AppTextStyles.labelBold),
                            Text("Baru saja", style: AppTextStyles.label.copyWith(fontSize: 10.sp, color: AppColors.lightGrey)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(post.content ?? "", style: AppTextStyles.label.copyWith(height: 1.5)),
                ],
              ),
            );
          },
        ),
      );
    });
  }

  Widget _buildLeaderboardTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16.w),
      itemCount: controller.leaderboard.length,
      itemBuilder: (context, index) {
        final entry = controller.leaderboard[index];
        bool isTop3 = (entry['rank'] as int) <= 3;

        return Container(
          margin: EdgeInsets.only(bottom: 12.h),
          padding: EdgeInsets.all(16.w),
          decoration: BoxDecoration(
            color: AppColors.mainWhite,
            borderRadius: BorderRadius.circular(16.r),
            border: isTop3 ? Border.all(color: AppColors.primary.withOpacity(0.3)) : null,
          ),
          child: Row(
            children: [
              Text("#${entry['rank']}", style: AppTextStyles.labelBold.copyWith(color: isTop3 ? AppColors.primary : AppColors.lightGrey)),
              SizedBox(width: 16.w),
              CircleAvatar(
                radius: 16.r,
                backgroundColor: AppColors.secondaryWhite,
                child: const Icon(Icons.person, size: 16, color: AppColors.lightGrey),
              ),
              SizedBox(width: 12.w),
              Expanded(child: Text(entry['name'].toString(), style: AppTextStyles.labelBold)),
              Text("${entry['points']} Poin", style: AppTextStyles.labelBold.copyWith(color: AppColors.primary)),
            ],
          ),
        );
      },
    );
  }

  void _showCreatePostSheet() {
    Get.bottomSheet(
      Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        child: Container(
          padding: EdgeInsets.all(20.w),
          decoration: BoxDecoration(
            color: AppColors.mainWhite,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Bagikan Progresmu", style: AppTextStyles.labelBold),
                SizedBox(height: 16.h),
                TextField(
                  controller: controller.postController,
                  maxLines: 4,
                  autofocus: true,
                  decoration: InputDecoration(
                    hintText: "Apa yang kamu makan hari ini? Bagikan ceritamu...",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none
                    ),
                    filled: true,
                    fillColor: AppColors.secondaryWhite,
                  ),
                ),
                SizedBox(height: 20.h),
                Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : CustomButton(
                  text: "Posting Thread",
                  textStyle: AppTextStyles.labelBold.copyWith(color: Colors.white),
                  onPressed: () => controller.createPost(),
                  backgroundColor: AppColors.mainBlack,
                  borderRadius: 64,
                )),
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
  }
}