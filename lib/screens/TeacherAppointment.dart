// import 'package:flutter/material.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import '../controllers/AppointmentController.dart';
//
// // Dialog for adding time slots
// class TimeSlotDialog extends StatelessWidget {
//   TimeSlotDialog({Key? key}) : super(key: key);
//
//   final startTimeController = TextEditingController();
//   final endTimeController = TextEditingController();
//   final controller = Get.put(AppointmentController());
//
//   @override
//   Widget build(BuildContext context) {
//     return AlertDialog(
//       title: Text('Add Time Slot', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
//       content: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           TextField(
//             controller: startTimeController,
//             decoration: InputDecoration(
//               labelText: 'Start Time (HH:MM)',
//               labelStyle: GoogleFonts.poppins(),
//             ),
//             readOnly: true,
//             onTap: () async {
//               final TimeOfDay? pickedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               if (pickedTime != null) {
//                 startTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
//               }
//             },
//           ),
//           const SizedBox(height: 16),
//           TextField(
//             controller: endTimeController,
//             decoration: InputDecoration(
//               labelText: 'End Time (HH:MM)',
//               labelStyle: GoogleFonts.poppins(),
//             ),
//             readOnly: true,
//             onTap: () async {
//               final TimeOfDay? pickedTime = await showTimePicker(
//                 context: context,
//                 initialTime: TimeOfDay.now(),
//               );
//               if (pickedTime != null) {
//                 endTimeController.text = '${pickedTime.hour}:${pickedTime.minute.toString().padLeft(2, '0')}';
//               }
//             },
//           ),
//         ],
//       ),
//       actions: [
//         TextButton(
//           onPressed: () => Get.back(),
//           child: Text('Cancel', style: GoogleFonts.poppins()),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
//               Get.snackbar('Error', 'Please select both start and end times');
//               return;
//             }
//
//             final startParts = startTimeController.text.split(':');
//             final endParts = endTimeController.text.split(':');
//
//             final selectedDate = controller.selectedDate.value;
//             final startTime = DateTime(
//               selectedDate.year,
//               selectedDate.month,
//               selectedDate.day,
//               int.parse(startParts[0]),
//               int.parse(startParts[1]),
//             );
//
//             final endTime = DateTime(
//               selectedDate.year,
//               selectedDate.month,
//               selectedDate.day,
//               int.parse(endParts[0]),
//               int.parse(endParts[1]),
//             );
//
//             if (endTime.isBefore(startTime) || endTime.isAtSameMomentAs(startTime)) {
//               Get.snackbar('Error', 'End time must be after start time');
//               return;
//             }
//
//             controller.addTimeSlot(startTime, endTime);
//             Get.back();
//           },
//           child: Text('Save', style: GoogleFonts.poppins()),
//         ),
//       ],
//     );
//   }
// }
//
// // Main widget for TeacherAppointment
// class TeacherAppointment extends StatelessWidget {
//   const TeacherAppointment({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     // Initialize the controller
//     final controller = Get.put(AppointmentController());
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Manage Appointments', style: GoogleFonts.poppins()),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.calendar_today),
//             onPressed: () async {
//               final DateTime? picked = await showDatePicker(
//                 context: context,
//                 initialDate: controller.selectedDate.value,
//                 firstDate: DateTime.now(),
//                 lastDate: DateTime.now().add(const Duration(days: 90)),
//               );
//
//               if (picked != null) {
//                 controller.selectDate(picked);
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           // Date display
//           Container(
//             padding: const EdgeInsets.all(16),
//             color: Colors.blue.shade50,
//             child: Obx(() => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Date: ${DateFormat('EEEE, MMM d, yyyy').format(controller.selectedDate.value)}',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w600,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   'Slots: ${_getSlotCount(controller)}',
//                   style: GoogleFonts.poppins(
//                     fontWeight: FontWeight.w500,
//                     color: _getSlotCount(controller) >= 10 ? Colors.red : Colors.black,
//                   ),
//                 ),
//               ],
//             )),
//           ),
//
//           // Time slots list
//           Expanded(
//             child: Obx(() {
//               final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
//               final slots = controller.dateTimeSlots[formattedDate] ?? [];
//
//               if (slots.isEmpty) {
//                 return Center(
//                   child: Text(
//                     'No time slots for this date.\nAdd slots using the + button.',
//                     textAlign: TextAlign.center,
//                     style: GoogleFonts.poppins(fontSize: 16),
//                   ),
//                 );
//               }
//
//               return ListView.builder(
//                 padding: const EdgeInsets.all(16),
//                 itemCount: slots.length,
//                 itemBuilder: (context, index) {
//                   final slot = slots[index];
//                   return Card(
//                     elevation: 2,
//                     margin: const EdgeInsets.only(bottom: 12),
//                     child: ListTile(
//                       leading: CircleAvatar(
//                         backgroundColor: slot.isBooked ? Colors.red.shade100 : Colors.green.shade100,
//                         child: Icon(
//                           slot.isBooked ? Icons.event_busy : Icons.event_available,
//                           color: slot.isBooked ? Colors.red : Colors.green,
//                         ),
//                       ),
//                       title: Text(
//                         '${DateFormat('h:mm a').format(slot.startTime)} - ${DateFormat('h:mm a').format(slot.endTime)}',
//                         style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
//                       ),
//                       subtitle: slot.isBooked
//                           ? Text('Booked by: ${slot.studentName}', style: GoogleFonts.poppins())
//                           : Text('Available', style: GoogleFonts.poppins()),
//                       trailing: IconButton(
//                         icon: const Icon(Icons.delete_outline),
//                         onPressed: () {
//                           if (slot.isBooked) {
//                             Get.dialog(
//                               AlertDialog(
//                                 title: Text('Slot Booked', style: GoogleFonts.poppins()),
//                                 content: Text(
//                                   'This slot is already booked by a student. Deleting it will cancel their appointment.',
//                                   style: GoogleFonts.poppins(),
//                                 ),
//                                 actions: [
//                                   TextButton(
//                                     onPressed: () => Get.back(),
//                                     child: Text('Cancel', style: GoogleFonts.poppins()),
//                                   ),
//                                   ElevatedButton(
//                                     onPressed: () {
//                                       controller.deleteTimeSlot(formattedDate, slot.id);
//                                       Get.back();
//                                     },
//                                     style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//                                     child: Text('Delete Anyway', style: GoogleFonts.poppins()),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           } else {
//                             controller.deleteTimeSlot(formattedDate, slot.id);
//                           }
//                         },
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//         ],
//       ),
//       floatingActionButton: Obx(() {
//         final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
//         final slots = controller.dateTimeSlots[formattedDate] ?? [];
//
//         // Only show FAB if we have less than 10 slots
//         if (slots.length >= 10) {
//           return const SizedBox.shrink();
//         }
//
//         return FloatingActionButton(
//           onPressed: () {
//             Get.dialog(TimeSlotDialog());
//           },
//           child: const Icon(Icons.add),
//         );
//       }),
//     );
//   }
//
//   int _getSlotCount(AppointmentController controller) {
//     final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
//     return controller.dateTimeSlots[formattedDate]?.length ?? 0;
//   }
// }

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../controllers/AppointmentController.dart';

