import 'package:eatwise/app/modules/history/views/history_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';

import '../../home/views/home_view.dart';
import '../../community/views/community_view.dart';
import '../../profile/views/profile_view.dart';

import '../controllers/botnavbar_controller.dart';

class BotnavbarView extends GetView<BotnavbarController> {
  const BotnavbarView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = const [
      HomeView(),
      HistoryView(),
      SizedBox(),
      CommunityView(),
      ProfileView(),
    ];

    return Obx(
          () => Scaffold(
        backgroundColor: AppColors.secondaryWhite,
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: SizedBox(
          width: 1.sw,
          height: 100.h,
          child: Stack(
            children: [
              Positioned(
                bottom: 0,
                left: 0,
                child: Container(
                  width: 1.sw,
                  height: 80.h,
                  decoration: BoxDecoration(
                    color: AppColors.mainWhite,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32.r),
                      topRight: Radius.circular(32.r),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, -5),
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      // TAB 1: HOME
                      _buildNavItem(0, 'Home', 'home_act_ic.svg', 'home_inac_ic.svg'),

                      // TAB 2: DIARY
                      _buildNavItem(1, 'Jurnal', 'meals_act_ic.svg', 'meals_inac_ic.svg'),

                      // SPACER UNTUK TOMBOL TENGAH
                      SizedBox(width: 40.w),

                      // TAB 3: COMMUNITY
                      _buildNavItem(3, 'Sosial', 'stats_act_ic.svg', 'stats_inac_ic.svg'),

                      // TAB 4: PROFILE
                      _buildNavItem(4, 'Profil', 'profile_act_ic.svg', 'profile_inac_ic.svg'),
                    ],
                  ),
                ),
              ),

              Align(
                alignment: Alignment.topCenter,
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/scanner');
                  },
                  child: Container(
                    padding: EdgeInsets.all(6.w),
                    decoration: const BoxDecoration(
                      color: AppColors.mainWhite,
                      shape: BoxShape.circle,
                    ),
                    child: Container(
                      width: 56.w,
                      height: 56.h,
                      decoration: const BoxDecoration(
                        color: AppColors.mainBlack,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgPicture.asset(
                          'assets/images/scan_ic.svg',
                          width: 28.w,
                          height: 28.h,
                          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget Helper untuk Item Navigasi
  Widget _buildNavItem(int index, String label, String activeIcon, String inactiveIcon) {
    bool isActive = controller.currentIndex.value == index;
    return InkWell(
      onTap: () => controller.changePage(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SvgPicture.asset(
            'assets/images/${isActive ? activeIcon : inactiveIcon}',
            width: 24.w,
            height: 24.h,
            colorFilter: isActive
                ? const ColorFilter.mode(AppColors.primary, BlendMode.srcIn)
                : const ColorFilter.mode(AppColors.lightGrey, BlendMode.srcIn),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: isActive ? AppTextStyles.labelBold.copyWith(color: AppColors.primary, fontSize: 12.sp)
                : AppTextStyles.label.copyWith(color: AppColors.lightGrey, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}