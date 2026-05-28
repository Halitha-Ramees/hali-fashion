import 'package:flutter/foundation.dart';
import '../models/cart_item_model.dart';
import '../models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount => _items.fold(0, (sum, i) => sum + i.quantity);

  double get subtotal => _items.fold(0, (sum, i) => sum + i.totalPrice);

  double get deliveryFee => _items.isEmpty ? 0 : 350;

  double get total => subtotal + deliveryFee;

  void addItem(ProductModel product, String size) {
    final index = _items.indexWhere(
      (i) => i.product.id == product.id && i.selectedSize == size,
    );
    if (index >= 0) {
      _items[index].quantity++;
    } else {
      _items.add(CartItemModel(product: product, selectedSize: size));
    }
    notifyListeners();
  }

  void removeItem(String productId, String size) {
    _items.removeWhere(
      (i) => i.product.id == productId && i.selectedSize == size,
    );
    notifyListeners();
  }

  void incrementQuantity(String productId, String size) {
    final index = _items.indexWhere(
      (i) => i.product.id == productId && i.selectedSize == size,
    );
    if (index >= 0) {
      _items[index].quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String productId, String size) {
    final index = _items.indexWhere(
      (i) => i.product.id == productId && i.selectedSize == size,
    );
    if (index >= 0) {
      if (_items[index].quantity > 1) {
        _items[index].quantity--;
      } else {
        _items.removeAt(index);
      }
      notifyListeners();
    }
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
