import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../../../shared/widgets/personal_info_card.dart';
import '../../../shared/widgets/profile_menu_item.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.secondaryWhite,
        elevation: 0,
        centerTitle: true,
        title: Text('Profil Saya', style: AppTextStyles.headingAppBar),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Obx(() {
          final u = controller.user.value;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: AppColors.mainWhite,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        CircleAvatar(
                          radius: 35.r,
                          backgroundColor: AppColors.primary.withOpacity(0.1),
                          child: Image.asset('assets/images/male_ic.png', width: 45.w),
                        ),
                        OutlinedButton(
                          onPressed: () => Get.snackbar("Info", "Fitur Edit sedang dikembangkan"),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                          ),
                          child: Text('Edit Info', style: AppTextStyles.label.copyWith(color: AppColors.primary, fontSize: 12.sp)),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(u.name ?? 'Guest User', style: AppTextStyles.labelBold.copyWith(fontSize: 20.sp)),
                          Text(u.email ?? '-', style: AppTextStyles.label.copyWith(color: AppColors.lightGrey)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  PersonalInfoCard(
                    label: 'Tinggi',
                    value: (u.height ?? 0).toInt().toString(),
                    unit: 'CM',
                  ),
                  PersonalInfoCard(
                    label: 'Berat',
                    value: (u.weight ?? 0).toInt().toString(),
                    unit: 'KG',
                  ),
                  PersonalInfoCard(
                    label: 'Umur',
                    value: (u.age ?? 0).toString(),
                    unit: 'Thn',
                  ),
                ],
              ),

              SizedBox(height: 24.h),

              Text("Pengaturan Akun", style: AppTextStyles.labelBold),
              SizedBox(height: 8.h),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.mainWhite,
                  borderRadius: BorderRadius.circular(16.r),
                ),
                child: Column(
                  children: [
                    ProfileMenuItem(
                      icon: Icons.notifications_none_rounded,
                      label: 'Notifikasi',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.security_rounded,
                      label: 'Keamanan',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.help_outline_rounded,
                      label: 'Bantuan',
                      onTap: () {},
                    ),
                    ProfileMenuItem(
                      icon: Icons.logout_rounded,
                      label: 'Keluar Akun',
                      labelColor: Colors.red,
                      iconColor: Colors.red,
                      onTap: () => controller.logout(),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 40.h),
              Center(
                child: Text(
                  "EatFit v1.0.0",
                  style: AppTextStyles.label.copyWith(color: AppColors.lightGrey, fontSize: 10.sp),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}