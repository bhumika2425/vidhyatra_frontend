import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:flutter/material.dart' as flutter;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:open_filex/open_filex.dart';
import 'package:vidhyatra_flutter/controllers/LoginController.dart';

import '../models/PaymentHistoryModel.dart';

class PaymentDetailsView extends StatelessWidget {
  final PaymentHistoryModel payment;
  final isGenerating = false.obs;
  final pdfFile = Rx<File?>(null);

  PaymentDetailsView({Key? key, required this.payment}) : super(key: key);

  final LoginController loginController = Get.put(LoginController());

  String capitalizeFirst(String s) =>
      s.isNotEmpty ? s[0].toUpperCase() + s.substring(1) : s;

  // Format dates properly
  String formatDate(String dateStr) {
    if (dateStr.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMM dd, yyyy').format(date);
    } catch (e) {
      return 'N/A';
    }
  }

  Future<Uint8List> _generatePdfIsolate(PaymentHistoryModel payment) async {

    final pdf = pw.Document();

    // Font loading with fallback to default fonts
    pw.Font? font;
    pw.Font? boldFont;
    try {
      final fontData = await rootBundle.load('assets/fonts/Roboto-Regular.ttf');
      final boldFontData = await rootBundle.load('assets/fonts/Roboto-Bold.ttf');

      if (fontData.lengthInBytes == 0) {
        throw Exception('Roboto-Regular.ttf is empty or not found');
      }
      if (boldFontData.lengthInBytes == 0) {
        throw Exception('Roboto-Bold.ttf is empty or not found');
      }

      print('Roboto-Regular.ttf loaded: ${fontData.lengthInBytes} bytes');
      print('Roboto-Bold.ttf loaded: ${boldFontData.lengthInBytes} bytes');

      font = pw.Font.ttf(fontData);
      boldFont = pw.Font.ttf(boldFontData);
    } catch (e) {
      print('Font loading failed: $e. Using default PDF fonts.');
      font = pw.Font.helvetica();
      boldFont = pw.Font.helveticaBold();
    }

    // Create PDF theme with fonts
    final myTheme = pw.ThemeData.withFont(base: font, bold: boldFont);

    // Format currency
    final formatCurrency = NumberFormat("#,##0.00", "en_US");

    // Generate placeholder logo
    Uint8List? placeholderLogo;
    try {
      placeholderLogo = await _generateLogoPlaceholder();
    } catch (e) {
      print('Logo generation failed: $e. Skipping logo.');
    }

    try {
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: myTheme,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                // Header
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    placeholderLogo != null
                        ? pw.Container(
                      width: 60,
                      height: 60,
                      child: pw.Image(pw.MemoryImage(placeholderLogo)),
                    )
                        : pw.SizedBox(width: 60, height: 60),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text('Vidhyatra College App',
                            style: pw.TextStyle(
                                fontSize: 18,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue800)),
                        pw.Text('Pokhara-12, Nepal'),
                        pw.Text('support@vidhyatra.edu'),
                        pw.Text('www.vidhyatra.edu'),
                        pw.Text('Phone: 061-4567890'),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 10),
                pw.Divider(color: PdfColors.grey400),

                // Title
                pw.Center(
                  child: pw.Text(
                    'Payment Receipt',
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.blue800,
                    ),
                  ),
                ),
                pw.SizedBox(height: 20),

