import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/cart_item_model.dart';
import '../models/order_model.dart';
import 'user_provider.dart';

class OrdersProvider extends ChangeNotifier {
  final UserProvider _userProvider;
  final List<OrderModel> _orders = [];
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _ordersSubscription;
  String? _boundUserId;
  bool _isLoading = false;
  String? _error;

  OrdersProvider(this._userProvider) {
    _userProvider.addListener(_bindOrdersForCurrentUser);
    _bindOrdersForCurrentUser();
  }

  List<OrderModel> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get orderCount => _orders.length;

  int get itemCount => _orders.fold(
    0,
    (totalItems, order) =>
        totalItems +
        order.items.fold(0, (itemSum, item) => itemSum + item.quantity),
  );

  Future<OrderModel> placeOrder({
    required List<CartItemModel> items,
    required double total,
    required String deliveryAddress,
    required String customerName,
    required String phoneNumber,
    required String shippingAddress,
    required String city,
    required String postalCode,
  }) async {
    final user = _userProvider.user;
    if (user == null) {
      throw StateError('Please login before placing an order.');
    }
    if (Firebase.apps.isEmpty) {
      throw StateError('Firebase is not initialized for this platform.');
    }

    final now = DateTime.now();
    final order = OrderModel(
      id: _buildOrderId(now),
      userId: user.id,
      items: items
          .map(
            (item) => CartItemModel(
              product: item.product,
              selectedSize: item.selectedSize,
              quantity: item.quantity,
            ),
          )
          .toList(),
      total: total,
      status: 'Processing',
      createdAt: now,
      deliveryAddress: deliveryAddress,
      customerName: customerName,
      customerEmail: user.email,
      phoneNumber: phoneNumber,
      shippingAddress: shippingAddress,
      city: city,
      postalCode: postalCode,
    );

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(order.id)
        .set(order.toFirestore());

    if (!_orders.any((savedOrder) => savedOrder.id == order.id)) {
      _orders.insert(0, order);
      notifyListeners();
    }

    return order;
  }

  void clearOrders() {
    _orders.clear();
    notifyListeners();
  }

  String _buildOrderId(DateTime date) {
    final stamp = date.millisecondsSinceEpoch.toString();
    return '#KF${stamp.substring(stamp.length - 8)}';
  }

  void _bindOrdersForCurrentUser() {
    final userId = _userProvider.user?.id;
    if (_boundUserId == userId) return;

    _ordersSubscription?.cancel();
    _orders.clear();
    _boundUserId = userId;
    _error = null;

    if (userId == null || Firebase.apps.isEmpty) {
      _isLoading = false;
      notifyListeners();
      return;
    }

    _isLoading = true;
    notifyListeners();

    _ordersSubscription = FirebaseFirestore.instance
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .listen(
          (snapshot) {
            _orders
              ..clear()
              ..addAll(
                snapshot.docs.map(
                  (doc) => OrderModel.fromFirestore(doc.id, doc.data()),
                ),
              )
              ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            _isLoading = false;
            _error = null;
            notifyListeners();
          },
          onError: (Object error) {
            _isLoading = false;
            _error = error.toString();
            notifyListeners();
          },
        );
  }

  @override
  void dispose() {
    _userProvider.removeListener(_bindOrdersForCurrentUser);
    _ordersSubscription?.cancel();
    super.dispose();
  }
}
