import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/products_provider.dart';

class ProductDetailScreen extends StatefulWidget {
  final ProductModel product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _selectedSize = 2;
  int _quantity = 1;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final sizes = product.sizes;
    final relatedProducts = context
        .watch<ProductsProvider>()
        .products
        .where((related) => related.id != product.id)
        .take(4)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: [
          // ── Decorative glow blobs ─────────────────────────────────────
          Positioned(
            top: 80,
            right: 0,
            child: Container(
              width: 128,
              height: 256,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Positioned(
            bottom: 160,
            left: 0,
            child: Container(
              width: 192,
              height: 192,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.05),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),

          // ── Scrollable content ────────────────────────────────────────
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 160),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image
                SizedBox(
                  height: 380,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(color: AppColors.surfaceContainerLowest),
                      Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: AppColors.surfaceContainerLowest),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              AppColors.surface.withValues(alpha: 0.6),
                            ],
                            stops: const [0.5, 1.0],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Content card — overlapping hero
                Transform.translate(
                  offset: const Offset(0, -48),
                  child: Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(24),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.4),
                          blurRadius: 32,
                          offset: const Offset(0, -8),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Collection badge
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            'A/W COLLECTION',
                            style: GoogleFonts.raleway(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 10 * 0.15,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Product name
                        Text(
                          product.name.toUpperCase(),
                          style: GoogleFonts.raleway(
                            fontSize: 26,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFFF5F5F0),
                            letterSpacing: -0.5,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 20),

                        // Price row
                        Row(
                          children: [
                            Text(
                              '\$${product.price.toStringAsFixed(2)}',
                              style: GoogleFonts.raleway(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              '\$${(product.price * 1.44).toStringAsFixed(2)}',
                              style: GoogleFonts.raleway(
                                fontSize: 12,
                                color: AppColors.onSurfaceVariant.withValues(
                                  alpha: 0.6,
                                ),
                                decoration: TextDecoration.lineThrough,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),

                        // The Detail
                        _SectionLabel(label: 'The Detail'),
                        const SizedBox(height: 12),
                        Text(
                          product.description,
                          style: GoogleFonts.raleway(
                            fontSize: 13,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.8,
                            ),
                            height: 1.7,
                          ),
                        ),
                        const SizedBox(height: 32),

                        // Size selection
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _SectionLabel(label: 'Select Size'),
                            Text(
                              'Size Guide',
                              style: GoogleFonts.raleway(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                letterSpacing: 10 * 0.1,
                                color: AppColors.onSurfaceVariant,
                                decoration: TextDecoration.underline,
                                decorationColor: AppColors.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: List.generate(sizes.length, (i) {
                            final selected = i == _selectedSize;
                            return GestureDetector(
                              onTap: () => setState(() => _selectedSize = i),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: selected
                                      ? AppColors.primary.withValues(
                                          alpha: 0.05,
                                        )
                                      : Colors.transparent,
                                  border: Border.all(
                                    color: selected
                                        ? AppColors.primary
                                        : AppColors.outlineVariant.withValues(
                                            alpha: 0.2,
                                          ),
                                    width: selected ? 2 : 1,
                                  ),
                                ),
                                child: Center(
                                  child: Text(
                                    sizes[i],
                                    style: GoogleFonts.raleway(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: selected
                                          ? AppColors.primary
                                          : AppColors.onSurface,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                        const SizedBox(height: 32),

                        // Quantity
                        _SectionLabel(label: 'Quantity'),
                        const SizedBox(height: 16),
                        Container(
                          width: 128,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerHigh,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (_quantity > 1) {
                                    setState(() => _quantity--);
                                  }
                                },
                                child: Icon(
                                  Icons.remove,
                                  size: 18,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              Text(
                                '$_quantity',
                                style: GoogleFonts.raleway(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.onSurface,
                                ),
                              ),
                              GestureDetector(
                                onTap: () => setState(() => _quantity++),
                                child: Icon(
                                  Icons.add,
                                  size: 18,
                                  color: AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 40),

                        if (relatedProducts.isNotEmpty) ...[
                          Text(
                            'YOU MAY ALSO LIKE',
                            style: GoogleFonts.raleway(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 11 * 0.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 220,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: relatedProducts.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 16),
                              itemBuilder: (_, i) =>
                                  _RelatedCard(product: relatedProducts[i]),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Floating App Bar ──────────────────────────────────────────
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 56 + MediaQuery.of(context).padding.top,
              padding: EdgeInsets.only(
                top: MediaQuery.of(context).padding.top,
                left: 8,
                right: 8,
              ),
              decoration: const BoxDecoration(color: Color(0x990E0E0E)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                      color: AppColors.onSurface,
                      size: 22,
                    ),
                    onPressed: () => Navigator.maybePop(context),
                  ),
                  Text(
                    'PRODUCT DETAILS',
                    style: GoogleFonts.raleway(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                      letterSpacing: 13 * 0.18,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.shopping_bag_outlined,
                      color: AppColors.onSurface,
                      size: 22,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),

          // ── Bottom Actions ────────────────────────────────────────────
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                24,
                16,
                24,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              decoration: const BoxDecoration(color: Color(0x990E0E0E)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ADD TO CART
                  GestureDetector(
                    onTap: () {
                      final cart = context.read<CartProvider>();
                      final size = sizes.isNotEmpty
                          ? sizes[_selectedSize.clamp(0, sizes.length - 1)]
                          : 'One Size';
                      for (var i = 0; i < _quantity; i++) {
                        cart.addItem(product, size);
                      }
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Added to cart',
                            style: GoogleFonts.raleway(
                              color: AppColors.onPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          backgroundColor: AppColors.primary,
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.primary,
                            AppColors.primaryContainer,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.4),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            size: 18,
                            color: AppColors.onPrimary,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            'ADD TO CART',
                            style: GoogleFonts.raleway(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: AppColors.onPrimary,
                              letterSpacing: 12 * 0.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Section Label ────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.raleway(
        fontSize: 10,
        fontWeight: FontWeight.w700,
        color: AppColors.primary,
        letterSpacing: 10 * 0.2,
      ),
    );
  }
}

// ─── Related Card ─────────────────────────────────────────────────────────────

class _RelatedCard extends StatelessWidget {
  final ProductModel product;
  const _RelatedCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: Image.network(
                product.imageUrl,
                width: 140,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: AppColors.surfaceContainerLow),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.raleway(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: GoogleFonts.raleway(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}
