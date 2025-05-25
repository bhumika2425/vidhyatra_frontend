import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/controllers/PaymentController.dart';
import '../controllers/ProfileController.dart';
import '../models/user.dart';

class PaymentProcess extends StatelessWidget {
  const PaymentProcess({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();
    final LoginController loginController = Get.find<LoginController>();
    final ProfileController profileController = Get.find<ProfileController>();

    final paidFeesData = paymentController.paidFeesData;
    final paymentData = paymentController.paymentData;

    final paymentType = 'esewa'.obs;
    final isLoading = true.obs; // Add loading state

    // Simulate 1-second delay for loading
    Future.delayed(const Duration(seconds: 1), () {
      isLoading.value = false;
    });

    void handlePayment() {
      double amount = paidFeesData['totalPrice']?.toDouble() ?? 0.0;
      String transactionUuid = paidFeesData['paidFeesId'] ?? '';
      String signature = paymentData['signature'] ?? '';

      if (amount == 0.0 || transactionUuid.isEmpty || signature.isEmpty) {
        Get.snackbar(
          'Error',
          "Missing payment data",
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: Colors.red,
          snackPosition: SnackPosition.TOP,
        );
        return;
      }

      paymentController.initiateToEsewaPayment(amount, transactionUuid, signature);
    }

    // Helper function to format the date
    String formatDate(String? dateStr) {
      if (dateStr == null || dateStr.isEmpty) return 'N/A';
      try {
        final date = DateTime.parse(dateStr);
        return DateFormat('dd MMM yyyy').format(date);
      } catch (e) {
        print('Error parsing date: $dateStr, Error: $e');
        return 'N/A';
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Fee Details',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
        elevation: 0,
        backgroundColor: const Color(0xFF186CAC),
        foregroundColor: Colors.white,
      ),
      body: Obx(() {
        // Show CircularProgressIndicator for 1 second with custom color
        if (isLoading.value) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange), // Custom color
            ),
          );
        }

        if (loginController.user.value == null) {
          return Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.deepOrange), // Custom color
            ),
          );
        }
        User currentUser = loginController.user.value!;

        return SingleChildScrollView(
          child: Column(
            children: [
              // User info header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Obx(() => CircleAvatar(
                            radius: 30,
                            backgroundImage: profileController.profile.value?.profileImageUrl != null
                                ? NetworkImage(profileController.profile.value!.profileImageUrl!)
                                : const AssetImage('assets/default_profile.png') as ImageProvider,
                            onBackgroundImageError: (_, __) {
                              print('Failed to load profile image');
                            },
                          )),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                currentUser.email,
                                style: GoogleFonts.poppins(
                                  color: Colors.black87,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                'ID: ${currentUser.collegeId}',
                                style: GoogleFonts.poppins(
                                  color: Colors.black54,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Main content
              Padding(
                padding:
                const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Card(
                  elevation: 2,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Fee Payment Details",
                          style: GoogleFonts.poppins(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF186CAC),
                          ),
                        ),
                        const Divider(height: 30),
                        _buildSectionTitle("Payment Method"),
                        const SizedBox(height: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Choose payment type',
                              style: GoogleFonts.poppins(fontSize: 15),
                            ),
                            const SizedBox(height: 10),
                            Obx(() => Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Colors.grey.shade300),
                                color: Colors.grey[100],
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 8),
                              child: Row(
                                children: [
                                  Radio<String>(
                                    value: 'esewa',
                                    groupValue: paymentType.value,
                                    onChanged: (String? value) {
                                      if (value != null) paymentType.value = value;
                                    },
                                    activeColor: Colors.deepOrange,
                                  ),
                                  Image.asset(
                                    'assets/img_1.png',
                                    height: 30,
                                    width: 30,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    'eSewa',
                                    style: GoogleFonts.poppins(),
                                  ),
                                ],
                              ),
                            )),
                          ],
                        ),
                        const SizedBox(height: 30),
                        _buildSectionTitle("Payment Summary"),
                        const SizedBox(height: 15),
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: Column(
                            children: [
                              _buildInfoRow(
                                  "Amount", "NPR ${paidFeesData['totalPrice'] ?? 0.00}"),
                              const SizedBox(height: 10),
                              _buildInfoRow("Date", formatDate(paidFeesData['paidDate'])),
                            ],
                          ),
                        ),
                        const SizedBox(height: 30),
                        Obx(() => Center(
                          child: Container(
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.green,
                            ),
                            child: TextButton(
                              onPressed: handlePayment,
                              child: Text(
                                'Pay with ${paymentType.value.capitalizeFirst}',
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        )),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF186CAC),
      ),
    );
  }

  Widget _buildDropdown(RxString selectedValue, List<String> items) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 1),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Obx(() => DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: selectedValue.value,
          isExpanded: true,
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFF186CAC)),
          onChanged: (String? newValue) {
            if (newValue != null) selectedValue.value = newValue;
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: GoogleFonts.poppins(),
              ),
            );
          }).toList(),
        ),
      )),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.poppins(
            color: Colors.grey[600],
            fontWeight: FontWeight.w500,
          ),
        ),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.right,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}