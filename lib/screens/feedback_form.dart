import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/feedback_controller.dart';
import '../models/feedback_model.dart';

class FeedbackForm extends StatelessWidget {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Send Feedback!"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                 
                    SizedBox(height: 10),
                    Text(
                      "We value your feedback!",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF971F20),
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Please share your thoughts below:",
                      style: TextStyle(color: Colors.black87),
                    ),
                    SizedBox(height: 20),

                    // Feedback Type Dropdown
                    DropdownButtonFormField<String>(
                      value: feedbackController.selectedType,
                      items: ['courses', 'app_features', 'facilities']
                          .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                          .toList(),
                      onChanged: (value) => feedbackController.selectedType = value,
                      decoration: InputDecoration(
                        labelText: 'Feedback Type',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.feedback, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      validator: (value) {
                        if (value == null) return 'Please select a feedback type';
                        return null;
                      },
                    ),
                    SizedBox(height: 16),

                    // Feedback Content Text Field
                    TextFormField(
                      controller: feedbackController.feedbackContentController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        labelText: 'Feedback Content',
                        labelStyle: TextStyle(color: Colors.black),
                        prefixIcon: Icon(Icons.text_fields, color: Colors.black),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                      ),
                      style: TextStyle(color: Colors.black),
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
                            feedbackController.isAnonymous.value = value!;
                          },
                        ),
                        Text('Submit Anonymously', style: TextStyle(fontSize: 14)),
                      ],
                    )),
                    SizedBox(height: 20),

                    // Submit Button
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final feedback = FeedbackModel(
                            feedbackType: feedbackController.selectedType!,
                            feedbackContent: feedbackController.feedbackContentController.text,
                            isAnonymous: feedbackController.isAnonymous.value,
                          );
                          feedbackController.submitFeedback(feedback);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF971F20),
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Obx(() => feedbackController.isLoading.value
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Submit Feedback', style: TextStyle(fontSize: 18))),
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