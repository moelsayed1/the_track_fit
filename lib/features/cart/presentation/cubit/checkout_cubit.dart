import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:the_track_fit/features/cart/data/services/checkout_service.dart';
import 'package:the_track_fit/features/cart/domain/models/shipping_government.dart';
import 'package:the_track_fit/features/cart/domain/models/checkout_request.dart';
import 'package:the_track_fit/features/cart/domain/models/checkout_response.dart';

// Events
abstract class CheckoutEvent {}

class LoadShippingGovernments extends CheckoutEvent {}

class SubmitOrder extends CheckoutEvent {
  final CheckoutRequest request;

  SubmitOrder({required this.request});
}

// States
abstract class CheckoutState {}

class CheckoutInitial extends CheckoutState {}

class CheckoutLoading extends CheckoutState {}

class ShippingGovernmentsLoaded extends CheckoutState {
  final List<ShippingGovernment> governments;

  ShippingGovernmentsLoaded({required this.governments});
}

class OrderSubmitted extends CheckoutState {
  final CheckoutResponse response;

  OrderSubmitted({required this.response});
}

class CheckoutError extends CheckoutState {
  final String message;

  CheckoutError({required this.message});
}

// Cubit
class CheckoutCubit extends Cubit<CheckoutState> {
  final CheckoutService _checkoutService;

  CheckoutCubit({required CheckoutService checkoutService}) 
      : _checkoutService = checkoutService,
        super(CheckoutInitial());

  // Load shipping governments
  Future<void> loadShippingGovernments() async {
    emit(CheckoutLoading());
    
    try {
      final governments = await _checkoutService.getShippingGovernments();
      emit(ShippingGovernmentsLoaded(governments: governments));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  // Submit order
  Future<void> submitOrder(CheckoutRequest request, {String? paymentProofPath}) async {
    emit(CheckoutLoading());
    
    try {
      final response = await _checkoutService.submitOrder(request, paymentProofPath: paymentProofPath);
      emit(OrderSubmitted(response: response));
    } catch (e) {
      emit(CheckoutError(message: e.toString()));
    }
  }

  // Get shipping cost for a specific government
  double getShippingCostForGovernment(
    List<ShippingGovernment> governments, 
    String governmentName
  ) {
    try {
      final government = governments.firstWhere(
        (gov) => gov.nameEn.toLowerCase() == governmentName.toLowerCase(),
      );
      return government.shippingCost;
    } catch (e) {
      // If government not found in API data, return default cost
      return 50.0; // Default shipping cost
    }
  }

  // Get government ID for a specific government name
  int getGovernmentIdForName(
    List<ShippingGovernment> governments, 
    String governmentName
  ) {
    try {
      final government = governments.firstWhere(
        (gov) => gov.nameEn.toLowerCase() == governmentName.toLowerCase(),
      );
      return government.id;
    } catch (e) {
      // If government not found in API data, return default ID
      return 1; // Default government ID
    }
  }
}
