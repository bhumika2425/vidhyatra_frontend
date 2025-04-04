import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      paymentController.initiateToEsewaPayment(amount, transactionUuid, signature);
    }

    return Scaffold(
      backgroundColor: Colors.grey[400],
      appBar: AppBar(
        title: const Text('Fee Details'),
        elevation: 0,
        backgroundColor: Theme.of(context).primaryColor,
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
              // Header
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Color(0xFF3D7FA4),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.fromLTRB(20, 5, 20, 15),
                child: Row(
                  children: [
                    const CircleAvatar(
                      radius: 25,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, size: 25, color: Colors.blueGrey),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            currentUser.email,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            'ID: ${currentUser.collegeId}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Body
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Fee Payment Details",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.blueGrey,
                          ),
                        ),
                        const Divider(height: 30),

                        _buildSectionTitle("Academic Details"),
                        const SizedBox(height: 15),

                        const Text("Select Year", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildDropdown(year, ['First', 'Second', 'Third']),

                        const SizedBox(height: 20),

                        const Text("Select Semester", style: TextStyle(fontSize: 16)),
                        const SizedBox(height: 8),
                        _buildDropdown(semester, ['First', 'Second']),

                        const SizedBox(height: 25),
                        _buildSectionTitle("Payment Method"),
                        const SizedBox(height: 10),

                        // Only eSewa option
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Choose payment type', style: TextStyle(fontSize: 16)),
                            const SizedBox(height: 10),
                            Obx(() => Row(
                              children: [
                                Radio<String>(
                                  value: 'esewa',
                                  groupValue: paymentType.value,
                                  onChanged: (String? value) {
                                    if (value != null) paymentType.value = value;
                                  },
                                  activeColor: Colors.green,
                                ),
                                Image.asset(
                                  'assets/img_1.png',
                                  height: 30,
                                  width: 30,
                                ),
                                const SizedBox(width: 10),
                                const Text('eSewa'),
                              ],
                            )),
                          ],
                        ),

                        const SizedBox(height: 30),
                        _buildSectionTitle("Payment Summary"),
                        const SizedBox(height: 10),

                        _buildInfoRow("Amount", "NPR ${paidFeesData['totalPrice'] ?? 0.00}"),
                        _buildInfoRow("Transaction ID", paidFeesData['paidFeesId'] ?? 'N/A'),
                        _buildInfoRow("Date", paidFeesData['paidDate'] ?? 'N/A'),

                        const SizedBox(height: 30),

                        Obx(() => Center(
                          child: Container(
                            width: double.infinity,
                            height: 50,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(
                                colors: [Colors.green, Colors.green.shade700],
                              ),
                            ),
                            child: TextButton(
                              onPressed: handlePayment,
                              child: Text(
                                'Pay with ${paymentType.value.capitalizeFirst}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
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
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Colors.blueGrey,
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
          icon: const Icon(Icons.arrow_drop_down),
          onChanged: (String? newValue) {
            if (newValue != null) selectedValue.value = newValue;
          },
          items: items.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      )),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(color: Colors.grey[600])),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w500),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
