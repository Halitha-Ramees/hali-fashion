import 'product_model.dart';

class CartItemModel {
  final ProductModel product;
  final String selectedSize;
  int quantity;

  CartItemModel({
    required this.product,
    required this.selectedSize,
    this.quantity = 1,
  });

  double get totalPrice => product.price * quantity;

  factory CartItemModel.fromFirestore(Map<String, dynamic> data) {
    final productData = data['product'] as Map<String, dynamic>? ?? {};
    final productId =
        (data['productId'] as String?) ?? (productData['id'] as String?) ?? '';

    return CartItemModel(
      product: ProductModel.fromFirestore(productId, productData),
      selectedSize: (data['selectedSize'] as String?) ?? '',
      quantity: (data['quantity'] as num?)?.toInt() ?? 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': product.id,
      'selectedSize': selectedSize,
      'quantity': quantity,
      'unitPrice': product.price,
      'totalPrice': totalPrice,
      'product': {'id': product.id, ...product.toFirestore()},
    };
  }
}
