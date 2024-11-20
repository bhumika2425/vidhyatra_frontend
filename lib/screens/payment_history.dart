import 'package:flutter/material.dart';

import '../models/payment_transaction_model.dart';

class PaymentHistoryPage extends StatelessWidget {
  final List<PaymentTransaction> transactions = [
    PaymentTransaction(
        studentName: 'John Doe',
        amountPaid: 5000,
        feeType: 'Semester Fee',
        date: '2024-10-15',
        transactionId: 'TXN12345'),
    PaymentTransaction(
        studentName: 'John Doe',
        amountPaid: 3000,
        feeType: 'Exam Fee',
        date: '2024-09-10',
        transactionId: 'TXN67890'),
    // Add more transactions if needed
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment History'),
        backgroundColor: Colors.white, // Set your theme color
        iconTheme: IconThemeData(color: Colors.black), // Icon color
        titleTextStyle: TextStyle(color: Colors.black, fontSize: 20),
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(16.0),
        itemCount: transactions.length,
        itemBuilder: (context, index) {
          final transaction = transactions[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 10.0),
            child: ListTile(
              leading: Icon(Icons.receipt_long, color: Colors.blue),
              title: Text(
                'Amount: Rs. ${transaction.amountPaid}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('For: ${transaction.feeType}'),
                  Text('Date: ${transaction.date}'),
                  Text('Transaction ID: ${transaction.transactionId}'),
                ],
              ),
              trailing: IconButton(
                icon: Icon(Icons.download, color: Colors.green),
                onPressed: () {
                  _downloadReceipt(transaction);
                },
              ),
            ),
          );
        },
      ),
    );
  }

  // Function to handle downloading the receipt
  void _downloadReceipt(PaymentTransaction transaction) {
    // Logic to download the receipt
    // This could involve generating a PDF or downloading an existing one from a server
    print('Downloading receipt for transaction: ${transaction.transactionId}');
  }
}