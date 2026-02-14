import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/onboarding_controller.dart';

class OnboardingView extends GetView<OnboardingController> {
  const OnboardingView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.mainWhite,
        appBar: AppBar(
          backgroundColor: AppColors.mainWhite,
          elevation: 0,
          leading: Obx(() => controller.pageIndex.value > 0
              ? IconButton(
            icon: const Icon(Icons.arrow_back_rounded, color: AppColors.mainBlack),
            onPressed: controller.previousPage,
          )
              : const SizedBox()
          ),
          title: Obx(() {
            int step = controller.pageIndex.value + 1;
            return Text(
              'Langkah $step dari 3',
              style: AppTextStyles.headingAppBar,
            );
          }),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Column(
            children: [
              // --- AREA KONTEN (PAGE VIEW) ---
              Expanded(
                child: PageView(
                  controller: controller.pageController,
                  physics: const NeverScrollableScrollPhysics(), // User harus tekan tombol lanjut
                  onPageChanged: controller.updatePageIndex,
                  children: [
                    _buildPageOne(),   // Gender & Umur
                    _buildPageTwo(),   // TB & BB
                    _buildPageThree(), // Alergi
                  ],
                ),
              ),

              // --- TOMBOL LANJUT ---
              Padding(
                padding: EdgeInsets.all(20.w),
                child: Obx(() => controller.isLoading.value
                    ? const CircularProgressIndicator(color: AppColors.primary)
                    : CustomButton(
                  text: controller.pageIndex.value == 2 ? 'Selesai' : 'Lanjut',
                  onPressed: controller.nextPage,
                  backgroundColor: AppColors.mainBlack,
                  borderRadius: 64,
                  textStyle: AppTextStyles.label.copyWith(color: Colors.white, fontSize: 16.sp),
                )
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // --- HALAMAN 1: GENDER & UMUR ---
  Widget _buildPageOne() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text("Siapa kamu?", style: AppTextStyles.onboardBigTitle),
          SizedBox(height: 8.h),
          Text("Bantu kami menghitung kebutuhan kalorimu.", style: AppTextStyles.label),

          SizedBox(height: 32.h),
          Text("Jenis Kelamin *", style: AppTextStyles.labelBold),
          SizedBox(height: 12.h),
          Row(
            children: [
              _genderCard('L', 'Pria', Icons.male),
              SizedBox(width: 16.w),
              _genderCard('P', 'Wanita', Icons.female),
            ],
          ),

          SizedBox(height: 32.h),
          CustomTextField(
            labelText: 'Umur (Tahun) *',
            hintText: 'Contoh: 25',
            controller: controller.ageController,
            keyboardType: TextInputType.number,
            prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primary),
          ),
        ],
      ),
    );
  }

  // --- HALAMAN 2: TINGGI & BERAT BADAN ---
  Widget _buildPageTwo() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text("Ukuran Tubuh", style: AppTextStyles.onboardBigTitle),
          SizedBox(height: 8.h),
          Text("Data ini penting untuk akurasi BMI.", style: AppTextStyles.label),

          SizedBox(height: 32.h),
          CustomTextField(
            labelText: 'Tinggi Badan (cm) *',
            hintText: 'Contoh: 170',
            controller: controller.heightController,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("cm", style: AppTextStyles.labelBold),
            ),
          ),

          SizedBox(height: 24.h),
          CustomTextField(
            labelText: 'Berat Badan (kg) *',
            hintText: 'Contoh: 65',
            controller: controller.weightController,
            keyboardType: TextInputType.number,
            suffixIcon: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("kg", style: AppTextStyles.labelBold),
            ),
          ),
        ],
      ),
    );
  }

  // --- HALAMAN 3: ALERGI ---
  Widget _buildPageThree() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.h),
          Text("Pantangan Makan", style: AppTextStyles.onboardBigTitle),
          SizedBox(height: 8.h),
          Text("Kami akan memberimu peringatan jika makanan mengandung bahan ini.", style: AppTextStyles.label),

          SizedBox(height: 32.h),
          Text("Pilih Alergi (Opsional)", style: AppTextStyles.labelBold),
          SizedBox(height: 16.h),

          Obx(() => Wrap(
            spacing: 10.w,
            runSpacing: 10.h,
            children: controller.availableAllergies.map((allergy) {
              final isSelected = controller.selectedAllergies.contains(allergy);
              return FilterChip(
                label: Text(allergy),
                selected: isSelected,
                selectedColor: AppColors.primary,
                checkmarkColor: Colors.white,
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : AppColors.mainBlack,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
                backgroundColor: AppColors.lightGrey.withOpacity(0.2),
                onSelected: (_) => controller.toggleAllergy(allergy),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                side: BorderSide.none,
              );
            }).toList(),
          )),
        ],
      ),
    );
  }

  // Widget Kartu Gender Kustom
  Widget _genderCard(String value, String label, IconData icon) {
    return Expanded(
      child: Obx(() {
        bool isSelected = controller.selectedGender.value == value;
        return GestureDetector(
          onTap: () => controller.selectGender(value),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 20.h),
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isSelected ? AppColors.primary : AppColors.lightGrey,
                width: 2,
              ),
            ),
            child: Column(
              children: [
                Icon(icon, size: 40.sp, color: isSelected ? AppColors.primary : AppColors.darkGrey),
                SizedBox(height: 8.h),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? AppColors.primary : AppColors.darkGrey,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}