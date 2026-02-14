import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../shared/constants/colors.dart';
import '../../../shared/constants/text_style.dart';
import '../controllers/history_controller.dart';

class HistoryView extends GetView<HistoryController> {
  const HistoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondaryWhite,
      appBar: AppBar(
        backgroundColor: AppColors.mainWhite,
        elevation: 0,
        centerTitle: true,
        title: Text('Riwayat Makan', style: AppTextStyles.headingAppBar),
      ),
      body: Column(
        children: [
          _buildDateSelector(),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              if (controller.logs.isEmpty) {
                return _buildEmptyState();
              }

              return ListView(
                padding: EdgeInsets.all(20.w),
                children: [
                  _buildDailySummaryCard(),
                  SizedBox(height: 24.h),
                  Text("Daftar Konsumsi", style: AppTextStyles.labelBold),
                  SizedBox(height: 12.h),
                  ...controller.logs.map((log) => _buildHistoryItem(log)).toList(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      color: AppColors.mainWhite,
      padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 20.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primary),
            onPressed: () => controller.changeDate(-1),
          ),
          Obx(() => Text(
            DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(controller.selectedDate.value),
            style: AppTextStyles.labelBold.copyWith(color: AppColors.primary),
          )),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: AppColors.primary),
            onPressed: () => controller.changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildDailySummaryCard() {
    final s = controller.summary;
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10)],
      ),
      child: Column(
        children: [
          Text("Total Nutrisi Hari Ini", style: AppTextStyles.label.copyWith(color: AppColors.darkGrey)),
          SizedBox(height: 12.h),
          Text("${s['total_calories']?.toInt()} kkal", style: AppTextStyles.labelBold.copyWith(color: AppColors.primary)),
          SizedBox(height: 20.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _macroSmall("Karbo", "${s['total_carbs']?.toInt()}g", Colors.orange),
              _macroSmall("Protein", "${s['total_protein']?.toInt()}g", Colors.blue),
              _macroSmall("Lemak", "${s['total_fat']?.toInt()}g", Colors.redAccent),
            ],
          )
        ],
      ),
    );
  }

  Widget _macroSmall(String label, String value, Color color) {
    return Column(
      children: [
        Text(label, style: AppTextStyles.label.copyWith(fontSize: 10.sp)),
        Text(value, style: AppTextStyles.labelBold.copyWith(fontSize: 14.sp, color: color)),
      ],
    );
  }

  Widget _buildHistoryItem(log) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.mainWhite,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(color: AppColors.secondaryWhite, shape: BoxShape.circle),
            child: Icon(Icons.restaurant, size: 20.sp, color: AppColors.primary),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(log.food?.name ?? "-", style: AppTextStyles.labelBold),
                Text("${log.mealType} • ${log.portion} Porsi",
                    style: AppTextStyles.label.copyWith(fontSize: 10.sp, color: AppColors.lightGrey)),
              ],
            ),
          ),
          Text("${((log.food?.calories ?? 0) * log.portion).toInt()} kkal",
              style: AppTextStyles.labelBold.copyWith(color: AppColors.primary)),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history_toggle_off_rounded, size: 64.sp, color: AppColors.lightGrey),
          SizedBox(height: 16.h),
          Text("Tidak ada riwayat makan di tanggal ini", style: AppTextStyles.label.copyWith(color: AppColors.lightGrey)),
        ],
      ),
    );
  }
}