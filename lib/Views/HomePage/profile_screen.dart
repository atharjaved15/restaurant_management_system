import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/home_screen_controller.dart';
import 'package:restaurant_management_system/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final HomeController homeController = Get.put(HomeController());
  @override
  void initState() async {
    super.initState();
    // Initialize data or perform operations when the screen loads

    await homeController
        .fetchUserData(FirebaseAuth.instance.currentUser!.uid.toString());
  }

  @override
  Widget build(BuildContext context) {
    // Accessing the HomeController for user data

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.secondaryColor,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w), // Use ScreenUtil for responsiveness
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Icon
              CircleAvatar(
                radius: 50.sp, // Slightly smaller size for better balance
                backgroundColor: AppColors.primaryColor,
                child: Icon(
                  Icons.person,
                  size: 50.sp, // Adjusted icon size
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h), // Reduced space to make it more compact

              // Name and Email Tile
              _buildProfileTile(
                icon: Icons.account_circle,
                title: 'Name',
                value: homeController.username.value,
              ),
              _buildProfileTile(
                icon: Icons.email,
                title: 'Email',
                value: homeController.useremail.value,
              ),

              // Loyalty Points and Total Orders Tile
              _buildProfileTile(
                icon: Icons.card_giftcard,
                title: 'Loyalty Points',
                value: (homeController.loyaltyPoints.value).toString(),
              ),
              _buildProfileTile(
                icon: Icons.shopping_bag,
                title: 'Total Orders',
                value: '${homeController.totalOrders.value}',
              ),

              // Sign Out Button
              SizedBox(height: 24.h), // Reduced bottom space
              ElevatedButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut().whenComplete(
                    () {
                      Get.offAllNamed('/login');
                    },
                  );
                  // Sign Out logic here
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  minimumSize: Size(
                      double.infinity, 45.h), // Slightly smaller button height
                  padding: EdgeInsets.symmetric(
                      vertical: 10.h), // Adjust padding for balance
                ),
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 16.sp, // Moderate text size for the button
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Card(
      margin: EdgeInsets.only(bottom: 14.h), // Reduced bottom margin
      elevation: 5,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r), // Rounded corners
      ),
      child: ListTile(
        leading: Icon(icon,
            color: AppColors.primaryColor,
            size: 28.sp), // Slightly smaller icon
        title: Text(
          title,
          style: TextStyle(
            fontSize: 16.sp, // Slightly smaller font size for the title
            fontWeight: FontWeight.bold,
            color: AppColors.primaryColor,
          ),
        ),
        subtitle: Text(
          value,
          style: TextStyle(
              fontSize: 14.sp,
              color: Colors.grey), // Slightly smaller subtitle text
        ),
        trailing: Icon(Icons.arrow_forward_ios,
            size: 18.sp), // Slightly smaller trailing icon
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      ),
    );
  }
}
