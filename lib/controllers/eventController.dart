import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class EventController extends GetxController {
  var eventTitle = ''.obs;
  var eventDescription = ''.obs;
  var eventVenue = ''.obs;
  var eventDate = ''.obs;
  var selectedImage = Rx<XFile?>(null);
  var isLoading = false.obs;

  // Function to set the event details
  void setEventTitle(String title) {
    eventTitle.value = title;
  }

  void setEventDescription(String description) {
    eventDescription.value = description;
  }

  void setEventVenue(String venue) {
    eventVenue.value = venue;
  }

  void setEventDate(String date) {
    eventDate.value = date;
  }

  void setSelectedImage(XFile? image) {
    selectedImage.value = image;
  }

  // Function to pick an image from the gallery
  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setSelectedImage(pickedImage);
  }

  // Function to create an event
  Future<void> createEvent() async {
    if (eventTitle.isEmpty || eventDescription.isEmpty || eventVenue.isEmpty || eventDate.isEmpty == null) {
      Get.snackbar('Error', 'Please fill in all fields and select an image.');
      return;
    }

    isLoading.value = true;

    try {
      final Uri url = Uri.parse('http://192.168.1.8:3001/api/eventCalender/events');
      var request = http.MultipartRequest('POST', url)
        ..fields['title'] = eventTitle.value
        ..fields['description'] = eventDescription.value
        ..fields['venue'] = eventVenue.value
        ..fields['event_date'] = eventDate.value
        ..fields['created_by'] = '1'; // Assuming 1 is the admin ID, this can be dynamic

      // Add the Authorization header
        request.headers['Authorization'] = "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoyMSwicm9sZSI6IkFkbWluIiwiaWF0IjoxNzQwOTE0NzAwLCJleHAiOjE3NDA5MTgzMDB9.952UehQi6tEJ2jrkWpY69K6oUkRKU0Tiqv0VjvlZ2Xc";

      // if (selectedImage.value != null) {
      //   var image = await http.MultipartFile.fromPath('image', selectedImage.value!.path);
      //   request.files.add(image);
      // }

      var response = await request.send();

      if (response.statusCode == 201) {
        Get.snackbar('Success', 'Event posted successfully!');
      } else {
        Get.snackbar('Error', 'Failed to post event.');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong. Please try again.');
      print('Error: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
