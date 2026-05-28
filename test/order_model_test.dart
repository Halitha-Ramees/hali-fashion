import 'package:flutter_test/flutter_test.dart';
import 'package:kalifashion/models/order_model.dart';

void main() {
  test('serializes customer and delivery details for Firestore orders', () {
    final order = OrderModel(
      id: '#KF00000001',
      userId: 'user-123',
      items: const [],
      total: 1200,
      status: 'Processing',
      createdAt: DateTime(2026, 5, 28),
      deliveryAddress: 'Haini, +94 77 000 0000, Colombo',
      customerName: 'Haini',
      customerEmail: 'haini@example.com',
      phoneNumber: '+94 77 000 0000',
      shippingAddress: 'Street address',
      city: 'Colombo',
      postalCode: '00100',
    );

    final data = order.toFirestore();

    expect(data['userId'], 'user-123');
    expect(data['customerName'], 'Haini');
    expect(data['customerEmail'], 'haini@example.com');
    expect(data['phoneNumber'], '+94 77 000 0000');
    expect(data['shippingAddress'], 'Street address');
    expect(data['city'], 'Colombo');
    expect(data['postalCode'], '00100');
  });
}
