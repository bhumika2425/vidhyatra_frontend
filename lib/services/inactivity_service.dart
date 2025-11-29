import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InactivityService extends GetxService {
  Timer? _inactivityTimer;
  final Duration inactivityDuration = const Duration(minutes: 120);
  bool _dialogShown = false;

  @override
  void onInit() {
    super.onInit();
    resetInactivityTimer();
  }

  /// Reset the inactivity timer
  void resetInactivityTimer() {
    _inactivityTimer?.cancel();
    _dialogShown = false;

    _inactivityTimer = Timer(inactivityDuration, () {
      if (!_dialogShown) {
        _showInactivityDialog();
      }
    });
  }

  /// Show inactivity dialog
  void _showInactivityDialog() {
    if (_dialogShown) return;
    _dialogShown = true;

    Get.dialog(
      WillPopScope(
        onWillPop: () async => false, // Prevent dismissing by back button
        child: AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange, size: 28),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Connection Lost',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'You have been inactive for so long.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  height: 1.4,
                ),
              ),
              SizedBox(height: 12),
              Text(
                'Please reload the app to continue using it.',
                style: TextStyle(
                  fontSize: 15,
                  color: Colors.grey.shade700,
                  height: 1.4,
                ),
              ),
            ],
          ),
          actions: [
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () {
                  _reloadApp();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: Text(
                  'Reload App',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      barrierDismissible: false,
    );
  }

  /// Reload the app
  void _reloadApp() {
    _dialogShown = false;
    Get.back(); // Close dialog
    
    // Reset the timer
    resetInactivityTimer();
    
    // Navigate to home/dashboard or reload current route
    String currentRoute = Get.currentRoute;
    
    // Reload the current page by popping and pushing again
    if (currentRoute != '/') {
      Get.offAllNamed(currentRoute);
    } else {
      // If on root, just reload by navigating to same route
      Get.offAllNamed('/student-dashboard');
    }
  }

  /// Stop the inactivity timer
  void stopTimer() {
    _inactivityTimer?.cancel();
    _dialogShown = false;
  }

  @override
  void onClose() {
    _inactivityTimer?.cancel();
    super.onClose();
  }
}
