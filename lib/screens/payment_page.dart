import 'package:flutter/material.dart';
import 'package:vidhyatra_flutter/screens/payment_detail.dart';
import '../models/payment_info.dart';  // Updated import

class PaymentPage extends StatelessWidget {
  // Define the PaymentCard widget as a method within the PaymentPage class
  Widget paymentCard({
    required String title,
    required String dueDate,
    required String amount,
    required String description,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,  // Trigger the payment functionality on tap
      child: Card(
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF971F20),
                ),
              ),
              SizedBox(height: 5),
              Text(
                dueDate,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Amount: $amount',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 10),
              Text(
                description,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fees Payment', style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xFF971F20),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // University Fee Section
            paymentCard(
              title: 'University Fee',
              dueDate: 'Due every 3 years',
              amount: 'Rs. 1,00,000',
              description:
              'The university fee is due once every three years. It covers your university registration, examination infrastructure, and other essential academic facilities.',
              onPressed: () {
                // Create PaymentInfo object and pass it to the PaymentDetailPage
                PaymentInfo paymentInfo = PaymentInfo(
                  title: 'University Fee',
                  amount: 'Rs. 1,00,000',
                  dueDate: 'Dec 2024',
                  description:
                  'The university fee is due once every three years. It covers your university registration, examination infrastructure, and other essential academic facilities.',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentDetailPage(paymentInfo: paymentInfo),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Semester Fee Section
            paymentCard(
              title: 'Semester Fee',
              dueDate: 'Paid twice a year',
              amount: 'Rs. 69,000',
              description:
              'This fee is paid every semester (twice a year) and covers tuition, library services, lab access, and other resources.',
              onPressed: () {
                // Create PaymentInfo object and pass it to the PaymentDetailPage
                PaymentInfo paymentInfo = PaymentInfo(
                  title: 'Semester Fee',
                  amount: 'Rs. 69,000',
                  dueDate: 'Jan 2024',
                  description:
                  'This fee is paid every semester (twice a year) and covers tuition, library services, lab access, and other resources.',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentDetailPage(paymentInfo: paymentInfo),
                  ),
                );
              },
            ),
            SizedBox(height: 20),
            // Exam Fee Section
            paymentCard(
              title: 'Exam Fee',
              dueDate: 'Paid once a year',
              amount: 'Rs. 1,500',
              description:
              'This fee is paid yearly and covers all academic examination costs, including exam materials and administration.',
              onPressed: () {
                // Create PaymentInfo object and pass it to the PaymentDetailPage
                PaymentInfo paymentInfo = PaymentInfo(
                  title: 'Exam Fee',
                  amount: 'Rs. 1,500',
                  dueDate: 'May 2024',
                  description:
                  'This fee is paid yearly and covers all academic examination costs, including exam materials and administration.',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PaymentDetailPage(paymentInfo: paymentInfo),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}