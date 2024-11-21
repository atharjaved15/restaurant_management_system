import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/Staff%20Controllers/staff_controller.dart';
import 'package:restaurant_management_system/colors.dart';

class StaffProfileScreen extends StatelessWidget {
  final StaffController staffController = Get.find();

  StaffProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.accentColor,
        title: Text(
          "Profile",
          style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Obx(() {
        // Check if currentStaff is null
        if (staffController.currentStaff.value == null) {
          return Center(child: CircularProgressIndicator());
        }

        final staff = staffController.currentStaff.value!; // Non-null assertion

        return Padding(
          padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 16.w : 32.w, vertical: 24.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Icon
              CircleAvatar(
                radius: isMobile ? 50.r : 50.r,
                backgroundColor: AppColors.accentColor,
                child: Icon(
                  Icons.person,
                  size: isMobile ? 60.r : 100.r,
                  color: AppColors.surfaceColor,
                ),
              ),
              SizedBox(height: 20.h),

              // User Name
              Text(
                staff.name ?? "Unknown Name",
                style: TextStyle(
                  fontSize: isMobile ? 18.sp : 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textColor,
                ),
              ),
              SizedBox(height: 8.h),

              // User Email
              Text(
                staff.email ?? "Unknown Email",
                style: TextStyle(
                  fontSize: isMobile ? 14.sp : 14.sp,
                  color: AppColors.textColor.withOpacity(0.7),
                ),
              ),
              SizedBox(height: 24.h),

              // Total Earnings
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                color: AppColors.surfaceColor,
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Earnings",
                        style: TextStyle(
                          fontSize: isMobile ? 14.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        "\$${staff.amountEarned?.toStringAsFixed(2) ?? "0.00"}",
                        style: TextStyle(
                          fontSize: isMobile ? 14.sp : 14.sp,
                          color: AppColors.successColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Total Profit
              Card(
                margin: EdgeInsets.symmetric(vertical: 8.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                color: AppColors.surfaceColor,
                elevation: 4,
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Total Profit Made",
                        style: TextStyle(
                          fontSize: isMobile ? 14.sp : 14.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textColor,
                        ),
                      ),
                      Text(
                        "\$${staff.profit?.toStringAsFixed(2) ?? "0.00"}",
                        style: TextStyle(
                          fontSize: isMobile ? 14.sp : 14.sp,
                          color: AppColors.warningColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Spacer to push the sign-out button down
              const Spacer(),

              // Sign Out Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    // Add your sign-out logic here
                    Get.snackbar(
                      "Sign Out",
                      "You have successfully signed out.",
                      backgroundColor: AppColors.primaryColor,
                      colorText: Colors.white,
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.errorColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                  ),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(
                      fontSize: isMobile ? 16.sp : 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
