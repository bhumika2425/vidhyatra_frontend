// lib/views/AppointmentBookingScreen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      appBar: AppBar(
        title: Text('Confirm Booking'),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Appointment Details',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Briefly describe why you need this appointment...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                contentPadding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 32),
            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: controller.isSubmitting.value
                    ? null
                    : () => controller.bookAppointment(
                  slot: slot,
                  context: context,
                  teacher: teacher,
                ),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: controller.isSubmitting.value
                    ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
                    : const Text('Book Appointment', style: TextStyle(fontSize: 16)),
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
            style: TextStyle(
              color: Colors.grey.shade600,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }
}
