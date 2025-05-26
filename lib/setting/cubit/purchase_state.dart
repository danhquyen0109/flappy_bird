import 'package:equatable/equatable.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

enum AppPurchaseStatus { initial, loading, available, purchased, error }

class PurchaseState extends Equatable {
  final AppPurchaseStatus status;
  final List<ProductDetails> products;
  final String? error;
  final bool isPending;

  const PurchaseState({
    this.status = AppPurchaseStatus.initial,
    this.products = const [],
    this.error,
    this.isPending = false,
  });

  PurchaseState copyWith({
    AppPurchaseStatus? status,
    List<ProductDetails>? products,
    String? error,
    bool? isPending,
  }) {
    return PurchaseState(
      status: status ?? this.status,
      products: products ?? this.products,
      error: error ?? this.error,
      isPending: isPending ?? this.isPending,
    );
  }

  @override
  List<Object?> get props => [status, products, error, isPending];
}
