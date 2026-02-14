import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/register_controller.dart';

class RegisterView extends GetView<RegisterController> {
  const RegisterView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: AppColors.mainWhite,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0.w),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  // SvgPicture.asset('assets/images/logo_img_sage.svg', height: 60.h),
                  Image.asset('assets/images/Logo-peanut.png'),
                  SizedBox(height: 40.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Daftar Akun Baru", style: AppTextStyles.labelBold),
                  ),
                  SizedBox(height: 8.h),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Mulai perjalanan hidup sehatmu bersama EatFit.", style: AppTextStyles.label),
                  ),

                  SizedBox(height: 32.h),

                  // FORM INPUT
                  CustomTextField(
                    labelText: 'Nama Lengkap',
                    hintText: 'Masukkan nama anda',
                    controller: controller.nameController,
                    prefixIcon: const Icon(Icons.person_outline, color: AppColors.primary),
                  ),
                  SizedBox(height: 20.h),
                  CustomTextField(
                    labelText: 'Email',
                    hintText: 'Masukkan email anda',
                    controller: controller.emailController,
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.alternate_email, color: AppColors.primary),
                  ),
                  SizedBox(height: 20.h),
                  Obx(() => CustomTextField(
                    labelText: 'Kata Sandi',
                    hintText: 'Masukkan kata sandi',
                    controller: controller.passwordController,
                    obscureText: controller.isObscure.value,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.primary),
                    suffixIcon: IconButton(
                      icon: Icon(controller.isObscure.value ? Icons.visibility_off : Icons.visibility),
                      onPressed: controller.toggleObscure,
                      color: AppColors.lightGrey,
                    ),
                  )),

                  SizedBox(height: 40.h),

                  // BUTTONS
                  Obx(() => controller.isLoading.value
                      ? const CircularProgressIndicator(color: AppColors.primary)
                      : CustomButton(
                    text: 'Daftar Sekarang',
                    textStyle: AppTextStyles.labelBold.copyWith(color: Colors.white),
                    onPressed: () => controller.register(),
                    backgroundColor: AppColors.mainBlack,
                    borderRadius: 64,
                  )),

                  SizedBox(height: 24.h),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Sudah punya akun?", style: AppTextStyles.label),
                      GestureDetector(
                        onTap: () => Get.back(), // Kembali ke Login
                        child: Text(" Masuk", style: AppTextStyles.labelBold.copyWith(color: AppColors.primary)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}