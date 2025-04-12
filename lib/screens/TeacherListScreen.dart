import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:vidhyatra_flutter/controllers/AppointmentBookingController.dart';
import 'package:vidhyatra_flutter/controllers/TeacherListController.dart';
import 'TeacherAvailableSlotScreen.dart';

class TeacherListScreen extends StatelessWidget {
  const TeacherListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TeacherListController controller = Get.put(TeacherListController());
    final AppointmentBookingController appointmentController = Get.put(AppointmentBookingController());
    final TextEditingController searchController = TextEditingController();

    // Sync searchController with controller.searchQuery
    ever(controller.searchQuery, (String query) {
      if (searchController.text != query) {
        searchController.text = query;
      }
    });

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Obx(
              () => controller.isSearchActive.value
              ? TextField(
            controller: searchController,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Search by teacher name',
              border: InputBorder.none,
            ),
            onChanged: (value) => controller.updateSearchQuery(value),
          )
              : const Text('Book Appointment'),
        ),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
              controller.isSearchActive.value ? Icons.close : Icons.search,
            )),
            onPressed: () {
              controller.toggleSearch();
              if (!controller.isSearchActive.value) {
                searchController.clear();
              }
            },
          ),
        ],
      ),
      body: Obx(
            () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Select a Teacher',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            // Department filter chips
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('All Departments'),
                    selected: controller.selectedDepartment.value == 'All Departments',
                    onSelected: (bool selected) {
                      controller.updateDepartment('All Departments');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('BIT'),
                    selected: controller.selectedDepartment.value == 'BIT',
                    onSelected: (bool selected) {
                      controller.updateDepartment('BIT');
                    },
                  ),
                  const SizedBox(width: 8),
                  FilterChip(
                    label: const Text('BBA'),
                    selected: controller.selectedDepartment.value == 'BBA',
                    onSelected: (bool selected) {
                      controller.updateDepartment('BBA');
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Booked Appointments Section
            ExpansionTile(
              title: Text(
                'My Booked Appointments',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              initiallyExpanded: false,
              children: [
                Obx(
                      () => appointmentController.studentAppointments.isEmpty
                      ? const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: Text('No appointments booked.'),
                  )
                      : ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: appointmentController.studentAppointments.length,
                    itemBuilder: (context, index) {
                      final appointment = appointmentController.studentAppointments[index];
                      return ListTile(
                        leading: Icon(
                          appointment.status == 'confirmed'
                              ? Icons.check_circle
                              : Icons.pending,
                          color: appointment.status == 'confirmed'
                              ? Colors.green
                              : Colors.orange,
                        ),
                        title: Text(
                          'With ${appointment.timeSlot.teacher.name}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(appointment.timeSlot.date))}'),
                            Text(
                                'Time: ${appointment.timeSlot.startTime.substring(0, 5)} - ${appointment.timeSlot.endTime.substring(0, 5)}'),
                            Text('Reason: ${appointment.reason}'),
                            Text('Status: ${appointment.status.capitalize}'),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Teacher list
            Expanded(
              child: controller.getFilteredTeachers().isEmpty
                  ? const Center(child: Text('No teachers found'))
                  : ListView.builder(
                itemCount: controller.getFilteredTeachers().length,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                itemBuilder: (context, index) {
                  final teacher = controller.getFilteredTeachers()[index];
                  return TeacherCard(
                    name: teacher['name'],
                    department: teacher['department'],
                    isAvailable: teacher['available'],
                    // image: teacher['image'],
                    appointmentsBooked: teacher['appointmentsBooked'],
                    totalTimeSlots: teacher['totalTimeSlots'],
                    onTap: () {
                      if (teacher['available'] &&
                          teacher['appointmentsBooked'] < teacher['totalTimeSlots']) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => TeacherAvailableSlotsScreen(teacher: teacher),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TeacherCard extends StatelessWidget {
  final String name;
  final String department;
  final bool isAvailable;
  // final String image;
  final int appointmentsBooked;
  final int totalTimeSlots;
  final VoidCallback onTap;

  const TeacherCard({
    Key? key,
    required this.name,
    required this.department,
    required this.isAvailable,
    // required this.image,
    required this.appointmentsBooked,
    required this.totalTimeSlots,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canBook = isAvailable && appointmentsBooked < totalTimeSlots;

    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: canBook ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 30,
                // backgroundImage: AssetImage(image),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      department,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable ? Colors.green.shade50 : Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAvailable ? Icons.check_circle : Icons.cancel,
                                size: 16,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isAvailable ? 'Available' : 'Not Available',
                                style: TextStyle(
                                  color: isAvailable ? Colors.green : Colors.red,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade50,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: 16,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$appointmentsBooked/$totalTimeSlots booked',
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (canBook)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey,
                ),
            ],
          ),
        ),
      ),
    );
  }
}