                // Receipt Info
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.start,
                      children: [
                        pw.Text('Receipt No: ${payment.paidFeesId ?? 'N/A'}',
                            style: const pw.TextStyle(fontSize: 14)),
                        pw.Text(
                            'Date: ${formatDate(payment.paidDate.isNotEmpty ? payment.paidDate : payment.createdAt)}',
                            style: const pw.TextStyle(fontSize: 14)),
                      ],
                    ),
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Text(
                          'Status: ${capitalizeFirst(payment.status ?? 'unknown')}',
                          style: pw.TextStyle(
                            fontSize: 14,
                            fontWeight: pw.FontWeight.bold,
                            color: payment.status == 'paid'
                                ? PdfColors.green600
                                : PdfColors.orange600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),

                // Student and Payment Details
                pw.Container(
                  padding: const pw.EdgeInsets.all(10),
                  decoration: pw.BoxDecoration(
                    border: pw.Border.all(color: PdfColors.grey300),
                    borderRadius: pw.BorderRadius.circular(5),
                  ),
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('Student Details',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('Student Email: ${loginController.user.value?.email ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Student Email: ${loginController.user.value?.collegeId ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Academic Year: 2025',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Student ID: ${payment.userId ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.SizedBox(height: 10),
                      pw.Text('Payment Details',
                          style: pw.TextStyle(
                              fontSize: 16, fontWeight: pw.FontWeight.bold)),
                      pw.SizedBox(height: 5),
                      pw.Text('Fee Type: ${payment.feeType ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Description: ${payment.feeDescription ?? 'N/A'}',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Academic Year: 2025',
                          style: const pw.TextStyle(fontSize: 14)),
                      pw.Text(
                          'Payment Method: ${capitalizeFirst(payment.paymentMethod ?? 'unknown')}',
                          style: const pw.TextStyle(fontSize: 14)),
                      // pw.Text('Fee ID: ${payment.feeId ?? 'N/A'}',
                      //     style: const pw.TextStyle(fontSize: 14)),
                      // pw.Text('Due Date: ${formatDate(payment.dueDate ?? '')}',
                      //     style: const pw.TextStyle(fontSize: 14)),
                      pw.Text('Paid at: ${formatDate(payment.createdAt ?? '')}',
                          style: const pw.TextStyle(fontSize: 14)),
                      // pw.Text('Updated At: ${formatDate(payment.updatedAt ?? '')}',
                      //     style: const pw.TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
                pw.SizedBox(height: 20),

                // Fee Breakdown Table
                pw.Text('Fee Breakdown',
                    style: pw.TextStyle(
                        fontSize: 16, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 5),
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  columnWidths: {
                    0: const pw.FlexColumnWidth(3),
                    1: const pw.FlexColumnWidth(1),
                  },
                  children: [
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Description',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Amount (Rs.)',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                    pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(payment.feeType ?? 'N/A',
                              style: const pw.TextStyle(fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              formatCurrency.format(payment.feeAmount ?? 0.0),
                              style: const pw.TextStyle(fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                    if ((payment.totalPrice ?? 0.0) > (payment.feeAmount ?? 0.0))
                      pw.TableRow(
                        children: [
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text('Additional Charges',
                                style: const pw.TextStyle(fontSize: 14)),
                          ),
                          pw.Padding(
                            padding: const pw.EdgeInsets.all(8),
                            child: pw.Text(
                                formatCurrency.format(
                                    (payment.totalPrice ?? 0.0) -
                                        (payment.feeAmount ?? 0.0)),
                                style: const pw.TextStyle(fontSize: 14),
                                textAlign: pw.TextAlign.right),
                          ),
                        ],
                      ),
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.blue50),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Total',
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                              formatCurrency.format(payment.totalPrice ?? 0.0),
                              style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold,
                                  fontSize: 14),
                              textAlign: pw.TextAlign.right),
                        ),
                      ],
                    ),
                  ],
                ),
                pw.SizedBox(height: 20),
              ],
            );
          },
        ),
      );

      return await pdf.save();
    } catch (e) {
      print('Error in PDF generation: $e');
      // Fallback PDF with default fonts
      pdf.addPage(
        pw.Page(
          pageFormat: PdfPageFormat.a4,
          theme: myTheme,
          build: (pw.Context context) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Text('Payment Receipt',
                    style: pw.TextStyle(
                        fontSize: 24, fontWeight: pw.FontWeight.bold)),
                pw.SizedBox(height: 20),
                pw.Text('Paid Fee ID: ${payment.paidFeesId ?? 'N/A'}'),
                pw.Text('Fee Type: ${payment.feeType ?? 'N/A'}'),
                pw.Text('Description: ${payment.feeDescription ?? 'N/A'}'),
                pw.Text('Total Amount: Rs. ${payment.totalPrice ?? '0.0'}'),
                pw.Text(
                    'Payment Method: ${capitalizeFirst(payment.paymentMethod ?? 'unknown')}'),
                pw.Text('Status: ${capitalizeFirst(payment.status ?? 'unknown')}'),
                if (payment.payment != null) ...[
                  pw.Text(
                      'Transaction ID: ${payment.payment!.transactionId ?? 'N/A'}'),
                  pw.Text('Amount: Rs. ${payment.payment!.amount ?? '0.0'}'),
                  pw.Text(
                      'Status: ${capitalizeFirst(payment.payment!.status ?? 'unknown')}'),
                  pw.Text(
                      'Payment Date: ${formatDate(payment.payment!.paymentDate ?? '')}'),
                ],
              ],
            );
          },
        ),
      );
      return await pdf.save();
    }
  }

  Future<Uint8List> _generateLogoPlaceholder() async {
    final recorder = ui.PictureRecorder();
    final canvas = ui.Canvas(recorder);
    final size = ui.Size(100, 100);
    final paint = ui.Paint()..color = ui.Color.fromARGB(255, 55, 71, 79);

    // Draw a square
    canvas.drawRect(ui.Rect.fromLTWH(0, 0, size.width, size.height), paint);

    // Add text
    final textPainter = flutter.TextPainter(
      text: flutter.TextSpan(
        text: 'V',
        style: flutter.TextStyle(
          color: flutter.Colors.white,
          fontSize: 40,
          fontWeight: flutter.FontWeight.bold,
        ),
      ),
      textDirection: flutter.TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      ui.Offset(
        (size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2,
      ),
    );

    final picture = recorder.endRecording();
    final img = await picture.toImage(size.width.toInt(), size.height.toInt());
    final byteData = await img.toByteData(format: ui.ImageByteFormat.png);

    return byteData!.buffer.asUint8List();
  }


  Future<void> _openPdf(flutter.BuildContext context) async {
    try {
      isGenerating.value = true;

      if (pdfFile.value == null) {
        // Generate PDF if not already generated
        final bytes = await _generatePdfIsolate(payment);
        final tempDir = await getTemporaryDirectory();
        final fileName =
            'receipt_${payment.paidFeesId}_${DateFormat('yyyyMMdd').format(DateTime.now())}.pdf';
        final file = File('${tempDir.path}/$fileName');
        await file.writeAsBytes(bytes);
        pdfFile.value = file;
      }

      final result = await OpenFilex.open(pdfFile.value!.path);
      print('File open result: ${result.message}');
      if (result.type != ResultType.done) {
        final saveLocation = Platform.isAndroid ? 'Downloads folder' : 'Documents';
        Get.snackbar(
          'Cannot Open File',
          'Unable to open the PDF. Try downloading it to find it in your $saveLocation.',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('Error opening PDF: $e');
      Get.snackbar(
        'Error',
        'Could not open the file: $e',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isGenerating.value = false;
    }
  }

  @override
  flutter.Widget build(flutter.BuildContext context) {
    return flutter.Scaffold(
      backgroundColor: flutter.Colors.grey[100],
      appBar: flutter.AppBar(
        iconTheme: const flutter.IconThemeData(color: flutter.Colors.white),
        backgroundColor: const flutter.Color(0xFF186CAC),
        title: flutter.Text(
          'Payment Details',
          style: GoogleFonts.poppins(
            color: flutter.Colors.white,
            fontSize: 20,
            fontWeight: flutter.FontWeight.w600,
          ),
        ),
      ),
      body: flutter.SafeArea(
        child: flutter.SingleChildScrollView(
          padding: const flutter.EdgeInsets.all(20),
          child: flutter.Column(
            crossAxisAlignment: flutter.CrossAxisAlignment.start,
            children: [
              _buildCard(
                title: 'Fee Information',
                children: [
                  _buildDetailRow('Fee Type', payment.feeType ?? 'N/A', context),
                  _buildDetailRow('Description', payment.feeDescription ?? 'N/A', context),
                  _buildDetailRow('Total Amount', 'Rs. ${payment.totalPrice ?? '0.0'}', context),
                  _buildDetailRow('Original Fee Amount', 'Rs. ${payment.feeAmount ?? '0.0'}', context),
                  _buildDetailRow(
                    'Due Date',
                    payment.dueDate.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(payment.dueDate))
                        : 'N/A',
                    context,
                  ),
                ],
              ),
              const flutter.SizedBox(height: 20),
              _buildCard(
                title: 'Payment Information',
                children: [
                  _buildDetailRow('Payment Method', payment.paymentMethod ?? 'N/A', context),
                  _buildDetailRow('Status', payment.status ?? 'N/A', context),
                  _buildDetailRow(
                    'Paid Date',
                    payment.paidDate.isNotEmpty
                        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(payment.paidDate))
                        : 'N/A',
                    context,
                  ),
                ],
              ),
              if (payment.payment != null) ...[
                const flutter.SizedBox(height: 20),
                _buildCard(
                  title: 'Transaction Details',
                  children: [
                    _buildDetailRow('Transaction ID', payment.payment!.transactionId ?? 'N/A', context),
                    _buildDetailRow('Amount', 'Rs. ${payment.payment!.amount ?? '0.0'}', context),
                    _buildDetailRow('Status', payment.payment!.status ?? 'N/A', context),
                    _buildDetailRow(
                      'Payment Date',
                      payment.payment!.paymentDate.isNotEmpty
                          ? DateFormat('MMM dd, yyyy').format(DateTime.parse(payment.payment!.paymentDate))
                          : 'N/A',
                      context,
                    ),
                  ],
                ),
              ],
              const flutter.SizedBox(height: 24),
              Obx(() => flutter.Padding(
                padding: const flutter.EdgeInsets.only(top: 16.0),
                child: flutter.Center(
                  child: flutter.ElevatedButton.icon(
                    onPressed: isGenerating.value ? null : () => _openPdf(context),
                    icon: isGenerating.value
                        ? const flutter.SizedBox(
                      width: 20,
                      height: 20,
                      child: flutter.CircularProgressIndicator(
                        color: flutter.Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                        : const flutter.Icon(flutter.Icons.file_open, size: 20),
                    label: flutter.Text(
                      isGenerating.value ? 'Generating...' : 'Open Fee Receipt',
                      style: GoogleFonts.poppins(
                        fontSize: 15,
                        fontWeight: flutter.FontWeight.w600,
                      ),
                    ),
                    style: flutter.ElevatedButton.styleFrom(
                      backgroundColor: const flutter.Color(0xFF186CAC),
                      foregroundColor: flutter.Colors.white,
                      padding: const flutter.EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      shape: flutter.RoundedRectangleBorder(
                        borderRadius: flutter.BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }

  flutter.Widget _buildCard({required String title, required List<flutter.Widget> children}) {
    return flutter.AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: flutter.Curves.easeInOut,
      child: flutter.Card(
        elevation: 3,
        shape: flutter.RoundedRectangleBorder(
          borderRadius: flutter.BorderRadius.circular(16),
        ),
        child: flutter.Container(
          decoration: flutter.BoxDecoration(
            borderRadius: flutter.BorderRadius.circular(16),
            gradient: flutter.LinearGradient(
              colors: [flutter.Colors.white, flutter.Colors.grey[50]!],
              begin: flutter.Alignment.topLeft,
              end: flutter.Alignment.bottomRight,
            ),
          ),
          child: flutter.Padding(
            padding: const flutter.EdgeInsets.all(20),
            child: flutter.Column(
              crossAxisAlignment: flutter.CrossAxisAlignment.start,
              children: [
                flutter.Row(
                  children: [
                    const flutter.Icon(
                      flutter.Icons.info_outline,
                      color: flutter.Colors.deepOrange,
                      size: 24,
                    ),
                    const flutter.SizedBox(width: 8),
                    flutter.Text(
                      title,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: flutter.FontWeight.w600,
                        color: const flutter.Color(0xFF186CAC),
                      ),
                    ),
                  ],
                ),
                const flutter.SizedBox(height: 12),
                ...children,
              ],
            ),
          ),
        ),
      ),
    );
  }

  flutter.Widget _buildDetailRow(String label, String value, flutter.BuildContext context) {
    return flutter.Padding(
      padding: const flutter.EdgeInsets.symmetric(vertical: 6),
      child: flutter.Row(
        crossAxisAlignment: flutter.CrossAxisAlignment.start,
        children: [
          flutter.Text(
            '$label: ',
            style: GoogleFonts.poppins(
              fontWeight: flutter.FontWeight.w600,
              fontSize: 14,
              color: flutter.Colors.black,
            ),
          ),
          flutter.Expanded(
            child: flutter.Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: flutter.FontWeight.w400,
                color: flutter.Colors.grey[700],
              ),
              softWrap: true,
              overflow: flutter.TextOverflow.clip,
            ),
          ),
        ],
      ),
    );
  }
}