import 'package:flutter_test/flutter_test.dart';
import 'package:kalifashion/models/product_model.dart';

void main() {
  test('serializes product id for Firestore catalog documents', () {
    const product = ProductModel(
      id: 'p001',
      name: 'Classic Black Blazer',
      description: 'Premium blazer',
      price: 8500,
      category: 'Men',
      imageUrl: 'https://example.com/blazer.jpg',
      sizes: ['S', 'M'],
      isFeatured: true,
    );

    expect(product.toFirestore()['productId'], 'p001');
  });

  test('prefers Firestore document id when reading catalog products', () {
    final product = ProductModel.fromFirestore('p001', {
      'productId': 'legacy-id',
      'name': 'Classic Black Blazer',
      'description': 'Premium blazer',
      'price': 8500,
      'category': 'Men',
      'imageUrl': 'https://example.com/blazer.jpg',
      'sizes': ['S', 'M'],
    });

    expect(product.id, 'p001');
  });
}
