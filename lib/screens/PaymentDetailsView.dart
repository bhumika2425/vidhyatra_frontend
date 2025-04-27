import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';

import '../models/PaymentHistoryModel.dart';

class PaymentDetailsView extends StatelessWidget {
  final PaymentHistoryModel payment;
  final isGenerating = false.obs;

  PaymentDetailsView({Key? key, required this.payment}) : super(key: key);

  String capitalizeFirst(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  Future<Uint8List> _generatePdfIsolate(PaymentHistoryModel payment,
      BuildContext context) async {
    final pdf = pw.Document();
    try {
      final fontData = await DefaultAssetBundle.of(context).load(
          'assets/fonts/Roboto-Regular.ttf');
      if (fontData.lengthInBytes == 0) {
        throw Exception('Roboto-Regular.ttf is empty or not found');
      }
      final boldFontData = await DefaultAssetBundle.of(context).load(
          'assets/fonts/Roboto-Bold.ttf');
      if (boldFontData.lengthInBytes == 0) {
        throw Exception('Roboto-Bold.ttf is empty or not found');
      }
      final font = pw.Font.ttf(fontData);
      final boldFont = pw.Font.ttf(boldFontData);

      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text(
                  'Payment Receipt',
                  style: pw.TextStyle(fontSize: 24, font: boldFont),
                ),
                pw.SizedBox(height: 20),
                pw.Text('Paid Fee ID: ${payment.paidFeesId}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Fee Type: ${payment.feeType}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Description: ${payment.feeDescription}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Total Amount: Rs. ${payment.totalPrice}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text(
                    'Payment Method: ${capitalizeFirst(payment.paymentMethod)}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Status: ${capitalizeFirst(payment.status)}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text(
                  'Paid Date: ${payment.paidDate.isNotEmpty
                      ? DateFormat('MMM dd, yyyy').format(
                      DateTime.parse(payment.paidDate))
                      : 'N/A'}',
                  style: pw.TextStyle(fontSize: 16, font: font),
                ),
                pw.Text(
                  'Created At: ${DateFormat('MMM dd, yyyy').format(
                      DateTime.parse(payment.createdAt))}',
                  style: pw.TextStyle(fontSize: 16, font: font),
                ),
                pw.Text(
                  'Updated At: ${DateFormat('MMM dd, yyyy').format(
                      DateTime.parse(payment.updatedAt))}',
                  style: pw.TextStyle(fontSize: 16, font: font),
                ),
                pw.Text('User ID: ${payment.userId}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Fee ID: ${payment.feeId}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text('Original Fee Amount: Rs. ${payment.feeAmount}',
                    style: pw.TextStyle(fontSize: 16, font: font)),
                pw.Text(
                  'Due Date: ${payment.dueDate.isNotEmpty
                      ? DateFormat('MMM dd, yyyy').format(
                      DateTime.parse(payment.dueDate))
                      : 'N/A'}',
                  style: pw.TextStyle(fontSize: 16, font: font),
                ),
                if (payment.payment != null) ...[
                  pw.SizedBox(height: 20),
                  pw.Text('Payment Details:',
                      style: pw.TextStyle(fontSize: 18, font: boldFont)),
                  pw.Text('Transaction ID: ${payment.payment!.transactionId}',
                      style: pw.TextStyle(fontSize: 16, font: font)),
                  pw.Text('Amount: Rs. ${payment.payment!.amount}',
                      style: pw.TextStyle(fontSize: 16, font: font)),
                  pw.Text('Status: ${capitalizeFirst(payment.payment!.status)}',
                      style: pw.TextStyle(fontSize: 16, font: font)),
                  pw.Text(
                    'Payment Date: ${payment.payment!.paymentDate.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(
                        DateTime.parse(payment.payment!.paymentDate))
                        : 'N/A'}',
                    style: pw.TextStyle(fontSize: 16, font: font),
                  ),
                ],
              ],
            );
          },
        ),
      );

      return await pdf.save();
    } catch (e) {
      throw Exception('Failed to load fonts: $e');
    }
  }

  Future<void> _generateAndDownloadPdf(BuildContext context) async {
    try {
      isGenerating.value = true;
      final fontData = await DefaultAssetBundle.of(context).load(
          'assets/fonts/Roboto-Regular.ttf');
      print('Roboto-Regular.ttf size: ${fontData.lengthInBytes} bytes');
      final boldFontData = await DefaultAssetBundle.of(context).load(
          'assets/fonts/Roboto-Bold.ttf');
      print('Roboto-Bold.ttf size: ${boldFontData.lengthInBytes} bytes');
      final bytes = await _generatePdfIsolate(payment, context);
      if (await Permission.storage
          .request()
          .isGranted) {
        final dir = await getApplicationDocumentsDirectory();
        final file = File('${dir.path}/receipt_${payment.paidFeesId}.pdf');
        await file.writeAsBytes(bytes);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Receipt saved to documents'),
            duration: Duration(seconds: 3),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Storage permission is required to save the receipt'),
            duration: Duration(seconds: 3),
          ),
        );
      }
    } catch (e) {
      String errorMessage;
      if (e.toString().contains('RangeError')) {
        errorMessage = 'Failed to load fonts for receipt generation';
      } else if (e.toString().contains('Permission')) {
        errorMessage = 'Permission issue';
      } else {
        errorMessage = 'Failed to generate receipt';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 3),
        ),
      );
      print('Error generating PDF: $e');
    } finally {
      isGenerating.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF186CAC),
        title: Text(
          'Payment Details',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w600,
          ),
        ),

      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'Fee Information',
                children: [
                  _buildDetailRow('Fee Type', payment.feeType, context),
                  _buildDetailRow(
                      'Description', payment.feeDescription, context),
                  _buildDetailRow(
                      'Total Amount', 'Rs. ${payment.totalPrice}', context),
                  _buildDetailRow(
                      'Original Fee Amount', 'Rs. ${payment.feeAmount}',
                      context),
                  _buildDetailRow(
                    'Due Date',
                    payment.dueDate.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(
                        DateTime.parse(payment.dueDate))
                        : 'N/A',
                    context,
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildCard(
                title: 'Payment Information',
                children: [
                  _buildDetailRow(
                      'Payment Method', payment.paymentMethod, context),
                  _buildDetailRow('Status', payment.status, context),
                  _buildDetailRow(
                    'Paid Date',
                    payment.paidDate.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(
                        DateTime.parse(payment.paidDate))
                        : 'N/A',
                    context,
                  ),
                ],
              ),
              if (payment.payment != null) ...[
                const SizedBox(height: 20),
                _buildCard(
                  title: 'Transaction Details',
                  children: [
                    _buildDetailRow(
                        'Transaction ID', payment.payment!.transactionId,
                        context),
                    _buildDetailRow(
                        'Amount', 'Rs. ${payment.payment!.amount}', context),
                    _buildDetailRow('Status', payment.payment!.status, context),
                    _buildDetailRow(
                      'Payment Date',
                      payment.payment!.paymentDate.isNotEmpty
                          ? DateFormat('MMM dd, yyyy').format(
                          DateTime.parse(payment.payment!.paymentDate))
                          : 'N/A',
                      context,
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 24),
              Center(
                child: Obx(() =>
                    ElevatedButton.icon(
                      onPressed: isGenerating.value ? null : () =>
                          _generateAndDownloadPdf(context),
                      icon: isGenerating.value
                          ? const CircularProgressIndicator(
                          color: Colors.white, strokeWidth: 2)
                          : const Icon(Icons.download, size: 20),
                      label: Text(
                        isGenerating.value
                            ? 'Generating...'
                            : 'Download Receipt',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF186CAC),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 2,
                      ),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({required String title, required List<Widget> children}) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [Colors.white, Colors.grey[50]!],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: Colors.deepOrange,
                      size: 24,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF186CAC),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: Colors.black,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Colors.grey[700],
              ),
              softWrap: true,
              overflow: TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}