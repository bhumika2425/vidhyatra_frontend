class PaymentTransaction {
  final String studentName;
  final double amountPaid;
  final String feeType;
  final String date;
  final String transactionId;

  PaymentTransaction({
    required this.studentName,
    required this.amountPaid,
    required this.feeType,
    required this.date,
    required this.transactionId,
  });
}