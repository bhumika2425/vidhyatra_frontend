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

    // Null checks for values
    final paymentMethod = paidFeesData['paymentMethod'] ?? 'N/A';
    final paidDate = paidFeesData['paidDate'] ?? 'N/A';
    final totalPrice = paidFeesData['totalPrice'] ?? 0.00;
    final signature = paymentData['signature'] ?? '';
    final signedFieldNames = paymentData['signed_field_names'] ?? '';
    final paidFeesId = paidFeesData['paidFeesId'] ?? '';

    // Add observables for semester, year, and payment type
    var semester = 'First'.obs;
    var year = 'First'.obs;
    var paymentType = 'esewa'.obs; // default payment type

    return Scaffold(
      appBar: AppBar(
        title: Text('Fee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(26.0),
        child: SingleChildScrollView(
          child:  Obx(() {
            if (loginController.user.value != null) {
              User currentUser = loginController.user.value!;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Personal Information
                  Text('Student Email: ${currentUser.email}',
                      style: TextStyle(fontSize: 18)),
                  Text('College ID: ${currentUser.collegeId}',
                      style: TextStyle(fontSize: 18)),
                  SizedBox(height: 20),

                  // Year Dropdown
                  Text("Select Year", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: year.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) year.value = newValue;
                    },
                    items: ['First', 'Second', 'Third']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text("Select Year"),
                  ),
                  SizedBox(height: 10),

                  // Semester Dropdown
                  Text("Select Semester", style: TextStyle(fontSize: 16)),
                  DropdownButton<String>(
                    value: semester.value,
                    onChanged: (String? newValue) {
                      if (newValue != null) semester.value = newValue;
                    },
                    items: ['First', 'Second']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    hint: Text("Select Semester"),
                  ),
                  SizedBox(height: 20),

                  // Payment Type Radio Buttons
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Choose payment type', style: TextStyle(fontSize: 16)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Radio<String>(
                                value: 'esewa',
                                groupValue: paymentType.value,
                                onChanged: (String? value) {
                                  if (value != null) paymentType.value = value;
                                },
                              ),
                              Image.asset(
                                'assets/img_1.png',
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'khalti',
                                groupValue: paymentType.value,
                                onChanged: (String? value) {
                                  if (value != null) paymentType.value = value;
                                },
                              ),
                              Image.asset(
                                'assets/img.png',
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<String>(
                                value: 'bank_transfer',
                                groupValue: paymentType.value,
                                onChanged: (String? value) {
                                  if (value != null) paymentType.value = value;
                                },
                              ),
                              Image.asset(
                                'assets/img_2.png',
                                height: 30,
                                width: 30,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),

                  // Payment Button with Dynamic Color
                  Center(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: LinearGradient(
                          colors: [
                            paymentType.value == 'esewa'
                                ? Colors.green
                                : paymentType.value == 'khalti'
                                ? Colors.deepPurple
                                : Colors.red,
                            paymentType.value == 'esewa'
                                ? Colors.green.shade700
                                : paymentType.value == 'khalti'
                                ? Colors.blue.shade700
                                : Colors.red.shade700,
                          ],
                        ),
                      ),
                      child: TextButton(
                        onPressed: () {
                          double amount =
                              paidFeesData['totalPrice']?.toDouble() ?? 0.0;
                          String transactionUuid = paidFeesData['paidFeesId'] ?? '';
                          String signature = paymentData['signature'] ?? '';

                          if (amount == 0.0 ||
                              transactionUuid.isEmpty ||
                              signature.isEmpty) {
                            print("Error, missing data for payment");
                            return;
                          }

                          if (paymentType.value == 'khalti' ||
                              paymentType.value == 'bank_transfer') {
                            // Show Coming Soon message
                            Get.snackbar('Coming soon', "Khalti and Bank transfer will be available soon");
                            return;
                          }

                          paymentController.initiateToEsewaPayment(
                              amount, transactionUuid, signature);
                        },
                        child: Text(
                          'Pay with ${paymentType.value}',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 20),

                  // Displaying general information in a card
                  Text('Payment Method: $paymentMethod'),
                  Text('Purchase Date: $paidDate'),
                  Text('Total Price: NPR $totalPrice'),
                  SizedBox(height: 10),
                  Text('Payment Signature: $signature'),
                  Text('Signed Field Names: $signedFieldNames'),
                  SizedBox(height: 10),
                  Text('Purchased Item ID: $paidFeesId'),
                  Text('Status: ${paidFeesData['status'] ?? 'N/A'}'),
                ],
              );
            } else {
              return Text("Loading...");
            }
          }),
        ),
      ),
    );
  }
}
