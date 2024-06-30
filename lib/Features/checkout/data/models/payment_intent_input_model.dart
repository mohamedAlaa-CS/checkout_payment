class PaymentIntentInputModel {
  final num amount;
  final String currency;
  final String customerId;
  PaymentIntentInputModel({
    required this.customerId,
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount * 100,
        'currency': currency,
        'customer': customerId,
      };
}
