import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/product_model.dart';
import '../../providers/products_provider.dart';

class HomeScreen extends StatefulWidget {
  final VoidCallback? onShopTap;
  const HomeScreen({super.key, this.onShopTap});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedCategory = 0;

  static const _categories = [
    'All Collections',
    'Outerwear',
    'Essentials',
    'Accessories',
    'Footwear',
  ];

  @override
  Widget build(BuildContext context) {
    final productsProvider = context.watch<ProductsProvider>();
    final featured = productsProvider.featuredProducts;
    final arrivals = productsProvider.newArrivals;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
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
                      Icon(Icons.menu, color: AppColors.primary, size: 24),
                      Text(
                        'KALI FASHION',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 16 * 0.18,
                        ),
                      ),
                      Icon(
                        Icons.shopping_bag_outlined,
                        color: AppColors.primary,
                        size: 24,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // ── Hero Banner ───────────────────────────────────────────────
          SliverToBoxAdapter(child: _HeroBanner(onShopTap: widget.onShopTap)),

          // ── Category Chips ────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 0),
              child: SizedBox(
                height: 40,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  itemCount: _categories.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (_, i) {
                    final active = i == _selectedCategory;
                    return GestureDetector(
                      onTap: () => setState(() => _selectedCategory = i),
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
                          _categories[i],
                          style: GoogleFonts.raleway(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
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

          // ── Featured Section ──────────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 64, 24, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    'FEATURED',
                    style: GoogleFonts.raleway(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.3,
                    ),
                  ),
                  GestureDetector(
                    onTap: widget.onShopTap,
                    child: Text(
                      'VIEW ALL',
                      style: GoogleFonts.raleway(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: 10 * 0.2,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 0,
                childAspectRatio: 0.55,
              ),
              delegate: SliverChildBuilderDelegate(
                (_, i) => _ProductCard(
                  product: featured[i],
                  staggered: i.isOdd,
                  onTap: () =>
                      context.push('/product-detail', extra: featured[i]),
                ),
                childCount: featured.length,
              ),
            ),
          ),

          // ── New Arrivals Section ──────────────────────────────────────
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 72, 24, 28),
              child: Text(
                'NEW ARRIVALS',
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: -0.3,
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SizedBox(
              height: 380,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
                itemCount: arrivals.length,
                separatorBuilder: (_, _) => const SizedBox(width: 20),
                itemBuilder: (_, i) => _ArrivalCard(
                  product: arrivals[i],
                  onTap: () =>
                      context.push('/product-detail', extra: arrivals[i]),
                ),
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
        ],
      ),
    );
  }
}

// ─── Hero Banner ──────────────────────────────────────────────────────────────

class _HeroBanner extends StatelessWidget {
  final VoidCallback? onShopTap;
  const _HeroBanner({this.onShopTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        fit: StackFit.expand,
        children: [
          ColorFiltered(
            colorFilter: const ColorFilter.matrix([
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0.2126,
              0.7152,
              0.0722,
              0,
              0,
              0,
              0,
              0,
              1,
              0,
            ]),
            child: Image.network(
              'https://lh3.googleusercontent.com/aida-public/AB6AXuCSHbzt7Peb_aeTCkPMzzBKg75m6dVgimuwELy8U2mQweYg-slNXwe6hvcJOprUpUUyhB0mCYCFa81wCe4OoZRQxZMUbbKsuAJvOL_SrB3CtSjC8wctPLyKvgZwfcPZYThgv1c8x3jgnD-gPQSjKlr2GYc2_pw7DMo5CpOLzoc4UyLxitzmSnVLlOhsOHAkFZOifVuAnjgCCAWtgjqfbVtD-nh-aNVXFRKPLwUurqO_nYYGrMkU7h89-owpJVK8l-hY7-TnkGTbsK0',
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.surfaceContainer),
            ),
          ),
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.transparent, Color(0xFF0A0A0A)],
                stops: [0.45, 1.0],
              ),
            ),
          ),
          Positioned(
            left: 32,
            right: 32,
            bottom: 40,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Exclusive Collection',
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.primary,
                    letterSpacing: 10 * 0.2,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'NEW\nSEASON',
                  style: GoogleFonts.raleway(
                    fontSize: 52,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onSurface,
                    height: 0.95,
                    letterSpacing: -1.5,
                  ),
                ),
                const SizedBox(height: 24),
                GestureDetector(
                  onTap: onShopTap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [AppColors.primary, AppColors.primaryContainer],
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'SHOP NOW',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onPrimary,
                        letterSpacing: 12 * 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Product Card (Featured Grid) ────────────────────────────────────────────

class _ProductCard extends StatelessWidget {
  final ProductModel product;
  final bool staggered;
  final VoidCallback onTap;

  const _ProductCard({
    required this.product,
    required this.onTap,
    this.staggered = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.only(top: staggered ? 32 : 0, bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.zero,
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
            const SizedBox(height: 12),
            Text(
              product.category.toUpperCase(),
              style: GoogleFonts.raleway(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurfaceVariant,
                letterSpacing: 9 * 0.25,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 3),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Arrival Card (Horizontal Scroll) ────────────────────────────────────────

class _ArrivalCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onTap;
  const _ArrivalCard({required this.product, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 220,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.zero,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(color: AppColors.surfaceContainerLow),
                    ),
                    Container(color: AppColors.surface.withValues(alpha: 0.1)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '\$${product.price.toStringAsFixed(2)}',
              style: GoogleFonts.raleway(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