// Dialog for adding time slots
class TimeSlotDialog extends StatelessWidget {
  TimeSlotDialog({Key? key}) : super(key: key);

  final startTimeController = TextEditingController();
  final endTimeController = TextEditingController();
  final controller = Get.find<AppointmentController>();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Time Slot', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: startTimeController,
            decoration: InputDecoration(
              labelText: 'Start Time (HH:MM)',
              labelStyle: GoogleFonts.poppins(),
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
              labelStyle: GoogleFonts.poppins(),
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
          child: Text('Cancel', style: GoogleFonts.poppins()),
        ),
        ElevatedButton(
          onPressed: () {
            if (startTimeController.text.isEmpty || endTimeController.text.isEmpty) {
              Get.snackbar('Error', 'Please select both start and end times');
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
          child: Text('Save', style: GoogleFonts.poppins()),
        ),
      ],
    );
  }
}

// Main widget for TeacherAppointment
class TeacherAppointment extends StatelessWidget {
  const TeacherAppointment({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AppointmentController());

    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Appointments', style: GoogleFonts.poppins()),
        actions: [
          IconButton(
            icon: const Icon(Icons.calendar_today),
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
            color: Colors.blue.shade50,
            child: Obx(() => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Date: ${DateFormat('EEEE, MMM d, yyyy').format(controller.selectedDate.value)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'Slots: ${_getSlotCount(controller)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: _getSlotCount(controller) >= 10 ? Colors.red : Colors.black,
                  ),
                ),
              ],
            )),
          ),

          // Time slots list
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
              final slots = controller.dateTimeSlots[formattedDate] ?? [];

              if (slots.isEmpty) {
                return Center(
                  child: Text(
                    'No time slots for this date.\nAdd slots using the + button.',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.poppins(fontSize: 16),
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
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: slot.isBooked ? Colors.red.shade100 : Colors.green.shade100,
                        child: Icon(
                          slot.isBooked ? Icons.event_busy : Icons.event_available,
                          color: slot.isBooked ? Colors.red : Colors.green,
                        ),
                      ),
                      title: Text(
                        '${DateFormat('h:mm a').format(slot.startTime)} - ${DateFormat('h:mm a').format(slot.endTime)}',
                        style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
                      ),
                      subtitle: slot.isBooked
                          ? Text('Booked by: ${slot.studentName ?? 'Unknown'}', style: GoogleFonts.poppins())
                          : Text('Available', style: GoogleFonts.poppins()),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () {
                          if (slot.isBooked) {
                            Get.dialog(
                              AlertDialog(
                                title: Text('Slot Booked', style: GoogleFonts.poppins()),
                                content: Text(
                                  'This slot is already booked by a student. Deleting it will cancel their appointment.',
                                  style: GoogleFonts.poppins(),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Get.back(),
                                    child: Text('Cancel', style: GoogleFonts.poppins()),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      controller.deleteTimeSlot(formattedDate, slot.id);
                                      Get.back();
                                    },
                                    style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                                    child: Text('Delete Anyway', style: GoogleFonts.poppins()),
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
          child: const Icon(Icons.add),
        );
      }),
    );
  }

  int _getSlotCount(AppointmentController controller) {
    final formattedDate = DateFormat('yyyy-MM-dd').format(controller.selectedDate.value);
    return controller.dateTimeSlots[formattedDate]?.length ?? 0;
  }
}