// class PaymentHistoryModel {
//   final String paidFeesId;
//   final String feeType;
//   final String feeDescription;
//   final double totalPrice;
//   final String paidDate;
//   final String paymentMethod;
//   final String status;
//   final int userId;
//   final String createdAt;
//   final String updatedAt;
//   final int feeId;
//   final double feeAmount;
//   final String dueDate;
//   final PaymentDetails? payment;
//
//   PaymentHistoryModel({
//     required this.paidFeesId,
//     required this.feeType,
//     required this.feeDescription,
//     required this.totalPrice,
//     required this.paidDate,
//     required this.paymentMethod,
//     required this.status,
//     required this.userId,
//     required this.createdAt,
//     required this.updatedAt,
//     required this.feeId,
//     required this.feeAmount,
//     required this.dueDate,
//     this.payment,
//   });
//
//   factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
//     return PaymentHistoryModel(
//       paidFeesId: json['paidFeesId'] ?? '',
//       feeType: json['Fee']?['feeType'] ?? 'Unknown',
//       feeDescription: json['Fee']?['feeDescription'] ?? 'No description',
//       totalPrice: double.tryParse(json['totalPrice'].toString()) ?? 0.0,
//       paidDate: json['paidDate'] ?? '',
//       paymentMethod: json['paymentMethod'] ?? 'Unknown',
//       status: json['status'] ?? 'pending',
//       userId: json['user_id'] ?? 0,
//       createdAt: json['createdAt'] ?? '',
//       updatedAt: json['updatedAt'] ?? '',
//       feeId: json['feeID'] ?? 0,
//       feeAmount: double.tryParse(json['Fee']?['feeAmount'].toString() ?? '0') ?? 0.0,
//       dueDate: json['Fee']?['dueDate'] ?? '',
//       payment: json['Payment'] != null
//           ? PaymentDetails.fromJson(json['Payment'])
//           : null,
//     );
//   }
// }
//
// class PaymentDetails {
//   final String transactionId;
//   final double amount;
//   final String status;
//   final String paymentDate;
//
//   PaymentDetails({
//     required this.transactionId,
//     required this.amount,
//     required this.status,
//     required this.paymentDate,
//   });
//
//   factory PaymentDetails.fromJson(Map<String, dynamic> json) {
//     return PaymentDetails(
//       transactionId: json['transactionId'] ?? '',
//       amount: double.tryParse(json['amount'].toString()) ?? 0.0,
//       status: json['status'] ?? '',
//       paymentDate: json['paymentDate'] ?? '',
//     );
//   }
// }

class PaymentHistoryModel {
  final String paidFeesId;
  final String feeType;
  final String feeDescription;
  final double totalPrice;
  final String paidDate;
  final String paymentMethod;
  final String status;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final int feeId;
  final double feeAmount;
  final String dueDate;
  final PaymentDetails? payment;

  PaymentHistoryModel({
    required this.paidFeesId,
    required this.feeType,
    required this.feeDescription,
    required this.totalPrice,
    required this.paidDate,
    required this.paymentMethod,
    required this.status,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.feeId,
    required this.feeAmount,
    required this.dueDate,
    this.payment,
  });

  factory PaymentHistoryModel.fromJson(Map<String, dynamic> json) {
    return PaymentHistoryModel(
      paidFeesId: json['paidFeesId'] ?? '',
      feeType: json['Fee']?['feeType'] ?? 'Unknown',
      feeDescription: json['Fee']?['feeDescription'] ?? 'No description',
      totalPrice: double.tryParse(json['totalPrice'].toString()) ?? 0.0,
      paidDate: json['paidDate'] ?? '',
      paymentMethod: json['paymentMethod'] ?? 'Unknown',
      status: json['status'] ?? 'pending',
      userId: json['user_id'] ?? 0,
      createdAt: json['createdAt'] ?? '',
      updatedAt: json['updatedAt'] ?? '',
      feeId: json['feeID'] ?? 0,
      feeAmount: double.tryParse(json['Fee']?['feeAmount'].toString() ?? '0') ?? 0.0,
      dueDate: json['Fee']?['dueDate'] ?? '',
      payment: json['Payment'] != null
          ? PaymentDetails.fromJson(json['Payment'])
          : null,
    );
  }
}

class PaymentDetails {
  final String transactionId;
  final double amount;
  final String status;
  final String paymentDate;

  PaymentDetails({
    required this.transactionId,
    required this.amount,
    required this.status,
    required this.paymentDate,
  });

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      transactionId: json['transactionId'] ?? '',
      amount: double.tryParse(json['amount'].toString()) ?? 0.0,
      status: json['status'] ?? '',
      paymentDate: json['paymentDate'] ?? '',
    );
  }
}