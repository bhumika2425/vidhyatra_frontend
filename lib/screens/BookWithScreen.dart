import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../controllers/TeacherAvailableSlotController.dart';
import 'ConfirmBooking.dart';

class BookWithScreen extends StatelessWidget {
  final Map<String, dynamic> teacher; //variable inside the widget that will hold information about a teacher

  const BookWithScreen({Key? key, required this.teacher}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherAvailableSlotsController(teacher));
    final deepOrangeColor = Colors.deepOrange;

    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Get.back(),
        ),
        backgroundColor: const Color(0xFF186CAC),
        title: Text('Book with ${teacher['name']}',
          style: GoogleFonts.poppins(color: Colors.white, fontSize: 19),),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchAvailableSlots,
            color: Colors.white,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator(color: Colors.deepOrange));
          } else if (controller.errorMessage.value != null) {
            return _buildErrorWidget(controller, deepOrangeColor);
          } else {
            return _buildContentWidget(context, controller, deepOrangeColor);
          }
        }),
      ),
    );
  }


  Widget _buildErrorWidget(TeacherAvailableSlotsController controller, Color themeColor) {
    //using controller to get error info and retry action
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            controller.errorMessage.value ?? '',
            style: GoogleFonts.poppins(),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
            ),
            onPressed: controller.fetchAvailableSlots,
            child: Text(
              'Retry',
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context, TeacherAvailableSlotsController controller, Color themeColor) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher info card removed from here
          Text(
            'Select Date',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildDateSelection(controller, themeColor),
          const SizedBox(height: 24),
          Text(
            'Available Time Slots',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.availableSlots.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No available slots found',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            } else if (controller.filteredSlots.isEmpty) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.all(32.0),
                  child: Text(
                    'No slots for selected date',
                    style: GoogleFonts.poppins(),
                  ),
                ),
              );
            } else {
              return _buildTimeSlots(context, controller, themeColor);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTeacherInfoCard(BuildContext context, Color themeColor) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            // CircleAvatar(
            //   radius: 30,
            //   backgroundColor: Colors.grey.shade200,
            //   backgroundImage: teacher['image'] != null ? NetworkImage(teacher['image']) : null,
            //   child: teacher['image'] == null
            //       ? Text(teacher['name'].substring(0, 1).toUpperCase(), style: const TextStyle(fontSize: 24))
            //       : null,
            // ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    teacher['name'],
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    teacher['department'] ?? 'Teacher',
                    style: GoogleFonts.poppins(fontSize: 14),
                  ),
                  const SizedBox(height: 8),
                  if (teacher['rating'] != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '${teacher['rating']}',
                          style: GoogleFonts.poppins(fontSize: 12),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelection(TeacherAvailableSlotsController controller, Color themeColor) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: 14,
        itemBuilder: (context, index) {
          final date = DateTime.now().add(Duration(days: index));
          return Obx(() { // Move Obx here
            final isSelected = controller.selectedDate.value.year == date.year &&
                controller.selectedDate.value.month == date.month &&
                controller.selectedDate.value.day == date.day;

            return GestureDetector(
              onTap: () => controller.onDateSelected(date),
              child: Container(
                width: 70,
                margin: const EdgeInsets.only(right: 12),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.deepOrange : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.deepOrange : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                      style: GoogleFonts.poppins(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date.day.toString(),
                      style: GoogleFonts.poppins(
                        fontSize: 22,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.month}/${date.year.toString().substring(2)}',
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        },
      ),
    );
  }

  Widget _buildTimeSlots(BuildContext context, TeacherAvailableSlotsController controller, Color themeColor) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.filteredSlots.length,
      itemBuilder: (context, index) {
        final slot = controller.filteredSlots[index];
        final startTime = slot['start_time'].substring(0, 5);
        final endTime = slot['end_time'].substring(0, 5);
        final timeSlot = '$startTime - $endTime';

        return GestureDetector(
          onTap: () => Get.to(() => ConfirmBooking(teacher: teacher, slot: slot)),
          child: Container(
            decoration: BoxDecoration(
              color: Color(0xFF186CAC).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF186CAC).withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    timeSlot,
                    style: GoogleFonts.poppins(
                      color: Color(0xFF186CAC),
                      fontWeight: FontWeight.bold,
                    )
                ),
                const SizedBox(height: 4),
                Text(
                    'Available',
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        color: Colors.green.shade700
                    )
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}