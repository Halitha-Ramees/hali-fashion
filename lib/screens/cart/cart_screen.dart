import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
          // ── App Bar ───────────────────────────────────────────────────
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
                      Row(
                        children: [
                          Icon(Icons.menu, color: AppColors.primary, size: 24),
                          const SizedBox(width: 16),
                          Text(
                            'KALI FASHION',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 16 * 0.18,
                            ),
                          ),
                        ],
                      ),
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            Icons.shopping_bag_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          if (items.isNotEmpty)
                            Positioned(
                              top: -4,
                              right: -4,
                              child: Container(
                                width: 16,
                                height: 16,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: Center(
                                  child: Text(
                                    '${cart.itemCount}',
                                    style: GoogleFonts.raleway(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.onPrimary,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          if (items.isEmpty)
            SliverFillRemaining(child: _EmptyCart())
          else ...[
            // ── Page Heading ──────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MY CART',
                      style: GoogleFonts.raleway(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.onSurface,
                        letterSpacing: -0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${cart.itemCount} ITEMS SELECTED',
                      style: GoogleFonts.raleway(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                        letterSpacing: 12 * 0.1,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // ── Cart Items ────────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 20),
                    child: _CartItemCard(
                      item: items[i],
                      onRemove: () => context.read<CartProvider>().removeItem(
                        items[i].product.id,
                        items[i].selectedSize,
                      ),
                      onIncrement: () =>
                          context.read<CartProvider>().incrementQuantity(
                            items[i].product.id,
                            items[i].selectedSize,
                          ),
                      onDecrement: () =>
                          context.read<CartProvider>().decrementQuantity(
                            items[i].product.id,
                            items[i].selectedSize,
                          ),
                    ),
                  ),
                  childCount: items.length,
                ),
              ),
            ),

            // ── Order Summary ─────────────────────────────────────────
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 96),
                child: _OrderSummary(subtotal: cart.subtotal),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Cart Item Card ───────────────────────────────────────────────────────────

class _CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onRemove;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const _CartItemCard({
    required this.item,
    required this.onRemove,
    required this.onIncrement,
    required this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 96,
              height: 128,
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: AppColors.surfaceContainerHigh),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Name + close
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.product.name.toUpperCase(),
                        style: GoogleFonts.raleway(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                          letterSpacing: 0.2,
                          height: 1.25,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: onRemove,
                      child: Icon(
                        Icons.close,
                        size: 18,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Size
                Text(
                  'SIZE: ${item.selectedSize}',
                  style: GoogleFonts.raleway(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: AppColors.onSurfaceVariant,
                    letterSpacing: 10 * 0.1,
                  ),
                ),
                const SizedBox(height: 20),

                // Qty + price row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerHigh,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: onDecrement,
                            child: Icon(
                              Icons.remove,
                              size: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Text(
                              '${item.quantity}',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: AppColors.onSurface,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: onIncrement,
                            child: Icon(
                              Icons.add,
                              size: 14,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Price
                    Text(
                      '\$${item.totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.raleway(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.primary,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Order Summary ────────────────────────────────────────────────────────────

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  const _OrderSummary({required this.subtotal});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.1),
        ),
      ),
      child: Column(
        children: [
          _SummaryRow(
            label: 'Subtotal',
            value: '\$${subtotal.toStringAsFixed(2)}',
            valueBold: true,
          ),
          const SizedBox(height: 16),
          const _SummaryRow(
            label: 'Shipping',
            value: 'Complimentary',
            valueBold: true,
          ),
          const SizedBox(height: 16),
          Container(
            height: 1,
            color: AppColors.outlineVariant.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'TOTAL',
                style: GoogleFonts.raleway(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                  letterSpacing: 1.0,
                ),
              ),
              Text(
                '\$${subtotal.toStringAsFixed(2)}',
                style: GoogleFonts.raleway(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // PROCEED TO CHECKOUT
          GestureDetector(
            onTap: () => context.go('/checkout'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.primary, AppColors.primaryContainer],
                ),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'PROCEED TO CHECKOUT',
                style: GoogleFonts.raleway(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onPrimary,
                  letterSpacing: 12 * 0.1,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool valueBold;
  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.raleway(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            color: AppColors.onSurfaceVariant,
            letterSpacing: 10 * 0.15,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.raleway(
            fontSize: valueBold ? 13 : 12,
            fontWeight: valueBold ? FontWeight.w700 : FontWeight.w500,
            color: AppColors.onSurface,
          ),
        ),
      ],
    );
  }
}

// ─── Empty Cart ───────────────────────────────────────────────────────────────

class _EmptyCart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 56,
            color: AppColors.outlineVariant,
          ),
          const SizedBox(height: 16),
          Text(
            'Your cart is empty',
            style: GoogleFonts.raleway(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Discover pieces made for you.',
            style: GoogleFonts.raleway(
              fontSize: 13,
              color: AppColors.onSurfaceVariant.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}
