// controllers/splash_controller.dart
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    navigateToNextScreen();
  }

  void navigateToNextScreen() async {
    await Future.delayed(
        const Duration(seconds: 3)); // Display splash for 3 seconds
    Get.offNamed('/onboarding'); // Replace with your next route
  }
}
