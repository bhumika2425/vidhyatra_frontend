class Fee {
  final int feeID;
  final String feeType;
  final String feeDescription;
  final double feeAmount;
  final String dueDate;
  final int userID;
  // final User user;

  Fee({
    required this.feeID,
    required this.feeType,
    required this.feeDescription,
    required this.feeAmount,
    required this.dueDate,
    required this.userID,
    // required this.user,
  });

  // Factory method to create a Fee object from JSON
  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      feeID: json['feeID'] ?? 0, // Default to 0 if null
      feeType: json['feeType'] ?? 'Unknown', // Provide default values
      feeDescription: json['feeDescription'] ?? 'No description available',
      feeAmount: (json['feeAmount'] ?? 0).toDouble(), // Handle null safely
      dueDate: json['dueDate'] ?? '',
      userID: json['user_id'] ?? 0,
      // user: json['User'] != null
      //     ? User.fromJson(json['User'])
      //     : User(userId: 0, collegeId: "Unknown", name: "Unknown", email: "Unknown"),

    );
  }

  // Method to convert Fee object to JSON
  Map<String, dynamic> toJson() {
    return {
      'feeID': feeID,
      'feeType': feeType,
      'feeDescription': feeDescription,
      'feeAmount': feeAmount,
      'dueDate': dueDate,
      'user_id': userID,
      // 'User': user.toJson(),
    };
  }
}
