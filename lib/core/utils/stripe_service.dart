import 'package:checkout_payment_ui/Features/checkout/data/models/ephameral_key_model/ephameral_key_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/models/initi_payment_sheet_input_model.dart';
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

  Future initPaymentSheet(
      {required InitiPaymentSheetInputModel initpaymentsheetInputModel}) async {
    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: initpaymentsheetInputModel.clientSecret,
        customerId: initpaymentsheetInputModel.customerId,
        customerEphemeralKeySecret:
            initpaymentsheetInputModel.ephemeralKeySecret,
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
    var ephameralKeyModel = await createEphameralKey(
      customerId: paymentIntentInputModel.customerId,
    );
    var initiPaymentSheetInputModel = InitiPaymentSheetInputModel(
      customerId: paymentIntentInputModel.customerId,
      ephemeralKeySecret: ephameralKeyModel.secret!,
      clientSecret: paymentIntentModel.clientSecret!,
    );
    await initPaymentSheet(
        initpaymentsheetInputModel: initiPaymentSheetInputModel);
    await displayPaymentSheet();
  }

  Future<EphameralKeyModel> createEphameralKey(
      {required String customerId}) async {
    var response = await ApiService.post(
        url: 'https://api.stripe.com/v1/ephemeral_keys',
        data: {'customer': customerId},
        token: ApiKey.seckretKey,
        //contentType: Headers.formUrlEncodedContentType,
        headers: {
          'Authorization': 'Bearer ${ApiKey.seckretKey}',
          'Stripe-Version': '2024-04-10',
          'Content-Type': Headers.formUrlEncodedContentType
        });

    return EphameralKeyModel.fromJson(response.data);
  }
}
