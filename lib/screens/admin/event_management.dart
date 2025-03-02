// import 'dart:io';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controllers/EventController.dart';
// import 'admin_navbar.dart';
// import 'admin_top_narbar.dart';
//
// class EventManagementPage extends StatefulWidget {
//   @override
//   _EventManagementPageState createState() => _EventManagementPageState();
// }
//
// class _EventManagementPageState extends State<EventManagementPage> {
//   final EventController controller = Get.put(EventController());
//   int selectedIndex = 0;
//
//   void _onNavItemSelected(int index) {
//     setState(() {
//       selectedIndex = index;
//     });
//   }
//
//   void _onNotificationTap() {
//     // Handle notification tap
//   }
//
//   void _onProfileTap() {
//     // Handle profile tap
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: PreferredSize(
//         preferredSize: Size.fromHeight(60), // Height of the top navbar
//         child: AdminTopNavBar(
//           onNotificationTap: _onNotificationTap,
//           onProfileTap: _onProfileTap,
//         ),
//       ),
//       body: Row(
//         children: [
//           AdminNavBar(onTap: _onNavItemSelected),
//           Expanded(
//             child: Padding(
//               padding: const EdgeInsets.all(20.0),
//               child: SingleChildScrollView(
//                 child: _buildEventManagementContent(),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildEventManagementContent() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         Text("Event Management",
//             style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
//         SizedBox(height: 20),
//         _buildEventForm(),
//       ],
//     );
//   }
//
//   Widget _buildEventForm() {
//     // Get the screen width directly from MediaQuery
//     double screenWidth = MediaQuery.of(Get.context!).size.width;
//     return Obx(() => Container(
//           width: screenWidth * 0.4, // Set desired width here
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildTextField(
//                   "Event Name", "Enter event name", controller.setEventName),
//               SizedBox(height: 15),
//               _buildTextField("Description", "Enter event description",
//                   controller.setEventDescription),
//               SizedBox(height: 15),
//               _buildTextField(
//                   "Venue", "Enter event venue", controller.setEventVenue),
//               SizedBox(height: 15),
//               _buildDateField(),
//               SizedBox(height: 20),
//               _buildImagePicker(),
//               SizedBox(height: 20),
//               _buildSubmitButton(),
//             ],
//           ),
//         ));
//   }
//
//   Widget _buildTextField(
//       String label, String hint, Function(String) onChanged) {
//     return TextField(
//       onChanged: onChanged,
//       decoration: InputDecoration(
//         labelText: label,
//         hintText: hint,
//         border: OutlineInputBorder(),
//       ),
//     );
//   }
//
//   Widget _buildDateField() {
//     return TextField(
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//           context: Get.context!,
//           initialDate: DateTime.now(),
//           firstDate: DateTime(2000),
//           lastDate: DateTime(2101),
//         );
//         if (pickedDate != null) {
//           controller.setEventDate("${pickedDate.toLocal()}".split(' ')[0]);
//         }
//       },
//       readOnly: true,
//       decoration: InputDecoration(
//         labelText: "Event Date",
//         hintText: "Pick a date",
//         border: OutlineInputBorder(),
//         suffixIcon: Icon(Icons.calendar_today),
//       ),
//     );
//   }
//
//   Widget _buildImagePicker() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Event Image",
//             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
//         SizedBox(height: 10),
//         GestureDetector(
//           onTap: controller.pickImage,
//           child: Container(
//             height: 200,
//             decoration: BoxDecoration(
//               border: Border.all(color: Colors.grey),
//               borderRadius: BorderRadius.circular(10),
//             ),
//             child: controller.selectedImage.value == null
//                 ? Center(child: Text("Tap to pick an image"))
//                 : Image.file(
//                     File(controller.selectedImage.value!.path),
//                     fit: BoxFit.cover,
//                   ),
//           ),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildSubmitButton() {
//     return ElevatedButton(
//       onPressed: () {
//         if (controller.eventName.isNotEmpty &&
//             controller.eventDescription.isNotEmpty &&
//             controller.eventVenue.isNotEmpty &&
//             controller.eventDate.isNotEmpty &&
//             controller.selectedImage.value != null) {
//           // Save event logic here
//           _showSuccessDialog(Get.context!);
//         } else {
//           _showErrorDialog(Get.context!);
//         }
//       },
//       style: ButtonStyle(
//         backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade900),
//         padding: MaterialStateProperty.all(
//             EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
//         shape: MaterialStateProperty.all(
//             RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
//       ),
//       child: Text("Post Event", style: TextStyle(color: Colors.white)),
//     );
//   }
//
//   void _showSuccessDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Event Posted"),
//           content: Text("Your event has been successfully posted!"),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   void _showErrorDialog(BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text("Error"),
//           content: Text("Please fill in all fields and select an image."),
//           actions: <Widget>[
//             TextButton(
//               onPressed: () {
//                 Get.back();
//               },
//               child: Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/EventController.dart';
import 'admin_navbar.dart';
import 'admin_top_narbar.dart';

class EventManagementPage extends StatefulWidget {
  @override
  _EventManagementPageState createState() => _EventManagementPageState();
}

class _EventManagementPageState extends State<EventManagementPage> {
  final EventController controller = Get.put(EventController());
  int selectedIndex = 0;

  void _onNavItemSelected(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  void _onNotificationTap() {
    // Handle notification tap
  }

  void _onProfileTap() {
    // Handle profile tap
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60), // Height of the top navbar
        child: AdminTopNavBar(
          onNotificationTap: _onNotificationTap,
          onProfileTap: _onProfileTap,
        ),
      ),
      body: Row(
        children: [
          AdminNavBar(onTap: _onNavItemSelected),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: _buildEventManagementContent(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventManagementContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text("Event Management",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        SizedBox(height: 20),
        _buildEventForm(),
      ],
    );
  }

  Widget _buildEventForm() {
    double screenWidth = MediaQuery.of(Get.context!).size.width;
    return Obx(() => Container(
      width: screenWidth * 0.4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTextField("Event Name", "Enter event name", controller.setEventTitle),
          SizedBox(height: 15),
          _buildTextField("Description", "Enter event description", controller.setEventDescription),
          SizedBox(height: 15),
          _buildTextField("Venue", "Enter event venue", controller.setEventVenue),
          SizedBox(height: 15),
          _buildDateField(),
          SizedBox(height: 20),
          _buildImagePicker(),
          SizedBox(height: 20),
          _buildSubmitButton(),
        ],
      ),
    ));
  }

  Widget _buildTextField(String label, String hint, Function(String) onChanged) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildDateField() {
    return GestureDetector(
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: Get.context!,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.setEventDate("${pickedDate.toLocal()}".split(' ')[0]);
        }
      },
      child: AbsorbPointer(
        child: TextField(
          controller: TextEditingController(text: controller.eventDate.value),
          readOnly: true,
          decoration: InputDecoration(
            labelText: "Event Date",
            hintText: "Pick a date",
            border: OutlineInputBorder(),
            suffixIcon: Icon(Icons.calendar_today),
          ),
        ),
      ),
    );
  }


  Widget _buildImagePicker() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Event Image", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 10),
        GestureDetector(
          onTap: controller.pickImage,
          child: Container(
            height: 200,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(10),
            ),
            child: controller.selectedImage.value == null
                ? Center(child: Text("Tap to pick an image"))
                : Image.file(
              File(controller.selectedImage.value!.path),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return ElevatedButton(
      onPressed: () async {
        await controller.createEvent();
      },
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(Colors.blueGrey.shade900),
        padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
      ),
      child: Text("Post Event", style: TextStyle(color: Colors.white)),
    );
  }
}
