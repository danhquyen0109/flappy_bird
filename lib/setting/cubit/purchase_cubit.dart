import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:galaxy_bird/setting/cubit/setting_cubit.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'purchase_state.dart';

class PurchaseCubit extends Cubit<PurchaseState> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final SettingCubit settingCubit;

  final List<String> _productIds = [
    'coin_pack_100',
    'coin_pack_250',
    'coin_pack_500',
    'coin_pack_1000',
    'coin_pack_2500',
    'coin_pack_5000',
    'coin_pack_10000',
  ];

  PurchaseCubit({required this.settingCubit}) : super(const PurchaseState()) {
    _init();
  }

  Future<void> _init() async {
    final bool available = await _inAppPurchase.isAvailable();
    if (!available) {
      emit(
        state.copyWith(
          status: AppPurchaseStatus.error,
          error: 'Store not available',
        ),
      );
      return;
    }

    _subscription = _inAppPurchase.purchaseStream.listen(
      _onPurchaseUpdate,
      onDone: () => _subscription?.cancel(),
      onError: (error) {
        emit(
          state.copyWith(
            status: AppPurchaseStatus.error,
            error: error.toString(),
          ),
        );
      },
    );

    await loadProducts();
  }

  Future<void> loadProducts() async {
    emit(state.copyWith(status: AppPurchaseStatus.loading));

    final ProductDetailsResponse response = await _inAppPurchase
        .queryProductDetails(_productIds.toSet());

    if (response.error != null) {
      emit(
        state.copyWith(
          status: AppPurchaseStatus.error,
          error: response.error!.message,
        ),
      );
      return;
    }

    if (response.productDetails.isEmpty) {
      emit(
        state.copyWith(
          status: AppPurchaseStatus.error,
          error: 'No products found',
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: AppPurchaseStatus.available,
        products: response.productDetails,
      ),
    );
  }

  Future<void> buyProduct(ProductDetails product) async {
    final PurchaseParam purchaseParam = PurchaseParam(productDetails: product);
    await _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
  }

  void _onPurchaseUpdate(List<PurchaseDetails> purchaseDetailsList) async {
    for (var purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        emit(state.copyWith(isPending: true));
      } else {
        if (purchaseDetails.status == PurchaseStatus.error) {
          emit(
            state.copyWith(
              isPending: false,
              status: AppPurchaseStatus.error,
              error: purchaseDetails.error!.message,
            ),
          );
        } else if (purchaseDetails.status == PurchaseStatus.purchased) {
          _handlePurchased(purchaseDetails);
        }

        if (purchaseDetails.pendingCompletePurchase) {
          await _inAppPurchase.completePurchase(purchaseDetails);
        }
      }
    }
  }

  void _handlePurchased(PurchaseDetails details) {
    // Add coins based on product ID
    final coinAmount = switch (details.productID) {
      'coin_pack_100' => 100,
      'coin_pack_250' => 250,
      'coin_pack_500' => 500,
      'coin_pack_1000' => 1000,
      'coin_pack_2500' => 2500,
      'coin_pack_5000' => 5000,
      'coin_pack_10000' => 10000,
      _ => 0,
    };

    settingCubit.updateCoinAndFruit(coin: coinAmount);
    emit(state.copyWith(status: AppPurchaseStatus.purchased, isPending: false));
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
