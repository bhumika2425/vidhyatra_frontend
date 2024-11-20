import 'dart:io';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:flutter/services.dart' show ByteData, Uint8List, rootBundle;

class PaymentReceiptPage extends StatelessWidget {
  final String studentName;
  final String feeType;
  final String amountPaid;
  final String transactionDate;

  PaymentReceiptPage({
    required this.studentName,
    required this.feeType,
    required this.amountPaid,
    required this.transactionDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Receipt'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await generatePDF();
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Receipt downloaded successfully')),
            );
          },
          child: Text('Download Receipt'),
        ),
      ),
    );
  }

  Future<void> generatePDF() async {
    final pdf = pw.Document();
    final logoImage = await _loadLogo(); // Load college logo

    // Create the PDF layout
    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'Informatics College Pokhara',
                    style: pw.TextStyle(
                      fontSize: 20,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Image(logoImage, height: 80, width: 80), // Display college logo
                ],
              ),
              pw.SizedBox(height: 10),
              pw.Text(
                'Matepani-12, Pokhara',
                style: pw.TextStyle(
                  fontSize: 14,
                  color: PdfColors.grey,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text(
                'Payment Receipt',
                style: pw.TextStyle(
                  fontSize: 18,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.blueAccent,
                ),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Student Name: $studentName'),
              pw.SizedBox(height: 10),
              pw.Text('Amount Paid: Rs. $amountPaid'),
              pw.SizedBox(height: 10),
              pw.Text('Payment For: $feeType'),
              pw.SizedBox(height: 10),
              pw.Text('Transaction Date: $transactionDate'),
              pw.SizedBox(height: 20),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text(
                'Thank you for your payment!',
                style: pw.TextStyle(
                  fontSize: 16,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.green,
                ),
              ),
            ],
          );
        },
      ),
    );

    // Save the PDF file
    final outputDir = await getApplicationDocumentsDirectory();
    final file = File("${outputDir.path}/receipt_$studentName.pdf");
    await file.writeAsBytes(await pdf.save());
  }

  // Function to load logo from assets
  Future<pw.ImageProvider> _loadLogo() async {
    final ByteData bytes = await rootBundle.load('assets/college_logo.png');
    final Uint8List logoData = bytes.buffer.asUint8List();
    return pw.MemoryImage(logoData);
  }
}