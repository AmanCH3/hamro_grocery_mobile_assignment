import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/payment_integration_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/verify_payment_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/payment_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final InitiateKhaltiPaymentUseCase _initiateKhaltiPaymentUseCase;
  final VerifyKhaltiPaymentUseCase _verifyKhaltiPaymentUseCase;

  PaymentBloc({
    required InitiateKhaltiPaymentUseCase initiateKhaltiPaymentUseCase,
    required VerifyKhaltiPaymentUseCase verifyKhaltiPaymentUseCase,
  }) : _initiateKhaltiPaymentUseCase = initiateKhaltiPaymentUseCase,
       _verifyKhaltiPaymentUseCase = verifyKhaltiPaymentUseCase,
       super(PaymentState.initial()) {
    on<KhaltiPaymentStarted>(_onKhaltiPaymentStarted);
    on<KhaltiPaymentVerified>(_onKhaltiPaymentVerified);
  }

  Future<void> _onKhaltiPaymentStarted(
    KhaltiPaymentStarted event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final result = await _initiateKhaltiPaymentUseCase(
      InitiatePaymentParams(
        items: event.items,
        address: event.address,
        phone: event.phone,
        applyDiscount: event.applyDiscount,
      ),
    );

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatus.initiationFailure,
          errorMessage: failure.message,
        ),
      ),
      (entity) => emit(
        state.copyWith(
          status: PaymentStatus.initiationSuccess,
          pidx: entity.pidx,
        ),
      ),
    );
  }

  Future<void> _onKhaltiPaymentVerified(
    KhaltiPaymentVerified event,
    Emitter<PaymentState> emit,
  ) async {
    emit(state.copyWith(status: PaymentStatus.loading));

    final result = await _verifyKhaltiPaymentUseCase(event.pidx);

    result.fold(
      (failure) => emit(
        state.copyWith(
          status: PaymentStatus.verificationFailure,
          errorMessage: failure.message,
        ),
      ),
      (_) => emit(state.copyWith(status: PaymentStatus.verificationSuccess)),
    );
  }
}
