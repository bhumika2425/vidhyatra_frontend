import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../controllers/AppointmentBookingController.dart';

class AppointmentBookingScreen extends StatelessWidget {
  final Map<String, dynamic> teacher;
  final Map<String, dynamic> slot;

  AppointmentBookingScreen({
    Key? key,
    required this.teacher,
    required this.slot,
  }) : super(key: key);

  final controller = Get.put(AppointmentBookingController());

  @override
  Widget build(BuildContext context) {
    final slotDate = DateTime.parse(slot['date']);
    final formattedDate = DateFormat('MMM dd, yyyy').format(slotDate);
    final startTime = slot['start_time'].substring(0, 5);
    final endTime = slot['end_time'].substring(0, 5);

    return Scaffold(
      backgroundColor: Colors.grey[200], // Changed background to grey[200]
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF186CAC),
        title: Text(
          'Confirm Booking',
          style: GoogleFonts.poppins(
            // Changed to Poppins
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w600,
          ),
        ),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Colors.white, // Changed card color to white
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: GoogleFonts.poppins(
                        // Changed to Poppins
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildDetailRow(Icons.person, 'Teacher', teacher['name']),
                    _buildDetailRow(Icons.calendar_today, 'Date', formattedDate),
                    _buildDetailRow(Icons.access_time, 'Time', '$startTime - $endTime'),
                    _buildDetailRow(Icons.confirmation_number, 'Slot ID', '${slot['slot_id']}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Reason for Appointment',
              style: GoogleFonts.poppins(
                // Changed to Poppins
                fontSize: 22,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.reasonController,
              maxLines: 3,
              style: GoogleFonts.poppins(), // Changed to Poppins
              decoration: InputDecoration(
                hintText: 'Briefly describe why you need this appointment...',
                hintStyle: GoogleFonts.poppins(
                  // Changed to Poppins
                  color: Colors.grey.shade600,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF186CAC).withOpacity(0.5), // Unfocused border color
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF186CAC).withOpacity(0.5), // Unfocused border color
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: Color(0xFF186CAC), // Focused border color
                    width: 2.0, // Slightly thicker for emphasis
                  ),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Added proper padding
                child: ElevatedButton(
                  onPressed: controller.isSubmitting.value
                      ? null
                      : () => controller.bookAppointment(
                    slot: slot,
                    context: context,
                    teacher: teacher,
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepOrange, // Changed to orange
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10.0,
                      vertical: 13.0,
                    ), // Proper padding for text
                    minimumSize: Size(0, 0), // Allow button to shrink to content
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap, // Reduce extra tap area
                  ),
                  child: controller.isSubmitting.value
                      ? const SizedBox(
                    width: 20,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                      : Text(
                    'Book Appointment',
                    style: GoogleFonts.poppins(
                      // Changed to Poppins
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          Text(
            '$label:',
            style: GoogleFonts.poppins(
              // Changed to Poppins
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                // Changed to Poppins
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
            ),
          ),
        ],
      ),
    );
  }
}