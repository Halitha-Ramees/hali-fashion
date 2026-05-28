import '../../models/product_model.dart';

class MockData {
  MockData._();

  static const String _placeholder =
      'https://images.unsplash.com/photo-1523381210434-271e8be1f52b?w=400';

  static final List<ProductModel> products = [
    ProductModel(
      id: 'p001',
      name: 'Classic Black Blazer',
      description:
          'A timeless black blazer crafted from premium fabric. '
          'Perfect for both formal and smart-casual occasions.',
      price: 8500,
      category: 'Men',
      imageUrl: _placeholder,
      sizes: ['S', 'M', 'L', 'XL'],
      isFeatured: true,
    ),
    ProductModel(
      id: 'p002',
      name: 'Silk Evening Dress',
      description:
          'Elegant silk evening dress with a flowing silhouette. '
          'Designed for the modern woman.',
      price: 12500,
      category: 'Women',
      imageUrl: _placeholder,
      sizes: ['XS', 'S', 'M', 'L'],
      isFeatured: true,
      isNew: true,
    ),
    ProductModel(
      id: 'p003',
      name: 'Gold Chain Necklace',
      description:
          'Handcrafted 18k gold-plated chain necklace. '
          'A statement piece for any outfit.',
      price: 4500,
      category: 'Accessories',
      imageUrl: _placeholder,
      sizes: ['One Size'],
      isNew: true,
    ),
    ProductModel(
      id: 'p004',
      name: 'Slim Fit Trousers',
      description:
          'Tailored slim-fit trousers in charcoal grey. '
          'Versatile and sophisticated.',
      price: 5500,
      category: 'Men',
      imageUrl: _placeholder,
      sizes: ['S', 'M', 'L', 'XL'],
    ),
    ProductModel(
      id: 'p005',
      name: 'Wrap Midi Skirt',
      description:
          'Elegant wrap midi skirt in deep navy. '
          'Effortlessly chic for any occasion.',
      price: 6200,
      category: 'Women',
      imageUrl: _placeholder,
      sizes: ['XS', 'S', 'M', 'L'],
      isFeatured: true,
    ),
    ProductModel(
      id: 'p006',
      name: 'Leather Oxford Shoes',
      description:
          'Premium full-grain leather oxford shoes. '
          'Handcrafted for lasting comfort and style.',
      price: 15000,
      category: 'Footwear',
      imageUrl: _placeholder,
      sizes: ['40', '41', '42', '43', '44'],
      isNew: true,
    ),
    ProductModel(
      id: 'p007',
      name: 'Cashmere Turtleneck',
      description:
          'Luxuriously soft cashmere turtleneck sweater. '
          'Available in classic neutral tones.',
      price: 9800,
      category: 'Women',
      imageUrl: _placeholder,
      sizes: ['XS', 'S', 'M', 'L', 'XL'],
      isFeatured: true,
      isNew: true,
    ),
    ProductModel(
      id: 'p008',
      name: 'Structured Tote Bag',
      description:
          'Premium structured tote in genuine leather. '
          'Spacious, stylish, and built to last.',
      price: 11000,
      category: 'Accessories',
      imageUrl: _placeholder,
      sizes: ['One Size'],
    ),
  ];

  static List<ProductModel> get featuredProducts =>
      products.where((p) => p.isFeatured).toList();

  static List<ProductModel> get newArrivals =>
      products.where((p) => p.isNew).toList();

  static List<ProductModel> getByCategory(String category) {
    if (category == 'All') return products;
    return products.where((p) => p.category == category).toList();
  }
}
