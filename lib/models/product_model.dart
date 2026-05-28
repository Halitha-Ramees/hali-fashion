class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final String category;
  final String imageUrl;
  final List<String> sizes;
  final bool isNew;
  final bool isFeatured;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.imageUrl,
    required this.sizes,
    this.isNew = false,
    this.isFeatured = false,
  });

  factory ProductModel.fromFirestore(String id, Map<String, dynamic> data) {
    final storedId =
        (data['productId'] as String?) ?? (data['id'] as String?) ?? '';
    final productId = id.trim().isNotEmpty ? id : storedId;

    return ProductModel(
      id: productId,
      name: (data['name'] as String?) ?? '',
      description: (data['description'] as String?) ?? '',
      price: _asDouble(data['price']),
      category: (data['category'] as String?) ?? '',
      imageUrl: (data['imageUrl'] as String?) ?? '',
      sizes: _asStringList(data['sizes']),
      isNew: (data['isNew'] as bool?) ?? false,
      isFeatured: (data['isFeatured'] as bool?) ?? false,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': id,
      'name': name,
      'description': description,
      'price': price,
      'category': category,
      'imageUrl': imageUrl,
      'sizes': sizes,
      'isNew': isNew,
      'isFeatured': isFeatured,
    };
  }

  static double _asDouble(Object? value) {
    if (value is int) return value.toDouble();
    if (value is double) return value;
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static List<String> _asStringList(Object? value) {
    if (value is Iterable) {
      return value.whereType<String>().toList();
    }
    return const [];
  }
}
