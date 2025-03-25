import 'dart:convert';
import 'package:get/get.dart';
import 'package:vidhyatra_flutter/models/FeesModel.dart';
import '../../../../constants/api_endpoints.dart';
import '../../../../controllers/LoginController.dart';
import 'package:http/http.dart' as http;

class FeeController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var successMessage = ''.obs;
  var fees = <Fee>[].obs;

  final LoginController loginController = Get.find<LoginController>(); // Using Get.find to get the login controller

  @override
  void onInit() {
    super.onInit();
    fetchFees(); // Optionally fetch the fees on initialization
  }

  // Method to fetch the list of fees
  Future<void> fetchFees() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(ApiEndPoints.getAllFees); // Update to your endpoint for fetching fees
      final token = loginController.token.value;

      if (token.isEmpty) {
        errorMessage.value = 'Authentication token is missing';
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        if (jsonResponse is Map<String, dynamic> && jsonResponse.containsKey('data')) {
          final feesData = jsonResponse['data'];

          if (feesData is List) {
            fees.value = feesData.map((fee) => Fee.fromJson(fee as Map<String, dynamic>)).toList();
            successMessage.value = 'Fees fetched successfully';
          } else {
            errorMessage.value = 'Data is not a list';
          }
        } else {
          errorMessage.value = 'Invalid response format';
        }
      } else {
        errorMessage.value = 'Failed to load fees';
      }
    } catch (e) {
      errorMessage.value = 'Error fetching fees: $e';
    } finally {
      isLoading.value = false;
    }
  }

  // Method to add a fee
  Future<void> addFee(Fee fee) async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final uri = Uri.parse(ApiEndPoints.postFees); // Update with your actual endpoint for adding fees
      final token = loginController.token.value;

      if (token.isEmpty) {
        errorMessage.value = 'Authentication token is missing';
        return;
      }

      final headers = {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      };

      final body = json.encode({
        'fee_type': fee.feeType,
        'fee_description': fee.feeDescription,
        'fee_amount': fee.feeAmount,
        'due_date': fee.dueDate, // Ensure due_date is in the correct format
      });

      final response = await http.post(uri, headers: headers, body: body);

      if (response.statusCode == 201 || response.statusCode == 200) {
        successMessage.value = 'Fee added successfully';
        fetchFees(); // Optionally, refresh the list of fees
      } else {
        errorMessage.value = 'Failed to add fee: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      errorMessage.value = 'Error adding fee: $e';
    } finally {
      isLoading.value = false;
    }
  }
}
