class PaymentIntentInputModel {
  final num amount;
  final String currency;
  PaymentIntentInputModel({
    required this.amount,
    required this.currency,
  });

  Map<String, dynamic> toJson() => {
        'amount': amount * 100,
        'currency': currency,
      };
}
