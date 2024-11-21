import 'package:get/get.dart';
import 'package:restaurant_management_system/Views/HomePage/home_page_structure.dart';
import 'package:restaurant_management_system/Views/OnBoarding/onboarding_example.dart';
import 'package:restaurant_management_system/Views/Staff/orders_screen.dart';
import 'package:restaurant_management_system/Views/Staff/staff_homepage_structure.dart';
import 'package:restaurant_management_system/Views/signin_screen.dart';
import 'package:restaurant_management_system/Views/signup_screen.dart';
import 'package:restaurant_management_system/Views/splash_screen.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String signup = '/signup';
  static const String main = '/main';
  static const String staffHome = '/staffHome';
  static const String staffOrders = '/staffOrders';

  // Define your routes here
  static final routes = [
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnBoardingPage()),
    GetPage(name: login, page: () => const LoginScreenWeb()),
    GetPage(name: signup, page: () => const SignupScreenWeb()),
    GetPage(name: main, page: () => MainScreen()),
    GetPage(name: staffHome, page: () => StaffHomePageStructure()),
    GetPage(name: staffOrders, page: () => StaffOrderScreen()),
  ];
}
