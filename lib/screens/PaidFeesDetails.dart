import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/controllers/PaymentController.dart';

class PaidFeesDetails extends StatelessWidget {
  const PaidFeesDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final PaymentController paymentController = Get.find();

    final paidFeesData = paymentController.paidFeesData;
    final paymentData = paymentController.paymentData;

    // Null checks for values
    final paymentMethod = paidFeesData['paymentMethod'] ?? 'N/A';
    final paidDate = paidFeesData['paidDate'] ?? 'N/A';
    final totalPrice = paidFeesData['totalPrice'] ?? 0.00;
    final signature = paymentData['signature'] ?? '';
    final signedFieldNames = paymentData['signed_field_names'] ?? '';
    final paidFeesId = paidFeesData['paidFeesId'] ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text('Fee Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
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

              Container(

                child: TextButton(
                  onPressed: () {
                    double amount = paidFeesData['totalPrice']?.toDouble() ?? 0.0;
                    String transactionUuid = paidFeesData['paidFeesId'] ?? '';
                    String signature = paymentData['signature'] ?? '';

                    if(amount == 0.0 || transactionUuid.isEmpty || signature.isEmpty) {
                      print("Error, missing data for payment");
                       return;
                    }


                    paymentController.initiateToEsewaPayment(amount, transactionUuid, signature);
                  },
                  child: Text('Pay with esewa'),
                ),
              )
            ],  
          ),
        ),
      ),
    );
  }
}
