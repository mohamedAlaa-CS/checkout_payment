import 'dart:developer';

import 'package:checkout_payment_ui/Features/checkout/data/models/payment_intent_input_model.dart';
import 'package:checkout_payment_ui/Features/checkout/data/repos/checkout_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

part 'payment_state.dart';

class PaymentCubit extends Cubit<PaymentState> {
  PaymentCubit(this.checkoutRepo) : super(PaymentInitial());

  final CheckoutRepo checkoutRepo;

  Future makePayment(
      {required PaymentIntentInputModel paymentIntentInputModel}) async {
    emit(PaymentLoading());

    var data = await checkoutRepo.makePayment(
        paymentIntentInputModel: paymentIntentInputModel);
    data.fold((l) => emit(PaymentFailuer(errorMessage: l.errorMessage)),
        (r) => emit(PaymentSuccess()));
  }

  @override
  void onChange(Change<PaymentState> change) {
    log(change.toString());
    super.onChange(change);
  }
}
