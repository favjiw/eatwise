import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../data/models/meal_log_model.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: controller.refreshData,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                SizedBox(height: 32.h),
                _buildSummaryCard(),
                SizedBox(height: 24.h),
                _buildMacroNutrients(),
                SizedBox(height: 32.h),

                Text(
                  "Jurnal Makan",
                  style: AppTextStyles.labelBold.copyWith(fontSize: 18.sp),
                ),
                SizedBox(height: 16.h),

                _buildMealSection(
                  title: "Sarapan",
                  logs: controller.breakfastLogs,
                  iconPath: 'assets/images/sunrise_ic.svg',
                  mealTypeKey: 'BREAKFAST',
                ),
                _buildMealSection(
                  title: "Makan Siang",
                  logs: controller.lunchLogs,
                  iconPath: 'assets/images/sun_ic.svg',
                  mealTypeKey: 'LUNCH',
                ),
                _buildMealSection(
                  title: "Makan Malam",
                  logs: controller.dinnerLogs,
                  iconPath: 'assets/images/sunset_ic.svg',
                  mealTypeKey: 'DINNER',
                ),
                _buildMealSection(
                  title: "Cemilan",
                  logs: controller.snackLogs,
                  iconPath: 'assets/images/recom_ic.svg',
                  mealTypeKey: 'SNACK',
                ),

                SizedBox(height: 80.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMealSection({
    required String title,
    required RxList<MealLogModel> logs,
    required String iconPath,
    required String mealTypeKey,
  }) {
    return Obx(() {
      bool isEmpty = logs.isEmpty;
      double sectionCalories = controller.getCaloriesForSection(logs);

      return Container(
        margin: EdgeInsets.only(bottom: 16.h),
        decoration: BoxDecoration(
          color: AppColors.mainWhite,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Theme(
          data: Theme.of(Get.context!).copyWith(dividerColor: Colors.transparent),
          child: ExpansionTile(
            tilePadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
            initiallyExpanded: !isEmpty,
            leading: Container(
              padding: EdgeInsets.all(8.w),
              decoration: BoxDecoration(
                color: AppColors.secondaryWhite,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: SvgPicture.asset(
                iconPath,
                width: 24.w,
                colorFilter: const ColorFilter.mode(AppColors.primary, BlendMode.srcIn),
              ),
            ),
            title: Text(title, style: AppTextStyles.labelBold),
            subtitle: Text(
              isEmpty ? "Belum dicatat" : "${sectionCalories.toInt()} kkal",
              style: AppTextStyles.label.copyWith(
                color: isEmpty ? AppColors.lightGrey : AppColors.primary,
                fontSize: 12.sp,
              ),
            ),
            trailing: InkWell(
              onTap: () {
                Get.toNamed('/search-food', arguments: {
                  'meal_type': mealTypeKey,
                  'date': '2026-02-14',
                });
              },
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.add, color: Colors.white, size: 20),
              ),
            ),
            children: [
              if (isEmpty)
                Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: Text(
                    "Yuk catat $title kamu!",
                    style: AppTextStyles.label.copyWith(color: AppColors.lightGrey, fontSize: 12.sp),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: logs.length,
                  itemBuilder: (context, index) {
                    final log = logs[index];
                    return Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        border: Border(top: BorderSide(color: AppColors.secondaryWhite)),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.h,
                            decoration: BoxDecoration(
                              color: AppColors.secondaryWhite,
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: const Icon(Icons.restaurant, color: AppColors.lightGrey, size: 20),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  log.food?.name ?? "Unknown Food",
                                  style: AppTextStyles.labelBold.copyWith(fontSize: 14.sp),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  "${log.portion} Porsi",
                                  style: AppTextStyles.label.copyWith(fontSize: 12.sp, color: AppColors.darkGrey),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "${((log.food?.calories ?? 0) * (log.portion ?? 1.0)).toInt()} kkal",
                            style: AppTextStyles.labelBold.copyWith(fontSize: 12.sp, color: AppColors.primary),
                          ),
                        ],
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Halo,', style: AppTextStyles.label.copyWith(fontSize: 16.sp)),
            Obx(() => Text(
              controller.user.value.name ?? 'Guest',
              style: AppTextStyles.labelBold.copyWith(fontSize: 22.sp),
            )),
          ],
        ),
        CircleAvatar(
          radius: 24.r,
          backgroundColor: AppColors.primary.withValues(alpha: 0.2),
          child: Image.asset('assets/images/male_ic.png', width: 28.w),
        ),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      width: 1.sw,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _infoColumn("Dimakan", controller.consumedCalories),
              _infoColumn("Target", controller.targetCalories),
            ],
          ),
          SizedBox(height: 20.h),
          Obx(() {
            double percent = controller.targetCalories.value > 0
                ? controller.consumedCalories.value / controller.targetCalories.value
                : 0.0;
            return ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: percent > 1 ? 1 : percent,
                minHeight: 12.h,
                backgroundColor: AppColors.secondaryWhite,
                color: percent > 1 ? Colors.red : AppColors.primary,
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _infoColumn(String label, RxDouble value) {
    return Obx(() => Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: AppTextStyles.label.copyWith(color: AppColors.darkGrey)),
        Text(
          "${value.value.toInt()} kkal",
          style: AppTextStyles.labelBold.copyWith(fontSize: 18.sp, color: AppColors.primary),
        ),
      ],
    ));
  }

  Widget _buildMacroNutrients() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _macroCard("Karbo", controller.consumedCarbs, "g", Colors.orange),
        _macroCard("Protein", controller.consumedProtein, "g", Colors.blue),
        _macroCard("Lemak", controller.consumedFat, "g", Colors.redAccent),
      ],
    );
  }

  Widget _macroCard(String label, RxDouble value, String unit, Color color) {
    return Container(
      width: 100.w,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 12.w),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 5)],
      ),
      child: Column(
        children: [
          Text(label, style: AppTextStyles.label.copyWith(fontSize: 12.sp)),
          SizedBox(height: 8.h),
          Obx(() => Text(
            "${value.value.toInt()}$unit",
            style: AppTextStyles.labelBold.copyWith(fontSize: 16.sp, color: color),
          )),
          SizedBox(height: 4.h),
          Container(
            height: 4.h,
            width: 40.w,
            decoration: BoxDecoration(
              color: color.withOpacity(0.3),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ),
    );
  }
}