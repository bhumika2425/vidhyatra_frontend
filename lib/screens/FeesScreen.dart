import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
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

    // Helper function to calculate date difference in days
    int getDaysRemaining(String dueDate) {
      DateTime due = DateTime.parse(dueDate);
      DateTime current = DateTime.now();
      return due.difference(current).inDays;
    }

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF186CAC),
        title: Text(
          "Fee Management",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
            // fontWeight: FontWeight.bold,
          ),
        ),
        elevation: 0,
      ),
      body: Stack(
        children: [
          Obx(() {
            if (feeController.isLoading.value) {
              return Center(
                child: CircularProgressIndicator(
                  color: const Color(0xFF186CAC),
                ),
              );
            } else if (feeController.errorMessage.value.isNotEmpty) {
              return Center(
                child: Text(
                  feeController.errorMessage.value,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              );
            } else if (feeController.fees.isEmpty) {
              return Center(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  margin: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 80,
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Great! No pending fees. 🎉',
                        style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF186CAC),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Stay financially organized and stress-free!',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.grey[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16, 70),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 8, bottom: 12),
                      child: Text(
                        "Select fee to Pay",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: feeController.fees.length,
                        itemBuilder: (context, index) {
                          Fee fee = feeController.fees[index];
                          int daysRemaining = getDaysRemaining(fee.dueDate);
                          bool isOverdue = daysRemaining <= 0;
                          bool isDueSoon = daysRemaining > 0 && daysRemaining <= 5;

                          return Container(
                            margin: EdgeInsets.only(bottom: 16),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.05),
                                  blurRadius: 8,
                                  offset: Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              fee.feeType,
                                              style: GoogleFonts.poppins(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF186CAC),
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          Obx(() {
                                            return Transform.scale(
                                              scale: 1.1,
                                              child: Checkbox(
                                                value: feeController.selectedFee.value?.feeID == fee.feeID,
                                                onChanged: (value) {
                                                  feeController.selectFee(fee);
                                                  if (value == true) {
                                                    print("Selected Fee ID: ${fee.feeID}");
                                                    print("Selected Fee Amount: ${fee.feeAmount}");
                                                  }
                                                },
                                                activeColor: const Color(0xFF186CAC),
                                                checkColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(4),
                                                ),
                                              ),
                                            );
                                          }),
                                        ],
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        fee.feeDescription,
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          color: Colors.black87,
                                        ),
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      SizedBox(height: 16),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.calendar_today,
                                                size: 18,
                                                color: isOverdue ? Colors.red : Colors.grey[600],
                                              ),
                                              SizedBox(width: 8),
                                              Text(
                                                "Due: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(fee.dueDate))}",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w500,
                                                  color: isOverdue ? Colors.red : Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFF186CAC).withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Text(
                                              "NRS ${fee.feeAmount}",
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF186CAC),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                                if (isOverdue || isDueSoon)
                                  Container(
                                    width: double.infinity,
                                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                                    decoration: BoxDecoration(
                                      color: isOverdue ? Colors.red.withOpacity(0.1) : Colors.deepOrange.withOpacity(0.1),
                                      borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          isOverdue ? Icons.warning_amber_rounded : Icons.access_time,
                                          color: isOverdue ? Colors.red : Colors.deepOrange,
                                          size: 20,
                                        ),
                                        SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            isOverdue
                                                ? "The due date has passed. Please visit the Finance Department to settle your fee."
                                                : "Just $daysRemaining day(s) left! Make sure to complete your payment on time.",
                                            style: GoogleFonts.poppins(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w500,
                                              color: isOverdue ? Colors.red : Colors.deepOrange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
          }),
          // Bottom pay now button
          Positioned(
            bottom: 70,
            left: screenWidth * 0.25,
            right: screenWidth * 0.25,
            child: ElevatedButton.icon(
              icon: Icon(Icons.payment, size: 18, color: Colors.white),
              label: Text(
                'Pay Now',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                backgroundColor: Colors.deepOrange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                minimumSize: Size(80, 45),
              ),
              onPressed: () {
                if (feeController.selectedFee.value != null) {
                  Fee selectedFee = feeController.selectedFee.value!;
                  // Get.snackbar(
                  //   "Payment",
                  //   "Processing payment for ${selectedFee.feeType}",
                  //   snackPosition: SnackPosition.TOP,
                  //   backgroundColor: const Color(0xFF186CAC),
                  //   colorText: Colors.white,
                  // );
                  paymentController.payFee(selectedFee.feeID, selectedFee.feeAmount);
                } else {
                  Get.snackbar(
                    "Error",
                    "Please select a fee to pay",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: Colors.red,
                    colorText: Colors.white,
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
