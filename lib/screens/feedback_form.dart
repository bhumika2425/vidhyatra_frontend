import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/feedback_controller.dart';

class FeedbackForm extends StatelessWidget {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Color(0xFF186CAC),
        elevation: 0,
        title: Text(
          "Feedback",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 20,
          ),
        ),

      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "We value your feedback!",
                      style: GoogleFonts.poppins(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF186CAC),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please share your thoughts below:",
                      style: GoogleFonts.poppins(color: Colors.deepOrange),
                    ),
                    SizedBox(height: 40),

                    // Feedback Type Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Feedback Type",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Feedback Type Dropdown (no icons)
                    DropdownButtonFormField<String>(
                      value: feedbackController.selectedType,
                      hint: Text(
                        'Select feedback type',
                        style: GoogleFonts.poppins(
                            color: Colors.grey[400], fontSize: 15),
                      ),
                      items: [
                        'Courses',
                        'App Features',
                        'Facilities',
                        'Faculty Behavior',
                        'Technical Support',
                        'Bug Report',
                        'Suggestions',
                        'Others',
                      ]
                          .map((type) => DropdownMenuItem(
                        value: type.toLowerCase().replaceAll(' ', '_'),
                        child: Text(
                          type,
                          style: GoogleFonts.poppins(fontSize: 15),
                        ),
                      ))
                          .toList(),
                      onChanged: (value) =>
                      feedbackController.selectedType = value,
                      decoration: InputDecoration(
                        prefixIcon:
                        Icon(Icons.feedback, color: Colors.grey[400]),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 15, horizontal: 16),
                      ),
                      style: GoogleFonts.poppins(color: Colors.black),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Please select a feedback type';
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Feedback Content Label
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Feedback Content",
                        style: GoogleFonts.poppins(
                          fontSize: 15,
                          color: Colors.grey[800],
                        ),
                      ),
                    ),
                    SizedBox(height: 8),

                    // Feedback Content Text Field
                    TextFormField(
                      controller: feedbackController.feedbackContentController,
                      maxLines: 4,
                      style: GoogleFonts.poppins(color: Colors.grey[600]),
                      decoration: InputDecoration(
                        hintText: 'Write feedback',
                        hintStyle: GoogleFonts.poppins(
                            color: Colors.grey[400], fontSize: 15),
                        prefixIcon: Padding(
                          padding: EdgeInsets.only(bottom: 70),
                          child: Icon(Icons.text_fields,
                              color: Colors.grey[400]),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                          BorderSide(color: Color(0xFF186CAC), width: 1.5),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty)
                          return 'Feedback content is required';
                        return null;
                      },
                    ),

                    SizedBox(height: 16),

                    // Anonymous Checkbox
                    Obx(() => Row(
                      children: [
                        Checkbox(
                          value: feedbackController.isAnonymous.value,
                          onChanged: (value) {
                            feedbackController.toggleAnonymous(value!);
                          },
                          activeColor: Colors.deepOrange,
                        ),
                        Text(
                          'Submit Anonymously',
                          style: GoogleFonts.poppins(
                              fontSize: 14, color: Colors.black),
                        ),
                      ],
                    )),
                    SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () =>
                          feedbackController.handleSubmit(_formKey),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF186CAC),
                        foregroundColor: Colors.white,
                        padding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Obx(() => feedbackController.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        'Submit',
                        style: GoogleFonts.poppins(fontSize: 18),
                      )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
