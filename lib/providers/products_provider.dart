import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/product_model.dart';

class ProductsProvider extends ChangeNotifier {
  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _subscription;
  List<ProductModel> _products = [];
  bool _isLoading = false;
  String? _error;

  ProductsProvider() {
    _bindProducts();
  }

  List<ProductModel> get products => List.unmodifiable(_products);
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<ProductModel> get featuredProducts {
    final featured = _products.where((product) => product.isFeatured).toList();
    return featured.isEmpty ? _products.take(2).toList() : featured;
  }

  List<ProductModel> get newArrivals {
    final arrivals = _products.where((product) => product.isNew).toList();
    return arrivals.isEmpty ? _products.take(4).toList() : arrivals;
  }

  void _bindProducts() {
    if (Firebase.apps.isEmpty) return;

    _isLoading = true;
    _subscription = FirebaseFirestore.instance
        .collection('products')
        .snapshots()
        .listen(
          (snapshot) {
            _products = snapshot.docs
                .map((doc) => ProductModel.fromFirestore(doc.id, doc.data()))
                .where((product) => product.name.trim().isNotEmpty)
                .toList();
            _products.sort((a, b) => a.name.compareTo(b.name));
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
    _subscription?.cancel();
    super.dispose();
  }
}
