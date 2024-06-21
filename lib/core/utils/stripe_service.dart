import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_key.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';

class StripeService {
  Future<PaymentIntentModel> createPaymentIntetnt(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    var response = await ApiService.post(
      url: 'https://api.stripe.com/v1/payment_intents',
      data: paymentIntentInputModel.toJson(),
      token: ApiKey.seckretKey,
    );

    return PaymentIntentModel.fromJson(response.data);
  }
}
