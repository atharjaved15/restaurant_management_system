import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:restaurant_management_system/Controllers/signup_controller.dart';
import 'package:restaurant_management_system/colors.dart';
import 'dart:ui';

class SignupScreenWeb extends StatefulWidget {
  const SignupScreenWeb({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignupScreenWebState createState() => _SignupScreenWebState();
}

class _SignupScreenWebState extends State<SignupScreenWeb> {
  bool isMobile = false;
  String selectedRole = 'User  ';
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final SignupController _signupController = Get.put(SignupController());

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: const Size(390, 844));
    isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      body: Center(
        child: Container(
          margin: EdgeInsets.all(isMobile ? 0 : 30), // Outer padding of 30px
          child: isMobile ? _buildMobileSignupForm() : _buildWebSignupForm(),
        ),
      ),
    );
  }

  Widget _buildMobileSignupForm() {
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
            child: _buildSignupForm(isMobile: true),
          ),
        ),
      ],
    );
  }

  Widget _buildWebSignupForm() {
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
                  "Create Your Account\nRestaurant Management System",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10.sp, // Reduced font size
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
              constraints: BoxConstraints(maxWidth: 400.w), // Set max width
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
              child: _buildSignupForm(isMobile: false),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignupForm({required bool isMobile}) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sign Up',
            style: TextStyle(
              fontSize: isMobile ? 25.sp : 15.sp,
              color: isMobile ? Colors.white : AppColors.primaryColor,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.h),
          Text(
            'Please enter your details to create an account.',
            style: TextStyle(
              fontSize: isMobile ? 14.sp : 5.sp,
              color: isMobile ? Colors.white70 : Colors.black54,
            ),
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: _nameController,
            style: isMobile ? const TextStyle(color: Colors.white) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isMobile ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              hintText: 'Name',
              hintStyle:
                  isMobile ? const TextStyle(color: Colors.white70) : null,
              prefixIcon: Icon(Icons.person,
                  color: isMobile ? Colors.white : AppColors.primaryColor),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your name';
              }
              return null;
            },
          ),
          SizedBox(height: 20.h),
          TextFormField(
            controller: _phoneController,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly, // Allow only numbers
              TextInputFormatter.withFunction((oldValue, newValue) {
                // Define the custom format (e.g., 07123 456789)
                String text = newValue.text;

                if (text.length >= 5) {
                  text = '${text.substring(0, 5)} ${text.substring(5)}';
                }
                return TextEditingValue(
                  text: text,
                  selection: TextSelection.collapsed(offset: text.length),
                );
              }),
            ],
            style: isMobile ? const TextStyle(color: Colors.white) : null,
            decoration: InputDecoration(
              filled: true,
              fillColor:
                  isMobile ? Colors.white.withOpacity(0.2) : Colors.grey[200],
              hintText: 'Phone Number',
              hintStyle:
                  isMobile ? const TextStyle(color: Colors.white70) : null,
              prefixIcon: Icon(
                Icons.phone,
                color: isMobile ? Colors.white : AppColors.primaryColor,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide.none,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter your phone number';
              }
              if (value.length < 10) {
                return 'Please enter a valid phone number';
              }
              return null;
            },
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Radio<String>(
                value: 'User  ',
                groupValue: selectedRole,
                activeColor: AppColors.accentColor,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
                  });
                },
              ),
              Text(
                'User  ',
                style: TextStyle(color: isMobile ? Colors.white : Colors.black),
              ),
              Radio<String>(
                value: 'Staff',
                groupValue: selectedRole,
                activeColor: AppColors.accentColor,
                onChanged: (value) {
                  setState(() {
                    selectedRole = value!;
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
          Obx(() {
            return ElevatedButton(
              onPressed: _signupController.isLoading.value
                  ? null
                  : () {
                      if (_formKey.currentState!.validate()) {
                        _signupController.signup(
                          _nameController.text,
                          _phoneController.text,
                          _emailController.text,
                          _passwordController.text,
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
              child: _signupController.isLoading.value
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 30.h, color: Colors.white),
                    ),
            );
          }),
          SizedBox(height: 10.h),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(width: 10.w),
              TextButton(
                onPressed: () {
                  Get.offAllNamed('/login');
                },
                child: Text(
                  "Already have an account? Log In",
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
