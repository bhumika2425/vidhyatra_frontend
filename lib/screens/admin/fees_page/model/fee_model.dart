class Fee {
  final String feeID; // Fee ID
  final String feeType;
  final String feeDescription;
  final double feeAmount;
  final String dueDate;

  Fee({
    required this.feeID,
    required this.feeType,
    required this.feeDescription,
    required this.feeAmount,
    required this.dueDate,
  });

  factory Fee.fromJson(Map<String, dynamic> json) {
    return Fee(
      feeID: json['fee_id'], // Assume you have a field called fee_id in the API response
      feeType: json['fee_type'],
      feeDescription: json['fee_description'],
      feeAmount: json['fee_amount'],
      dueDate: json['due_date'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fee_id': feeID,
      'fee_type': feeType,
      'fee_description': feeDescription,
      'fee_amount': feeAmount,
      'due_date': dueDate,
    };
  }
}
