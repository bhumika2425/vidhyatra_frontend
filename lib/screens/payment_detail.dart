import 'package:flutter/material.dart';
import '../models/payment_info.dart';  // Updated import

class PaymentDetailPage extends StatefulWidget {
  final PaymentInfo paymentInfo;

  const PaymentDetailPage({required this.paymentInfo});

  @override
  _PaymentDetailPageState createState() => _PaymentDetailPageState();
}

class _PaymentDetailPageState extends State<PaymentDetailPage> {
  String? selectedYear;
  String? selectedSemester;
  String? selectedPaymentMethod;  // Track the selected payment method

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.paymentInfo.title} Payment'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.paymentInfo.title} Details',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Amount: ${widget.paymentInfo.amount}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Due Date: ${widget.paymentInfo.dueDate}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Choose Year:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              hint: Text('Select Year'),
              value: selectedYear,
              onChanged: (String? newValue) {
                setState(() {
                  selectedYear = newValue;
                  selectedSemester = null; // Reset semester when year changes
                });
              },
              items: ['1st Year', '2nd Year', '3rd Year']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Choose Semester:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              hint: Text('Select Semester'),
              value: selectedSemester,
              onChanged: (String? newValue) {
                setState(() {
                  selectedSemester = newValue;
                });
              },
              items: selectedYear != null
                  ? ['1st Semester', '2nd Semester']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList()
                  : [],
            ),
            SizedBox(height: 20),
            Text(
              'Choose Payment Method:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            RadioListTile<String>(
              title: Text('eSewa'),
              value: 'eSewa',
              groupValue: selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,  // Checkbox on the right side
            ),
            RadioListTile<String>(
              title: Text('Credit/Debit Card'),
              value: 'Credit/Debit Card',
              groupValue: selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,  // Checkbox on the right side
            ),
            RadioListTile<String>(
              title: Text('Bank Transfer'),
              value: 'Bank Transfer',
              groupValue: selectedPaymentMethod,
              onChanged: (String? value) {
                setState(() {
                  selectedPaymentMethod = value;
                });
              },
              controlAffinity: ListTileControlAffinity.trailing,  // Checkbox on the right side
            ),
            Spacer(),  // Pushes the Proceed button to the bottom
            ElevatedButton(
              onPressed: selectedYear != null && selectedSemester != null && selectedPaymentMethod != null
                  ? () {
                _handlePayment();
              }
                  : null,  // Disable the button if any selection is missing
              child: Text('Proceed'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),  // Full-width button
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handlePayment() {
    _showPaymentSuccessDialog(context);
  }

  void _showPaymentSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Payment Successful'),
        content: Text(
            'You have successfully paid via $selectedPaymentMethod for $selectedYear, $selectedSemester.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }
}