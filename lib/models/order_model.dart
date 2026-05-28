import 'package:cloud_firestore/cloud_firestore.dart';

import 'cart_item_model.dart';

class OrderModel {
  final String id;
  final String userId;
  final List<CartItemModel> items;
  final double total;
  final String status;
  final DateTime createdAt;
  final String deliveryAddress;
  final String customerName;
  final String customerEmail;
  final String phoneNumber;
  final String shippingAddress;
  final String city;
  final String postalCode;

  const OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
    required this.deliveryAddress,
    this.customerName = '',
    this.customerEmail = '',
    this.phoneNumber = '',
    this.shippingAddress = '',
    this.city = '',
    this.postalCode = '',
  });

  factory OrderModel.fromFirestore(String id, Map<String, dynamic> data) {
    final itemsData = data['items'] as Iterable? ?? const [];
    final createdAt = data['createdAt'];

    return OrderModel(
      id: id,
      userId: (data['userId'] as String?) ?? '',
      items: itemsData
          .whereType<Map<String, dynamic>>()
          .map(CartItemModel.fromFirestore)
          .toList(),
      total: _asDouble(data['total']),
      status: (data['status'] as String?) ?? 'Processing',
      createdAt: createdAt is Timestamp
          ? createdAt.toDate()
          : DateTime.tryParse(createdAt?.toString() ?? '') ?? DateTime.now(),
      deliveryAddress: (data['deliveryAddress'] as String?) ?? '',
      customerName: (data['customerName'] as String?) ?? '',
      customerEmail: (data['customerEmail'] as String?) ?? '',
      phoneNumber: (data['phoneNumber'] as String?) ?? '',
      shippingAddress: (data['shippingAddress'] as String?) ?? '',
      city: (data['city'] as String?) ?? '',
      postalCode: (data['postalCode'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'items': items.map((item) => item.toFirestore()).toList(),
      'total': total,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'deliveryAddress': deliveryAddress,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'phoneNumber': phoneNumber,
      'shippingAddress': shippingAddress,
      'city': city,
      'postalCode': postalCode,
    };
  }

  static double _asDouble(Object? value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }
}
