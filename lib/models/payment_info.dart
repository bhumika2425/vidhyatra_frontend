// models/payment_info.dart
class PaymentInfo {
  final String title;
  final String dueDate;
  final String amount;
  final String description;

  PaymentInfo({
    required this.title,
    required this.dueDate,
    required this.amount,
    required this.description,
  });
}