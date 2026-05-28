import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final _searchController = TextEditingController();
  int _activeFilter = 0;

  static const _filters = [
    'All Items',
    'Outerwear',
    'Dresses',
    'Accessories',
    'Footwear',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();
    final products = _filteredProducts(productsProvider.products);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: CustomScrollView(
        slivers: [
          // ── Sticky App Bar ────────────────────────────────────────────
          SliverAppBar(
            pinned: true,
            elevation: 0,
            toolbarHeight: 56,
            backgroundColor: AppColors.surfaceContainerLowest.withValues(
              alpha: 0.85,
            ),
            automaticallyImplyLeading: false,
            flexibleSpace: Align(
              alignment: Alignment.bottomCenter,
              child: SizedBox(
                height: 56,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Icon(
                        Icons.arrow_back,
                        color: AppColors.primary,
                        size: 24,
                      ),
                      Text(
                        'SHOP',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 16 * 0.18,
                        ),
                      ),
                      Icon(
                        Icons.filter_list,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Search Bar ────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
              child: TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                style: GoogleFonts.raleway(
                  fontSize: 14,
                  color: AppColors.onSurface,
                ),
                decoration: InputDecoration(
                  hintText: 'Search collections...',
                  hintStyle: GoogleFonts.raleway(
                    fontSize: 14,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.4),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
                    size: 22,
                  ),
                  filled: true,
                  fillColor: const Color(0xFF1A1A1A),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      width: 1,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // ── Filter Chips ──────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _filters.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final active = i == _activeFilter;
                    return GestureDetector(
                      onTap: () => setState(() => _activeFilter = i),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 180),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: active
                              ? AppColors.primary
                              : AppColors.surfaceContainerLow,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          _filters[i].toUpperCase(),
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 10 * 0.05,
                            color: active
                                ? AppColors.onPrimary
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          // ── Product Grid ──────────────────────────────────────────────
          if (products.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyProducts(isLoading: productsProvider.isLoading),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 32, 24, 96),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 0,
                  childAspectRatio: 0.52,
                ),
                delegate: SliverChildBuilderDelegate((_, i) {
                  final product = products[i];
                  return _ProductCard(
                    product: product,
                    onTap: () =>
                        context.push('/product-detail', extra: product),
                    topOffset: _staggerOffset(i),
                  );
                }, childCount: products.length),
              ),
            ),
        ],
      ),
    );
  }

  List<ProductModel> _filteredProducts(List<ProductModel> products) {
    final query = _searchController.text.trim().toLowerCase();
    final selectedFilter = _filters[_activeFilter].toLowerCase();

    return products.where((product) {
      final matchesSearch =
          query.isEmpty ||
          product.name.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
      final matchesFilter =
          _activeFilter == 0 ||
          product.category.toLowerCase() == selectedFilter ||
          product.name.toLowerCase().contains(selectedFilter);
      return matchesSearch && matchesFilter;
    }).toList();
  }

  double _staggerOffset(int i) {
    if (i == 1) return 32;
    if (i == 5) return 48;
    if (i.isOdd) return 32;
    return 0;
  }
}

// ─── Product Card ─────────────────────────────────────────────────────────────

class _EmptyProducts extends StatelessWidget {
  final bool isLoading;

  const _EmptyProducts({required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isLoading)
              const CircularProgressIndicator(color: AppColors.primary)
            else
              Icon(
                Icons.inventory_2_outlined,
                size: 56,
                color: AppColors.outlineVariant,
              ),
            const SizedBox(height: 16),
            Text(
              isLoading ? 'Loading products' : 'No products found',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  final double topOffset;

  const _ProductCard({
    required this.product,
    required this.onTap,
    this.topOffset = 0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: topOffset, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: SizedBox.expand(
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) =>
                            Container(color: AppColors.surfaceContainerLow),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
                height: 1.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
                letterSpacing: -0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
