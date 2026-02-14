import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/search_food_controller.dart';
import '../../../data/models/food_model.dart';

class SearchFoodView extends GetView<SearchFoodController> {
  const SearchFoodView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.mainBlack, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(
          "Tambah ${controller.displayTitle}",
          style: AppTextStyles.labelBold.copyWith(fontSize: 18.sp),
        ),
        actions: [
          Obx(() {
            final count = controller.selectedItems.length;
            return count > 0
                ? Padding(
              padding: EdgeInsets.only(right: 8.w),
              child: TextButton(
                onPressed: controller.saveSelectedFoods,
                child: Text(
                  "Simpan ($count)",
                  style: AppTextStyles.labelBold.copyWith(color: AppColors.primary),
                ),
              ),
            )
                : const SizedBox();
          })
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(20.w),
            child: CustomTextField(
              controller: controller.searchController,
              hintText: "Cari nasi goreng, ayam, dll...",
              prefixIcon: const Icon(Icons.search, color: AppColors.lightGrey),
              onChanged: (val) => controller.search(val), // Live search
              suffixIcon: IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: AppColors.mainBlack),
                onPressed: ()=> Get.toNamed('/scanner'), // Shortcut ke Scanner
              ),
            ),
          ),

          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (controller.searchResults.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.fastfood_outlined, size: 64.sp, color: AppColors.lightGrey),
                      SizedBox(height: 16.h),
                      Text("Cari makananmu...", style: AppTextStyles.label.copyWith(color: AppColors.lightGrey)),
                    ],
                  ),
                );
              }

              return ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 20.w),
                itemCount: controller.searchResults.length,
                separatorBuilder: (_, __) => Divider(color: AppColors.lightGrey.withOpacity(0.2)),
                itemBuilder: (context, index) {
                  final food = controller.searchResults[index];
                  return _buildFoodItem(food);
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodItem(FoodModel food) {
    return Obx(() {
      bool isSelected = controller.isSelected(food.id!);
      double qty = controller.selectedItems[food.id] ?? 1.0;

      return AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary.withOpacity(0.05) : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: isSelected ? Border.all(color: AppColors.primary) : null,
        ),
        padding: EdgeInsets.all(12.w),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      Get.toNamed('/food-detail', arguments: {
                        'food': food,
                        'meal_type': controller.mealType,
                        'date': controller.date,
                      });
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(food.name ?? "-", style: AppTextStyles.labelBold),
                        SizedBox(height: 4.h),
                        Text("${food.calories?.toInt()} kkal / porsi", style: AppTextStyles.label.copyWith(fontSize: 12.sp, color: AppColors.darkGrey)),
                      ],
                    ),
                  ),
                ),

                Checkbox(
                  value: isSelected,
                  activeColor: AppColors.primary,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  onChanged: (val) => controller.toggleSelection(food),
                ),
              ],
            ),
            if (isSelected) ...[
              Divider(height: 20.h, color: AppColors.lightGrey.withOpacity(0.2)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Jumlah Porsi:", style: AppTextStyles.label.copyWith(fontSize: 12.sp)),
                  Row(
                    children: [
                      _qtyButton(Icons.remove, () => controller.updateQuantity(food.id!, -0.5)),
                      SizedBox(width: 12.w),
                      Text(qty.toStringAsFixed(1), style: AppTextStyles.labelBold),
                      SizedBox(width: 12.w),
                      _qtyButton(Icons.add, () => controller.updateQuantity(food.id!, 0.5)),
                    ],
                  )
                ],
              )
            ]
          ],
        ),
      );
    });
  }

  Widget _qtyButton(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.primary.withOpacity(0.1),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16.sp, color: AppColors.primary),
      ),
    );
  }
}