// lib/views/create_lost_found_item_view.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/LostAndFoundController.dart';
import '../models/LostAndFoundModel.dart';

class CreateLostFoundItemView extends StatelessWidget {
  final controller = Get.find<LostFoundController>();
  final _formKey = GlobalKey<FormState>();
  final itemType = TextEditingController();
  final description = TextEditingController();
  final location = TextEditingController();
  final status = 'lost'.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          'Post Lost/Found Item',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: Color(0xFF186CAC),
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Item Details',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF186CAC),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: itemType,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  labelText: 'Item Type',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                  hintText: 'e.g. Phone, Wallet, Keys',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF186CAC), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange, width: 1),
                  ),
                  prefixIcon: Icon(Icons.category, color: Color(0xFF186CAC)),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Item type is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: description,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  labelText: 'Description',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                  hintText: 'Describe the item in detail',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF186CAC), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange, width: 1),
                  ),
                  prefixIcon: Icon(Icons.description, color: Color(0xFF186CAC)),
                ),
                maxLines: 3,
                validator: (value) =>
                value?.isEmpty ?? true ? 'Description is required' : null,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: location,
                style: GoogleFonts.poppins(),
                decoration: InputDecoration(
                  labelText: 'Location',
                  labelStyle: GoogleFonts.poppins(color: Colors.grey[700]),
                  hintText: 'Where was it lost/found?',
                  hintStyle: GoogleFonts.poppins(color: Colors.grey[400]),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Color(0xFF186CAC), width: 2),
                  ),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.deepOrange, width: 1),
                  ),
                  prefixIcon: Icon(Icons.location_on, color: Color(0xFF186CAC)),
                ),
                validator: (value) =>
                value?.isEmpty ?? true ? 'Location is required' : null,
              ),
              SizedBox(height: 24),
              Text(
                'Status',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF186CAC),
                ),
              ),
              SizedBox(height: 8),
              Obx(() => Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  children: [
                    Radio(
                      value: 'lost',
                      groupValue: status.value,
                      activeColor: Colors.deepOrange,
                      onChanged: (value) => status.value = value.toString(),
                    ),
                    Text('Lost',
                        style: GoogleFonts.poppins(
                            fontWeight: status.value == 'lost'
                                ? FontWeight.w600
                                : FontWeight.normal)),
                    SizedBox(width: 24),
                    Radio(
                      value: 'found',
                      groupValue: status.value,
                      activeColor: Colors.green,
                      onChanged: (value) => status.value = value.toString(),
                    ),
                    Text('Found',
                        style: GoogleFonts.poppins(
                            fontWeight: status.value == 'found'
                                ? FontWeight.w600
                                : FontWeight.normal)),
                  ],
                ),
              )),
              SizedBox(height: 24),
              GestureDetector(
                onTap: controller.pickImages,
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Color(0xFF186CAC).withOpacity(0.5)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_photo_alternate,
                          color: Color(0xFF186CAC), size: 24),
                      SizedBox(width: 8),
                      Text(
                        '+ Add Images',
                        style: GoogleFonts.poppins(
                          color: Color(0xFF186CAC),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 16),
              Obx(() => controller.selectedImages.isNotEmpty
                  ? Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    for (var i = 0;
                    i < controller.selectedImages.length;
                    i++)
                      Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.file(
                              File(controller.selectedImages[i].path),
                              height: 100,
                              width: 100,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            right: -8,
                            top: -8,
                            child: Material(
                              color: Colors.white,
                              elevation: 2,
                              shape: CircleBorder(),
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () => controller.removeImage(i),
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  child: Icon(
                                    Icons.close,
                                    size: 16,
                                    color: Colors.deepOrange,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              )
                  : SizedBox()),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      final item = LostFoundItem(
                        itemType: itemType.text,
                        description: description.text,
                        status: status.value,
                        location: location.text,
                        imageUrls: [],
                        userId: 0, // Will be set by backend
                        createdAt: DateTime.now(),
                      );
                      controller.createLostFoundItem(item);
                    }
                  },
                  child: Text(
                    'Submit',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF186CAC),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    elevation: 3,
                  ),
                ),
              ),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}