import 'package:get/get.dart';

class IconController extends GetxController{

  RxBool isRed = false.obs;

  // Toggle the color state
  void toggleColor() {
    isRed.value = !isRed.value;
  }

  navigateToPage(int index){
    switch (index) {
      case 0:
        Get.offAllNamed('/dashboard'); // Navigate to Dashboard
        break;
      case 1:
        Get.toNamed('/payment'); // Navigate to Payments page
        break;
      case 2:
        Get.toNamed('/calendar'); // Navigate to Calendar page
        break;
      case 3:
        Get.toNamed('/messages'); // Navigate to Chat page
        break;
      default:
        break;
    }
  }

}