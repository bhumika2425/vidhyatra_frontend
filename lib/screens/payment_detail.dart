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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,  // Center the column
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Payment title
                Text(
                  '${widget.paymentInfo.title} Payment',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),

                // Amount and Due Date
                Text(
                  'Amount: ${widget.paymentInfo.amount}',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                Text(
                  'Due Date: ${widget.paymentInfo.dueDate}',
                  style: TextStyle(fontSize: 18),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),

                // Year Dropdown
                _buildDropdown(
                  label: 'Choose Year:',
                  value: selectedYear,
                  items: ['1st Year', '2nd Year', '3rd Year'],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedYear = newValue;
                      selectedSemester = null; // Reset semester when year changes
                    });
                  },
                ),
                SizedBox(height: 20),

                // Semester Dropdown
                _buildDropdown(
                  label: 'Choose Semester:',
                  value: selectedSemester,
                  items: selectedYear != null
                      ? ['1st Semester', '2nd Semester']
                      : [],
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedSemester = newValue;
                    });
                  },
                ),
                SizedBox(height: 20),

                // Payment Method Radio Buttons
                Text(
                  'Choose Payment Method:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                _buildRadioButton('eSewa'),
                _buildRadioButton('Credit/Debit Card'),
                _buildRadioButton('Bank Transfer'),
                SizedBox(height: 30),

                // Proceed Button
                ElevatedButton(
                  onPressed: selectedYear != null &&
                      selectedSemester != null &&
                      selectedPaymentMethod != null
                      ? () {
                    _handlePayment();
                  }
                      : null, // Disable if selections are missing
                  child: Text('Proceed'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function to create dropdown menus
  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        DropdownButton<String>(
          isExpanded: true,
          value: value,
          onChanged: onChanged,
          hint: Text('Select'),
          items: items
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ],
    );
  }

  // Helper function to create radio buttons for payment methods
  Widget _buildRadioButton(String title) {
    return RadioListTile<String>(
      title: Text(title),
      value: title,
      groupValue: selectedPaymentMethod,
      onChanged: (String? value) {
        setState(() {
          selectedPaymentMethod = value;
        });
      },
      controlAffinity: ListTileControlAffinity.trailing, // Radio on the right side
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
