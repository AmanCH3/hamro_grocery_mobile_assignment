import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/create_order_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_my_order_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/get_my_payment_history_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/domain/usecase/update_order_usecase.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_event.dart';
import 'package:hamro_grocery_mobile/feature/order/presentation/view_model/order_state.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  final CreateOrderUseCase _createOrderUseCase;
  final GetMyOrdersUseCase _getMyOrdersUseCase;
  final UpdateOrderStatusUseCase _updateOrderStatusUseCase;
  final GetPaymentHistoryUseCase _getPaymentHistoryUseCase;

  OrderBloc({
    required CreateOrderUseCase createOrderUseCase,
    required GetMyOrdersUseCase getMyOrdersUseCase,
    required UpdateOrderStatusUseCase updateOrderStatusUseCase,
    required GetPaymentHistoryUseCase getPaymentHistoryUseCase,
  }) : _createOrderUseCase = createOrderUseCase,
       _getMyOrdersUseCase = getMyOrdersUseCase,
       _updateOrderStatusUseCase = updateOrderStatusUseCase,
       _getPaymentHistoryUseCase = getPaymentHistoryUseCase,
       super(OrderState.initial()) {
    on<CreateOrder>(_onCreateOrder);
    on<GetMyOrders>(_onGetMyOrders);
    on<UpdateOrderStatus>(_onUpdateOrderStatus);
    on<GetPaymentHistory>(_onGetPaymentHistory);
  }

  Future<void> _onCreateOrder(
    CreateOrder event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderRequestStatus.loading));
    final result = await _createOrderUseCase(
      CreateOrderParams(
        items: event.items,
        address: event.address,
        phone: event.phone,
        applyDiscount: event.applyDiscount,
      ),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderRequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (order) => emit(
        state.copyWith(
          status: OrderRequestStatus.success,
          selectedOrder: order,
        ),
      ),
    );
  }

  Future<void> _onGetMyOrders(
    GetMyOrders event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderRequestStatus.loading));
    final result = await _getMyOrdersUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderRequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (orders) => emit(
        state.copyWith(status: OrderRequestStatus.success, myOrders: orders),
      ),
    );
  }

  Future<void> _onUpdateOrderStatus(
    UpdateOrderStatus event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderRequestStatus.loading));
    final result = await _updateOrderStatusUseCase(
      UpdateOrderStatusParams(orderId: event.orderId, status: event.newStatus),
    );
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderRequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (updatedOrder) => emit(
        state.copyWith(
          status: OrderRequestStatus.success,
          selectedOrder: updatedOrder,
        ),
      ),
    );
  }

  Future<void> _onGetPaymentHistory(
    GetPaymentHistory event,
    Emitter<OrderState> emit,
  ) async {
    emit(state.copyWith(status: OrderRequestStatus.loading));
    final result = await _getPaymentHistoryUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          status: OrderRequestStatus.failure,
          errorMessage: failure.message,
        ),
      ),
      (history) => emit(
        state.copyWith(
          status: OrderRequestStatus.success,
          paymentHistory: history,
        ),
      ),
    );
  }
}
