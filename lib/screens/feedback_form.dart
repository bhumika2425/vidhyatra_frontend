// lib/views/feedback_form.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/feedback_controller.dart';
import '../models/feedback_model.dart';

class FeedbackForm extends StatelessWidget {
  final FeedbackController feedbackController = Get.put(FeedbackController());
  final _formKey = GlobalKey<FormState>();

  final userIdController = TextEditingController();
  final feedbackContentController = TextEditingController();
  String? selectedType;
  bool isAnonymous = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Submit Feedback')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: userIdController,
                decoration: InputDecoration(labelText: 'User ID'),
                // validator: (value) {
                //   if (value == null || value.isEmpty) return 'User ID is required';
                //   return null;
                // },
              ),
              DropdownButtonFormField<String>(
                value: selectedType,
                items: ['courses', 'app_features', 'facilities']
                    .map((type) => DropdownMenuItem(value: type, child: Text(type)))
                    .toList(),
                onChanged: (value) => selectedType = value,
                decoration: InputDecoration(labelText: 'Feedback Type'),
                validator: (value) {
                  if (value == null) return 'Please select a feedback type';
                  return null;
                },
              ),
              TextFormField(
                controller: feedbackContentController,
                maxLines: 4,
                decoration: InputDecoration(labelText: 'Feedback Content'),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Feedback content is required';
                  return null;
                },
              ),
              Row(
                children: [
                  Checkbox(
                    value: isAnonymous,
                    onChanged: (value) => isAnonymous = value!,
                  ),
                  Text('Submit Anonymously'),
                ],
              ),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final feedback = FeedbackModel(
                      userId: userIdController.text,
                      feedbackType: selectedType!,
                      feedbackContent: feedbackContentController.text,
                      isAnonymous: isAnonymous,
                    );
                    feedbackController.submitFeedback(feedback);
                  }
                },
                child: Obx(() => feedbackController.isLoading.value
                    ? CircularProgressIndicator()
                    : Text('Submit Feedback')),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
