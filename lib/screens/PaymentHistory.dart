import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../controllers/PaymentHistoryController.dart';
import 'PaymentDetailsView.dart';

class PaymentHistoryView extends StatelessWidget {
  final PaymentHistoryController controller = Get.put(PaymentHistoryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF186CAC),
        title: Text(
          "Your Paid Fees",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 19,
          ),
        ),
        elevation: 0,
      ),
      body: RefreshIndicator(
        onRefresh: () => controller.fetchPaymentHistory(),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.errorMessage.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    controller.errorMessage.value,
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          if (controller.paymentHistory.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.payment, size: 48, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No payment history found',
                    style: GoogleFonts.poppins(
                      color: Colors.grey[700],
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: controller.paymentHistory.length,
            itemBuilder: (context, index) {
              final payment = controller.paymentHistory[index];
              return InkWell(
                onTap: () {
                  Get.to(() => PaymentDetailsView(payment: payment));
                },
                child: Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          payment.feeType,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Amount: Rs. ${payment.totalPrice}',
                          style: GoogleFonts.poppins(
                            color: Colors.grey[700],
                          ),
                        ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${payment.status.capitalizeFirst}',
                          style: GoogleFonts.poppins(
                            color: payment.status == 'completed'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        if (payment.payment != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            'Transaction ID: ${payment.payment!.transactionId}',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          'Date: ${DateFormat('MMM dd, yyyy').format(DateTime.parse(payment.createdAt))}',
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}