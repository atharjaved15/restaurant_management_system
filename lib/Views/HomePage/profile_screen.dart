import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:restaurant_management_system/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(Icons.person, size: 100.sp, color: AppColors.primaryColor),
            SizedBox(height: 20.h),
            Text(
              'John Doe',
              style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold),
            ),
            Text(
              'john.doe@example.com',
              style: TextStyle(fontSize: 16.sp, color: Colors.grey),
            ),
            SizedBox(height: 30.h),
            ElevatedButton(
              onPressed: () {
                // Edit profile logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.secondaryColor,
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: const Text('Edit Profile'),
            ),
            SizedBox(height: 20.h),
            ElevatedButton(
              onPressed: () {
                // Logout logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: const Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
