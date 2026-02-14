import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

// Pastikan path import ini sesuai dengan struktur folder EatFit Anda
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/custom_button.dart';
import '../../../shared/widgets/custom_text_field.dart';
import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

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
              child: SizedBox(
                height: MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top - 40.h,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height * 0.1),
                        // SvgPicture.asset('assets/images/logo_img_sage.svg'),
                        Image.asset('assets/images/Logo-peanut.png'),
                      ],
                    ),

                    Form(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          CustomTextField(
                            labelText: 'Email',
                            hintText: 'Masukkan email anda',
                            controller: controller.emailController,
                            keyboardType: TextInputType.emailAddress,
                            prefixIcon: const Icon(
                              Icons.alternate_email,
                              color: AppColors.primary,
                            ),
                            textInputAction: TextInputAction.next,
                          ),
                          SizedBox(height: 24.h),
                          Obx(
                                () => CustomTextField(
                              labelText: 'Kata Sandi',
                              hintText: 'Masukkan kata sandi anda',
                              keyboardType: TextInputType.visiblePassword,
                              controller: controller.passwordController,
                              obscureText: controller.isObscure.value,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: AppColors.primary,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  controller.isObscure.value
                                      ? Icons.visibility_off_rounded
                                      : Icons.visibility_rounded,
                                  color: AppColors.primary,
                                ),
                                onPressed: controller.toggleObscure,
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          // GestureDetector(
                          //   onTap: () => Get.toNamed('/forgot-password'),
                          //   child: Text(
                          //     'Lupa kata sandi?',
                          //     style: AppTextStyles.label.copyWith(
                          //       color: AppColors.mainBlack,
                          //       fontSize: 12.sp,
                          //     ),
                          //   ),
                          // ),
                        ],
                      ),
                    ),

                    Column(
                      children: [
                        Obx(
                              () => controller.isLoading.value
                              ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.primary,
                            ),
                          )
                              : CustomButton(
                            text: 'Masuk',
                            onPressed: () => controller.login(),
                            backgroundColor: AppColors.mainBlack,
                            borderRadius: 64,
                            textStyle: AppTextStyles.label.copyWith(
                              color: AppColors.mainWhite,
                              fontSize: 18.sp,
                            ),
                          ),
                        ),
                        SizedBox(height: 24.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Tidak punya akun?',
                              style: AppTextStyles.label.copyWith(
                                color: AppColors.mainBlack,
                                fontSize: 12.sp,
                              ),
                            ),
                            GestureDetector(
                              onTap: () => Get.toNamed('/register'),
                              child: Text(
                                ' Daftar Akun',
                                style: AppTextStyles.labelBold.copyWith(
                                  decoration: TextDecoration.underline,
                                  fontSize: 12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 20.h),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}