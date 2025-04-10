import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';
import 'package:vidhyatra_flutter/controllers/PaymentController.dart';
import '../models/user.dart';

class PaidFeesDetails extends StatelessWidget {
  const PaidFeesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();
    final LoginController loginController = Get.find<LoginController>();

    final paidFeesData = paymentController.paidFeesData;
    final paymentData = paymentController.paymentData;

    final semester = 'First'.obs;
    final year = 'First'.obs;
    final paymentType = 'esewa'.obs;

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

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Fee Details',
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              color: Colors.white
          ),
        ),
        elevation: 0,
        backgroundColor: Color(0xFF186CAC),
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Obx(() {
        if (loginController.user.value == null) {
          return const Center(child: CircularProgressIndicator());
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
                  color: Colors.grey[200], // Changed from blue to grey[200]
                ),
                child: Column(
                  children: [
                    // User profile section and information in same line
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(12),
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
                          child: Icon(
                            Icons.person_rounded,
                            size: 30,
                            color: Color(0xFF186CAC),
                          ),
                        ),
                        const SizedBox(width: 16), // Space between icon and text
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
                padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
                child: Card(
                  elevation: 2,
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

                        _buildSectionTitle("Academic Details"),
                        const SizedBox(height: 15),

                        Text(
                          "Select Year",
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown(year, ['First', 'Second', 'Third']),

                        const SizedBox(height: 20),

                        Text(
                          "Select Semester",
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                        const SizedBox(height: 8),
                        _buildDropdown(semester, ['First', 'Second']),

                        const SizedBox(height: 25),
                        _buildSectionTitle("Payment Method"),
                        const SizedBox(height: 10),

                        // Only eSewa option
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
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                              _buildInfoRow("Amount", "NPR ${paidFeesData['totalPrice'] ?? 0.00}"),
                              const SizedBox(height: 10),
                              _buildInfoRow("Transaction ID", paidFeesData['paidFeesId'] ?? 'N/A'),
                              const SizedBox(height: 10),
                              _buildInfoRow("Date", paidFeesData['paidDate'] ?? 'N/A'),
                            ],
                          ),
                        ),

                        const SizedBox(height: 30),

                        Obx(() => Center(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.deepOrange,
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
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
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