import 'package:get/get.dart';

class AdminDashboardController extends GetxController {
  // Reactive variables for statistics
  var totalUsers = 0.obs;
  var totalEvents = 0.obs;
  var totalFeedbacks = 0.obs;

  // List of recent events
  var recentEvents = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchDashboardData(); // Load data when the controller initializes
  }

  // Simulate fetching data from an API
  void fetchDashboardData() async {
    await Future.delayed(Duration(seconds: 2)); // Simulating API call delay

    totalUsers.value = 320;
    totalEvents.value = 15;
    totalFeedbacks.value = 42;
    recentEvents.assignAll(["Science Seminar", "Sports Week", "Hackathon"]);
  }
}
