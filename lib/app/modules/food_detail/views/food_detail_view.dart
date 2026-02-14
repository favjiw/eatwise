import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_button.dart';
import '../controllers/food_detail_controller.dart';

class FoodDetailView extends GetView<FoodDetailController> {
  const FoodDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final food = controller.food;

    return Scaffold(
      backgroundColor: AppColors.mainWhite,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppColors.mainBlack),
          onPressed: () => Get.back(),
        ),
        title: Text("Detail Nutrisi", style: AppTextStyles.labelBold),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 200.h,
              width: 1.sw,
              margin: EdgeInsets.symmetric(horizontal: 20.w),
              decoration: BoxDecoration(
                color: AppColors.secondaryWhite,
                borderRadius: BorderRadius.circular(24.r),
              ),
              child: const Icon(Icons.fastfood_rounded, size: 80, color: AppColors.lightGrey),
            ),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(food.name ?? "-", style: AppTextStyles.labelBold),
                  SizedBox(height: 4.h),
                  Text("Barcode: ${food.barcode ?? '-'}",
                      style: AppTextStyles.label.copyWith(color: AppColors.lightGrey, fontSize: 12.sp)),

                  SizedBox(height: 24.h),

                  Obx(() => controller.hasAllergyRisk.value
                      ? Container(
                    width: 1.sw,
                    padding: EdgeInsets.all(16.w),
                    margin: EdgeInsets.only(bottom: 24.h),
                    decoration: BoxDecoration(
                      color: Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(color: Colors.red.withOpacity(0.3)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Text(
                            "Peringatan! Makanan ini mengandung bahan alergi Anda: ${controller.detectedAllergies.join(', ')}",
                            style: AppTextStyles.labelBold.copyWith(color: Colors.red, fontSize: 12.sp),
                          ),
                        ),
                      ],
                    ),
                  )
                      : const SizedBox()),

                  Text("Informasi Nutrisi", style: AppTextStyles.labelBold),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildNutrientInfo("Kalori", "${food.calories?.toInt()}", "kkal", AppColors.primary),
                      _buildNutrientInfo("Karbo", "${food.carbs?.toInt()}", "g", Colors.orange),
                      _buildNutrientInfo("Protein", "${food.protein?.toInt()}", "g", Colors.blue),
                      _buildNutrientInfo("Lemak", "${food.fat?.toInt()}", "g", Colors.redAccent),
                    ],
                  ),

                  SizedBox(height: 32.h),

                  Text("Komposisi Bahan", style: AppTextStyles.labelBold),
                  SizedBox(height: 8.h),
                  Text(
                    food.ingredients ?? "Informasi komposisi tidak tersedia.",
                    style: AppTextStyles.label.copyWith(color: AppColors.darkGrey, height: 1.5),
                  ),

                  SizedBox(height: 40.h),

                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                      decoration: BoxDecoration(
                        color: AppColors.secondaryWhite,
                        borderRadius: BorderRadius.circular(30.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          _qtyBtn(Icons.remove, () => controller.updatePortion(-0.5)),
                          SizedBox(width: 20.w),
                          Obx(() => Text("${controller.portion.value} Porsi", style: AppTextStyles.labelBold)),
                          SizedBox(width: 20.w),
                          _qtyBtn(Icons.add, () => controller.updatePortion(0.5)),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 24.h),

                  Obx(() => controller.isLoading.value
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : CustomButton(
                    text: "Tambah ke Jurnal",
                    onPressed: controller.addToDiary,
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                  )),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNutrientInfo(String label, String value, String unit, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 12.sp, color: AppColors.darkGrey)),
        SizedBox(height: 4.h),
        Text(value, style: AppTextStyles.labelBold.copyWith(fontSize: 16.sp, color: color)),
        Text(unit, style: AppTextStyles.label.copyWith(fontSize: 10.sp, color: AppColors.lightGrey)),
      ],
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Icon(icon, color: AppColors.primary, size: 24.sp),
    );
  }
}