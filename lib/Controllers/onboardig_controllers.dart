// app/controllers/onboarding_controller.dart
import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var pageIndex = 0.obs;

  void nextPage() {
    if (pageIndex.value == 2) {
      Get.offAllNamed('/login');
    }
    if (pageIndex.value < 2) pageIndex.value++;
  }

  void previousPage() {
    if (pageIndex.value > 0) pageIndex.value--;
  }

  void skip() {
    pageIndex.value = 2;
  }
}
