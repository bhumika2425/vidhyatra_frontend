import 'package:get/get.dart';

class OnboardingController extends GetxController {
  var currentIndex = 0.obs;
  
  void updatePageIndex(int index) {
    currentIndex.value = index;
  }
  
  void nextPage() {
    if (currentIndex.value < 2) {
      currentIndex.value++;
    }
  }
  
  void previousPage() {
    if (currentIndex.value > 0) {
      currentIndex.value--;
    }
  }
  
  void skipToLogin() {
    Get.offAllNamed('/login');
  }
  
  bool get isLastPage => currentIndex.value == 2;
  bool get isFirstPage => currentIndex.value == 0;
}
