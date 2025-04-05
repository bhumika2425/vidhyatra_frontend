class ChangePassword {
  final String? currentPassword; // For request
  final String? newPassword;     // For request
  final String? confirmPassword; // For request
  final String? message;         // For response (success or error)
  final bool? success;           // Optional: to indicate success/failure

  ChangePassword({
    this.currentPassword,
    this.newPassword,
    this.confirmPassword,
    this.message,
    this.success,
  });

  // Factory method to create a ChangePassword object from JSON (response from backend)
  factory ChangePassword.fromJson(Map<String, dynamic> json) {
    return ChangePassword(
      message: json['message'] ?? '', // Default to empty string if null
      success: json['message'] == "Password changed successfully" ? true : false, // Infer success
    );
  }

  // Method to convert ChangePassword object to JSON (request to backend)
  Map<String, dynamic> toJson() {
    return {
      'currentPassword': currentPassword ?? '',
      'newPassword': newPassword ?? '',
      'confirmPassword': confirmPassword ?? '',
    };
  }
}