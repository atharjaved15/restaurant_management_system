import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/signin_controller.dart';
import 'package:restaurant_management_system/colors.dart';
import 'dart:ui';

class LoginScreenWeb extends StatefulWidget {
  const LoginScreenWeb({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginScreenWebState createState() => _LoginScreenWebState();
}

class _LoginScreenWebState extends State<LoginScreenWeb> {
  bool isMobile = false;
  String selectedRole = 'User';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Initialize the SignInController
  final SignInController signInController = Get.put(SignInController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(isMobile ? 0 : 30),
          child: isMobile ? _buildMobileLoginForm() : _buildWebLoginForm(),
        ),
      ),
    );
  }

  Widget _buildMobileLoginForm() {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/images/background.jpg',
            fit: BoxFit.cover,
          ),
        ),
        Positioned.fill(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
            child: Container(
              color: Colors.black.withOpacity(0.6),
            ),
          ),
        ),
        Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: _buildLoginForm(isMobile: true),
          ),
        ),
      ],
    );
  }

  Widget _buildWebLoginForm() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              image: const DecorationImage(
                image: AssetImage('assets/images/background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 32.w),
                child: Text(
                  "Welcome to the\nRestaurant Management System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp,
                    fontWeight: FontWeight.bold,
                    shadows: const [
                      Shadow(
                        color: Colors.black54,
                        blurRadius: 10,
                        offset: Offset(2, 2),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 400.w),
              padding: EdgeInsets.all(32.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: _buildLoginForm(isMobile: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm({required bool isMobile}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Login',
            style: TextStyle(
              fontSize: isMobile ? 24.sp : 15.sp,
              color: isMobile ? Colors.white : AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Please enter your credentials to continue.',
            style: TextStyle(
              fontSize: isMobile ? 14.sp : 5.sp,
              color: isMobile ? Colors.white70 : Colors.black54,
            ),
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: _emailController,
            style: isMobile ? const TextStyle(color: Colors.white) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isMobile ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              hintText: 'Email',
              hintStyle:
                  isMobile ? const TextStyle(color: Colors.white70) : null,
              prefixIcon: Icon(Icons.email,
                  color: isMobile ? Colors.white : AppColors.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your email';
              }
              if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: _passwordController,
            obscureText: true,
            style: isMobile ? const TextStyle(color: Colors.white) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isMobile ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              hintText: 'Password',
              hintStyle:
                  isMobile ? const TextStyle(color: Colors.white70) : null,
              prefixIcon: Icon(Icons.lock,
                  color: isMobile ? Colors.white : AppColors.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your password';
              }
              if (value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
          SizedBox(height: 10.h),
          TextButton(
            onPressed: () {
              // Forgot password action
            },
            child: Text(
              "Forgot Password?",
              style: TextStyle(
                color: isMobile ? Colors.white70 : AppColors.textColor,
                fontSize: 20.h,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: 'User',
                groupValue: selectedRole,
                activeColor: AppColors.accentColor,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                    print(value);
                  });
                },
              ),
              Text(
                'User',
                style: TextStyle(color: isMobile ? Colors.white : Colors.black),
              ),
              Radio<String>(
                value: 'Staff',
                groupValue: selectedRole,
                activeColor: AppColors.accentColor,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                    print(value);
                  });
                },
              ),
              Text(
                'Staff',
                style: TextStyle(color: isMobile ? Colors.white : Colors.black),
              ),
            ],
          ),
          SizedBox(height: 10.h),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                // Call signIn method from SignInController
                signInController.signIn(
                  _emailController.text.trim(),
                  _passwordController.text.trim(),
                  selectedRole,
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              minimumSize: Size(double.infinity, 20.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: Text(
              'Login',
              style: TextStyle(
                fontSize: 30.h,
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 10.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10.w),
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/signup');
                },
                child: Text(
                  "Don't have an account? Sign Up",
                  style: TextStyle(
                    color: isMobile ? Colors.white70 : AppColors.textColor,
                    fontSize: 20.h,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
