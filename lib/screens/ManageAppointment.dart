import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/AppointmentController.dart';

// Main widget for TeacherAppointment
class ManageAppointment extends StatelessWidget {
  const ManageAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'Manage Appointments',
          style: GoogleFonts.poppins(color: Colors.white),
        ),
        backgroundColor: const Color(0xFF186CAC),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Colors.white),
            onPressed: () async {
              final DateTime? picked = await showDatePicker(
                context: context,
                initialDate: controller.selectedDate.value,
                firstDate: DateTime.now(),
                lastDate: DateTime.now().add(const Duration(days: 90)),
              );

              if (picked != null) {
                controller.selectDate(picked);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Date display
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('EEEE, MMM d, yyyy').format(controller.selectedDate.value)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                Text(
                  'Slots: ${_getSlotCount(controller)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: _getSlotCount(controller) >= 10 ? Colors.deepOrange : Colors.black,
                  ),
                ),
              ],
            )),
          ),

          // Time slots list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator(color: Color(0xFF186CAC)));
              }

              final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
              final slots = controller.dateTimeSlots[formattedDate] ?? [];

              if (slots.isEmpty) {
                return Center(
                  child: Text(
                    'No time slots for this date.\nAdd slots using the + button.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16, color: Colors.black),
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: slots.length,
                itemBuilder: (context, index) {
                  final slot = slots[index];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.only(bottom: 12),
                    color: Colors.white,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: slot.isBooked ? Colors.deepOrange.withOpacity(0.1) : Colors.black.withOpacity(0.1),
                        child: Icon(
                          slot.isBooked ? Icons.event_busy : Icons.event_available,
                          color: slot.isBooked ? Colors.deepOrange : Colors.black,
                        ),
                      ),
                      title: Text(
                        '${DateFormat('h:mm a').format(slot.startTime)} - ${DateFormat('h:mm a').format(slot.endTime)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.black),
                      ),
                      subtitle: slot.isBooked
                          ? Text(
                        'Booked by: ${slot.student?.name ?? 'Unknown'}',
                        style: GoogleFonts.poppins(color: Colors.black),
                      )
                          : Text(
                        'Available',
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.deepOrange),
                        onPressed: () {
                          if (slot.isBooked) {
                            Get.dialog(
                              AlertDialog(
                                title: Text('Slot Booked', style: GoogleFonts.poppins(color: Colors.black)),
                                content: Text(
                                  'This slot is already booked by a student. Deleting it will cancel their appointment.',
                                  style: GoogleFonts.poppins(color: Colors.black),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.black)),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.deleteTimeSlot(formattedDate, slot.id);
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.deepOrange),
                                    child: Text('Delete Anyway', style: GoogleFonts.poppins(color: Colors.white)),
                                  ),
                                ],
                              ),
                            );
                          } else {
                            controller.deleteTimeSlot(formattedDate, slot.id);
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
        final slots = controller.dateTimeSlots[formattedDate] ?? [];

        if (slots.length >= 10) {
          return const SizedBox.shrink();
        }

        return FloatingActionButton(
          onPressed: () {
            Get.dialog(TimeSlotDialog());
          },
          backgroundColor: const Color(0xFF186CAC),
          child: const Icon(Icons.add, color: Colors.white),
        );
      }),
    );
  }

  int _getSlotCount(AppointmentController controller) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
    return controller.dateTimeSlots[formattedDate]?.length ?? 0;
  }
}

// Dialog for adding time slots
class TimeSlotDialog extends StatelessWidget {
  TimeSlotDialog({Key? key}) : super(key: key);

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final controller = Get.find<AppointmentController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        'Add Time Slot',
        style: GoogleFonts.poppins(fontWeight: FontWeight.bold, color: Colors.black),
      ),
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: startTimeController,
            decoration: InputDecoration(
              labelText: 'Start Time (HH:MM)',
              labelStyle: GoogleFonts.poppins(color: Colors.black),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF186CAC)),
              ),
            ),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                startTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
              }
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: endTimeController,
            decoration: InputDecoration(
              labelText: 'End Time (HH:MM)',
              labelStyle: GoogleFonts.poppins(color: Colors.black),
              enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Color(0xFF186CAC)),
              ),
            ),
            readOnly: true,
            onTap: () async {
              final TimeOfDay? pickedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              if (pickedTime != null) {
                endTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.black)),
        ),
        ElevatedButton(
          onPressed: () {
            if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
              Get.snackbar('Error', 'Please select both start and end times',);
              return;
            }

            final startParts = startTimeController.text.split(':');
            final endParts = endTimeController.text.split(':');

            final selectedDate = controller.selectedDate.value;
            final startTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              int.parse(startParts[0]),
              int.parse(startParts[1]),
            );

            final endTime = DateTime(
              selectedDate.year,
              selectedDate.month,
              selectedDate.day,
              int.parse(endParts[0]),
              int.parse(endParts[1]),
            );

            if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
              Get.snackbar('Error', 'End time must be after start time');
              return;
            }

            controller.addTimeSlot(startTime, endTime);
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF186CAC)),
          child: Text('Save', style: GoogleFonts.poppins(color: Colors.white)),
        ),
      ],
    );
  }
}