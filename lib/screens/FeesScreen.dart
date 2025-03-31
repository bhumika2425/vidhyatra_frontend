import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/controllers/PaymentController.dart';
import '../controllers/FeeController.dart';
import '../models/FeesModel.dart';
import '../services/PaymentService.dart';

class FeesScreen extends StatelessWidget {
  final FeeController feeController = Get.put(FeeController());
  final PaymentController paymentController = Get.put(PaymentController(paymentService: PaymentService()));


  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double textScale = MediaQuery.of(context).textScaleFactor;

    // Helper function to calculate date difference in days
    int getDaysRemaining(String dueDate) {
      DateTime due = DateTime.parse(dueDate);
      DateTime current = DateTime.now();
      return due.difference(current).inDays;
    }



    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, // Set Drawer icon color to white
        ),
        backgroundColor: Colors.white,
        title: Text(
          'Fee Management',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22 * textScale, color: Colors.black),
        ),
        elevation: 0,
        actions: [
          Row(
            children: [
              Text('Pay Now', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),),
              IconButton(
                icon: Icon(Icons.payment),
                onPressed: () {
                  if (feeController.selectedFee.value != null) {
                    Fee selectedFee = feeController.selectedFee.value!;
                    // Trigger payment for the selected fee
                    Get.snackbar(
                      "Payment",
                      "Processing payment for ${selectedFee.feeType}",
                      snackPosition: SnackPosition.TOP,
                      // backgroundColor: Color(0xFF971F20),
                      // colorText: Colors.white,
                    );

                    final PaymentController paymentController = Get.find<PaymentController>();
                    // Call the payFee function
                    paymentController.payFee(selectedFee.feeID, selectedFee.feeAmount);
                  } else {
                    // Show error if no fee is selected
                    Get.snackbar(
                      "Error",
                      "Please select a fee to pay",
                      snackPosition: SnackPosition.TOP,
                      // backgroundColor: Colors.red,
                      // colorText: Colors.white,
                    );
                  }
                },
              ),
            ],
          )
        ],
      ),
      body: Obx(() {
        if (feeController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        } else if (feeController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Text(
              feeController.errorMessage.value,
              style: TextStyle(fontSize: 18 * textScale, color: Colors.red),
            ),
          );
        } else if (feeController.fees.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.check_circle, color: Colors.green, size: screenWidth * 0.15),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  'Great! No pending fees. 🎉',
                  style: TextStyle(fontSize: 20 * textScale, fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
                  child: Text(
                    'Stay financially organized and stress-free!',
                    style: TextStyle(fontSize: 16 * textScale, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          );
        } else {
          return ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: screenHeight * 0.02),
            itemCount: feeController.fees.length,
            itemBuilder: (context, index) {
              Fee fee = feeController.fees[index];
              int daysRemaining = getDaysRemaining(fee.dueDate);

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                elevation: 4,
                margin: EdgeInsets.only(bottom: screenHeight * 0.02),
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.04),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (daysRemaining <= 5 && daysRemaining > 0)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          child: Text(
                            "⏳ Just $daysRemaining day(s) left! Make sure to complete your payment on time and stay ahead of your finances. Your timely payment keeps everything running smoothly. You've got this! 💪",
                            style: TextStyle(fontSize: 14 * textScale, fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                        ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              fee.feeType,
                              style: TextStyle(
                                fontSize: 18 * textScale,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF3D7FA4),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Obx(() {
                            return Checkbox(
                              value: feeController.selectedFee.value?.feeID == fee.feeID,
                              onChanged: (value) {
                                feeController.selectFee(fee); // Select the fee
                                if (value == true) {
                                  print("Selected Fee ID: ${fee.feeID}");
                                  print("Selected Fee Amount: ${fee.feeAmount}");
                                }
                              },
                              activeColor: Color(0xFF3D7FA4), // Color when checkbox is checked
                              checkColor: Colors.white,
                            );
                          })
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.008),
                      Text(
                        fee.feeDescription,
                        style: TextStyle(fontSize: 14 * textScale, color: Colors.black87),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Row(
                        children: [
                          Icon(Icons.calendar_today, size: screenWidth * 0.04, color: Colors.grey),
                          SizedBox(width: screenWidth * 0.02),
                          Text(
                            "Due: ${fee.dueDate}",
                            style: TextStyle(fontSize: 14 * textScale, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      SizedBox(height: screenHeight * 0.015),
                      Text(
                        "NRS ${fee.feeAmount}",
                        style: TextStyle(
                          fontSize: 16 * textScale,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF3D7FA4),
                        ),
                      ),
                      if (daysRemaining <= 0)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: screenHeight * 0.015),
                          child: Text(
                            "The due date has passed. Please visit the Finance Department at your earliest convenience to settle your fee.",
                            style: TextStyle(fontSize: 14 * textScale, fontWeight: FontWeight.bold, color: Colors.deepOrange),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      }),
    );
  }
}
