import 'package:checkout_payment_ui/Features/checkout/data/models/ephameral_key_model/ephameral_key_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_model/payment_intent_model.dart';
import 'package:checkout_payment_ui/core/utils/api_key.dart';
import 'package:checkout_payment_ui/core/utils/api_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

class StripeService {
  Future<PaymentIntentModel> createPaymentIntetnt(
    PaymentIntentInputModel paymentIntentInputModel,
  ) async {
    var response = await ApiService.post(
        url: 'https://api.stripe.com/v1/payment_intents',
        data: paymentIntentInputModel.toJson(),
        token: ApiKey.seckretKey,
        contentType: Headers.formUrlEncodedContentType);

    return PaymentIntentModel.fromJson(response.data);
  }

  Future initPaymentSheet({required String paymentIntentClientSecret}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: paymentIntentClientSecret,
        merchantDisplayName: 'Alaa',
      ),
    );
  }

  Future displayPaymentSheet() async {
    await Stripe.instance.presentPaymentSheet();
  }

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    var paymentIntentModel =
        await createPaymentIntetnt(paymentIntentInputModel);
    await initPaymentSheet(
      paymentIntentClientSecret: paymentIntentModel.clientSecret!,
    );
    await displayPaymentSheet();
  }

  Future<EphameralKeyModel> createEphameralKey(
      {required String customerId}) async {
    var response = await ApiService.post(
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        data: {'customer': customerId},
        token: ApiKey.seckretKey,
        contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Authorization': 'Bearer ${ApiKey.seckretKey}',
          'Stripe-Version': '2024-04-10',
        });

    return EphameralKeyModel.fromJson(response.data);
  }
}
