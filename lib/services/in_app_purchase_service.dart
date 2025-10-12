import 'dart:async';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

const String _kQuotePackId = 'quote_pack_ancient_wisdom';

class InAppPurchaseService with ChangeNotifier {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;

  bool _isAvailable = false;
  List<ProductDetails> _products = [];
  List<PurchaseDetails> _purchases = [];
  bool _purchasePending = false;
  String? _queryProductError;

  bool get isAvailable => _isAvailable;
  List<ProductDetails> get products => _products;
  List<PurchaseDetails> get purchases => _purchases;
  bool get purchasePending => _purchasePending;
  String? get queryProductError => _queryProductError;

  InAppPurchaseService() {
    _listenToPurchaseUpdates();
  }

  void _listenToPurchaseUpdates() {
    _subscription = _inAppPurchase.purchaseStream.listen(
      (purchaseDetailsList) {
        _handlePurchaseUpdates(purchaseDetailsList);
      },
      onDone: () {
        _subscription.cancel();
      },
      onError: (error) {
        _queryProductError = error.toString();
        notifyListeners();
      },
    );
  }

  Future<void> initPlatformState() async {
    _isAvailable = await _inAppPurchase.isAvailable();
    if (!_isAvailable) {
      notifyListeners();
      return;
    }

    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails({
      _kQuotePackId,
    });

    if (response.error != null) {
      _queryProductError = response.error!.message;
      notifyListeners();
      return;
    }

    _products = response.productDetails;
    notifyListeners();
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    _purchases.addAll(purchaseDetailsList);
    _purchasePending = false;
    notifyListeners();

    for (final purchase in purchaseDetailsList) {
      if (purchase.status == PurchaseStatus.pending) {
        _purchasePending = true;
      } else {
        if (purchase.status == PurchaseStatus.error) {
          _queryProductError = purchase.error!.message;
        } else if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          // Handle successful purchase/restore
        }
        if (purchase.pendingCompletePurchase) {
          _inAppPurchase.completePurchase(purchase);
        }
      }
    }
  }

  void buyQuotePack() {
    if (_products.isNotEmpty) {
      final ProductDetails productDetails = _products.firstWhere(
        (product) => product.id == _kQuotePackId,
      );
      final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
      _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
    }
  }

  Future<void> restorePurchases() async {
    await _inAppPurchase.restorePurchases();
  }
}
