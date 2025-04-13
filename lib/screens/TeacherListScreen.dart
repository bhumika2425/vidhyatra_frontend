import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
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
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFF186CAC),
        title: Obx(
          () => controller.isSearchActive.value
              ? TextField(
                  controller: searchController,
                  autofocus: true,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search by teacher name',
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                  ),
                  onChanged: (value) => controller.updateSearchQuery(value),
                )
              : Text(
                  'Book Appointment',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                  ),
                ),
        ),
        actions: [
          IconButton(
            icon: Obx(() => Icon(
                  controller.isSearchActive.value ? Icons.close : Icons.search,
                  color: Colors.white,
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
            ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF186CAC),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Text(
                      'Select a Teacher',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  // Department filter chips
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Row(
                      children: [
                        FilterChip(
                          label: Text(
                            'All Departments',
                            style: GoogleFonts.poppins(
                              fontSize: 13,
                              color: Colors.white,
                            ),
                          ),
                          selected: controller.selectedDepartment.value ==
                              'All Departments',
                          selectedColor: Colors.deepOrange,
                          backgroundColor: Color(0xFF186CAC),
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.updateDepartment('All Departments');
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(
                            'BIT',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.white),
                          ),
                          selected:
                              controller.selectedDepartment.value == 'BIT',
                          selectedColor: Colors.deepOrange,
                          backgroundColor: Color(0xFF186CAC),
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.updateDepartment('BIT');
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: Text(
                            'BBA',
                            style: GoogleFonts.poppins(
                                fontSize: 13, color: Colors.white),
                          ),
                          selected:
                              controller.selectedDepartment.value == 'BBA',
                          selectedColor: Colors.deepOrange,
                          backgroundColor: Color(0xFF186CAC),
                          checkmarkColor: Colors.white,
                          onSelected: (bool selected) {
                            controller.updateDepartment('BBA');
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Booked Appointments Section
                  Container(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      // boxShadow: [
                      //   BoxShadow(
                      //     color: Colors.grey.withOpacity(0.1),
                      //     spreadRadius: 1,
                      //     blurRadius: 3,
                      //     offset: const Offset(0, 1),
                      //   ),
                      // ],
                    ),
                    child: ExpansionTile(
                      title: Text(
                        'My Booked Appointments',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                      iconColor: Color(0xFF186CAC),
                      collapsedIconColor: Colors.deepOrange,
                      initiallyExpanded: false,
                      children: [
                        Obx(
                          () => appointmentController
                                  .studentAppointments.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'No appointments booked.',
                                    style: GoogleFonts.poppins(
                                      color: Colors.black54,
                                    ),
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: appointmentController
                                      .studentAppointments.length,
                                  itemBuilder: (context, index) {
                                    final appointment = appointmentController
                                        .studentAppointments[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      child: Card(
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          side: BorderSide(
                                            color: Colors.grey.shade300,
                                            width: 1,
                                          ),
                                        ),
                                        child: ListTile(
                                          leading: Icon(
                                            appointment.status == 'confirmed'
                                                ? Icons.check_circle
                                                : Icons.pending_actions,
                                            color: appointment.status ==
                                                    'confirmed'
                                                ? Colors.green
                                                : Colors.deepOrange,
                                            size: 28,
                                          ),
                                          title: Text(
                                            'With ${appointment.timeSlot.teacher.name}',
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const SizedBox(height: 4),
                                              Text(
                                                'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.parse(appointment.timeSlot.date))}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                'Time: ${appointment.timeSlot.startTime.substring(0, 5)} - ${appointment.timeSlot.endTime.substring(0, 5)}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12),
                                              ),
                                              Text(
                                                'Reason: ${appointment.reason}',
                                                style: GoogleFonts.poppins(
                                                    fontSize: 12),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 4, bottom: 4),
                                                child: Container(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8,
                                                      vertical: 2),
                                                  decoration: BoxDecoration(
                                                    color: appointment.status ==
                                                            'confirmed'
                                                        ? Colors.green
                                                            .withOpacity(0.1)
                                                        : Colors.deepOrange
                                                            .withOpacity(0.1),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: Text(
                                                    'Status: ${appointment.status.capitalize}',
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 12,
                                                      color: appointment
                                                                  .status ==
                                                              'confirmed'
                                                          ? Colors.green
                                                          : Colors.deepOrange,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                                  horizontal: 16, vertical: 8),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Teacher list
                  Expanded(
                    child: controller.getFilteredTeachers().isEmpty
                        ? Center(
                            child: Text(
                              'No teachers found',
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontSize: 16,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.getFilteredTeachers().length,
                            padding:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            itemBuilder: (context, index) {
                              final teacher =
                                  controller.getFilteredTeachers()[index];
                              return TeacherCard(
                                name: teacher['name'],
                                department: teacher['department'],
                                isAvailable: teacher['available'],
                                appointmentsBooked:
                                    teacher['appointmentsBooked'],
                                totalTimeSlots: teacher['totalTimeSlots'],
                                onTap: () {
                                  if (teacher['available'] &&
                                      teacher['appointmentsBooked'] <
                                          teacher['totalTimeSlots']) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            TeacherAvailableSlotsScreen(
                                                teacher: teacher),
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
  final int appointmentsBooked;
  final int totalTimeSlots;
  final VoidCallback onTap;

  const TeacherCard({
    Key? key,
    required this.name,
    required this.department,
    required this.isAvailable,
    required this.appointmentsBooked,
    required this.totalTimeSlots,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool canBook = isAvailable && appointmentsBooked < totalTimeSlots;

    return Card(
      margin: const EdgeInsets.only(bottom: 12.0),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: Colors.grey.shade300,
          width: 1,
        ),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: canBook ? onTap : null,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Color(0xFF186CAC),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    name.substring(0, 1).toUpperCase(),
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      department,
                      style: GoogleFonts.poppins(
                        fontSize: 14,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isAvailable
                                ? Colors.green.withOpacity(0.1)
                                : Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isAvailable ? Icons.check_circle : Icons.cancel,
                                size: 14,
                                color: isAvailable ? Colors.green : Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isAvailable ? 'Available' : 'Not Available',
                                style: GoogleFonts.poppins(
                                  color:
                                      isAvailable ? Colors.green : Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Color(0xFF186CAC).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.people,
                                size: 14,
                                color: Color(0xFF186CAC),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$appointmentsBooked/$totalTimeSlots booked',
                                style: GoogleFonts.poppins(
                                  color: Color(0xFF186CAC),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
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
                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    color: Colors.deepOrange,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward,
                    size: 18,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
