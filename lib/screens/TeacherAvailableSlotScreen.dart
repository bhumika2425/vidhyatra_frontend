import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/TeacherAvailableSlotController.dart';
import 'AppointmentBookingScreen.dart';

class TeacherAvailableSlotsScreen extends StatelessWidget {
  final Map<String, dynamic> teacher;

  const TeacherAvailableSlotsScreen({Key? key, required this.teacher}) : super(key: key);

  @override
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TeacherAvailableSlotsController(teacher));

    return Scaffold(
      appBar: AppBar(
        title: Text('Book with ${teacher['name']}'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchAvailableSlots,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.errorMessage.value != null) {
            return _buildErrorWidget(controller);
          } else {
            return _buildContentWidget(context, controller);
          }
        }),
      ),
    );
  }


  Widget _buildErrorWidget(TeacherAvailableSlotsController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(controller.errorMessage.value ?? ''),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: controller.fetchAvailableSlots,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildContentWidget(BuildContext context, TeacherAvailableSlotsController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTeacherInfoCard(context),
          const SizedBox(height: 24),
          Text('Select Date', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          _buildDateSelection(controller),
          const SizedBox(height: 24),
          Text('Available Time Slots', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 16),
          Obx(() {
            if (controller.availableSlots.isEmpty) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No available slots found')));
            } else if (controller.filteredSlots.isEmpty) {
              return const Center(
                  child: Padding(
                      padding: EdgeInsets.all(32.0),
                      child: Text('No slots for selected date')));
            } else {
              return _buildTimeSlots(context, controller);
            }
          }),
        ],
      ),
    );
  }

  Widget _buildTeacherInfoCard(BuildContext context) {
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
                  Text(teacher['name'], style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(teacher['department'] ?? 'Teacher'),
                  const SizedBox(height: 8),
                  if (teacher['rating'] != null)
                    Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text('${teacher['rating']}', style: Theme.of(context).textTheme.bodySmall),
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

  Widget _buildDateSelection(TeacherAvailableSlotsController controller) {
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
                  color: isSelected ? Theme.of(context).primaryColor : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Theme.of(context).primaryColor : Colors.grey.shade300,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'][date.weekday - 1],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.grey.shade600,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      date.day.toString(),
                      style: TextStyle(
                        fontSize: 22,
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${date.month}/${date.year.toString().substring(2)}',
                      style: TextStyle(
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

  Widget _buildTimeSlots(BuildContext context, TeacherAvailableSlotsController controller) {
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
          onTap: () => Get.to(() => AppointmentBookingScreen(teacher: teacher, slot: slot)),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Theme.of(context).primaryColor.withOpacity(0.3)),
            ),
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(timeSlot,
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold,
                    )),
                const SizedBox(height: 4),
                Text('Available', style: TextStyle(fontSize: 12, color: Colors.green.shade700)),
              ],
            ),
          ),
        );
      },
    );
  }
}
