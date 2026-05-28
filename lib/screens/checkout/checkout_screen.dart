import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cart_item_model.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _nameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _addressCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  bool _isPlacingOrder = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _addressCtrl.dispose();
    _cityCtrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                elevation: 0,
                toolbarHeight: 56,
                backgroundColor: AppColors.surfaceContainerLowest.withValues(
                  alpha: 0.85,
                ),
                automaticallyImplyLeading: false,
                flexibleSpace: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        onPressed: () => Navigator.maybePop(context),
                      ),
                      Text(
                        'CHECKOUT',
                        style: GoogleFonts.raleway(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.primary,
                          letterSpacing: 16 * 0.18,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.receipt_long_outlined,
                          color: AppColors.primary,
                          size: 22,
                        ),
                        onPressed: () => context.go('/main?tab=3'),
                      ),
                    ],
                  ),
                ),
              ),
              if (items.isEmpty)
                SliverFillRemaining(
                  hasScrollBody: false,
                  child: _EmptyCheckout(),
                )
              else
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(24, 24, 24, 160),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Delivery Details',
                          style: GoogleFonts.raleway(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                            letterSpacing: -0.3,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'WHERE SHOULD WE SEND YOUR PIECES?',
                          style: GoogleFonts.raleway(
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                            color: AppColors.onSurfaceVariant.withValues(
                              alpha: 0.6,
                            ),
                            letterSpacing: 10 * 0.05,
                          ),
                        ),
                        const SizedBox(height: 24),
                        _ResponsivePair(
                          left: _FormField(
                            label: 'Full Name',
                            controller: _nameCtrl,
                            hint: 'Kalitha',
                            keyboardType: TextInputType.name,
                          ),
                          right: _FormField(
                            label: 'Phone Number',
                            controller: _phoneCtrl,
                            hint: '+94 77 000 0000',
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _FormField(
                          label: 'Shipping Address',
                          controller: _addressCtrl,
                          hint: 'Street address',
                          keyboardType: TextInputType.streetAddress,
                        ),
                        const SizedBox(height: 20),
                        _ResponsivePair(
                          left: _FormField(
                            label: 'City',
                            controller: _cityCtrl,
                            hint: 'Colombo',
                          ),
                          right: _FormField(
                            label: 'Postal Code',
                            controller: _postalCtrl,
                            hint: '00100',
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(height: 48),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              'Order Summary',
                              style: GoogleFonts.raleway(
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onSurface,
                                letterSpacing: -0.3,
                              ),
                            ),
                            Text(
                              '${cart.itemCount} ITEMS',
                              style: GoogleFonts.raleway(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                                letterSpacing: 10 * 0.2,
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          color: AppColors.outlineVariant.withValues(
                            alpha: 0.1,
                          ),
                          height: 20,
                        ),
                        const SizedBox(height: 12),
                        ...items.map(
                          (item) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _CheckoutItem(item: item),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            children: [
                              _TotalRow(
                                label: 'Subtotal',
                                value: '\$${cart.subtotal.toStringAsFixed(2)}',
                              ),
                              const SizedBox(height: 16),
                              const _TotalRow(
                                label: 'Shipping',
                                value: 'Complimentary',
                                highlight: true,
                              ),
                              const SizedBox(height: 16),
                              Divider(
                                color: AppColors.outlineVariant.withValues(
                                  alpha: 0.2,
                                ),
                                height: 1,
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'TOTAL',
                                    style: GoogleFonts.raleway(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.onSurface,
                                      letterSpacing: 16 * 0.15,
                                    ),
                                  ),
                                  Text(
                                    '\$${cart.subtotal.toStringAsFixed(2)}',
                                    style: GoogleFonts.raleway(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.primary,
                                      letterSpacing: -0.5,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          if (items.isNotEmpty)
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
                decoration: const BoxDecoration(color: Color(0xCC0E0E0E)),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: _isPlacingOrder
                          ? () {}
                          : () => _placeOrder(context),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 18),
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
                              color: Colors.black.withValues(alpha: 0.5),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isPlacingOrder
                                  ? 'SAVING ORDER...'
                                  : 'PLACE ORDER',
                              style: GoogleFonts.raleway(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: AppColors.onPrimary,
                                letterSpacing: 13 * 0.2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Icon(
                              Icons.arrow_forward,
                              size: 18,
                              color: AppColors.onPrimary,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'ORDERED PRODUCTS WILL BE SAVED IN MY ORDERS',
                      style: GoogleFonts.raleway(
                        fontSize: 9,
                        color: AppColors.onSurfaceVariant.withValues(
                          alpha: 0.4,
                        ),
                        letterSpacing: 9 * 0.1,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> _placeOrder(BuildContext context) async {
    final cart = context.read<CartProvider>();
    final ordersProvider = context.read<OrdersProvider>();
    final messenger = ScaffoldMessenger.of(context);
    final router = GoRouter.of(context);

    if (cart.items.isEmpty) return;

    setState(() => _isPlacingOrder = true);
    try {
      await ordersProvider.placeOrder(
        items: cart.items,
        total: cart.subtotal,
        deliveryAddress: _deliveryAddress,
        customerName: _nameCtrl.text.trim(),
        phoneNumber: _phoneCtrl.text.trim(),
        shippingAddress: _addressCtrl.text.trim(),
        city: _cityCtrl.text.trim(),
        postalCode: _postalCtrl.text.trim(),
      );
      cart.clearCart();

      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Order saved successfully',
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
      router.go('/main?tab=3');
    } catch (_) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Could not save order. Please try again.',
            style: GoogleFonts.raleway(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w600,
            ),
          ),
          backgroundColor: const Color(0xFF8A2C2C),
          duration: const Duration(seconds: 3),
          behavior: SnackBarBehavior.floating,
        ),
      );
    } finally {
      if (mounted) {
        setState(() => _isPlacingOrder = false);
      }
    }
  }

  String get _deliveryAddress {
    final parts = [
      _nameCtrl.text.trim(),
      _phoneCtrl.text.trim(),
      _addressCtrl.text.trim(),
      _cityCtrl.text.trim(),
      _postalCtrl.text.trim(),
    ].where((part) => part.isNotEmpty).toList();

    if (parts.isEmpty) return 'Delivery details not provided';
    return parts.join(', ');
  }
}

class _ResponsivePair extends StatelessWidget {
  final Widget left;
  final Widget right;

  const _ResponsivePair({required this.left, required this.right});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 520) {
          return Column(children: [left, const SizedBox(height: 20), right]);
        }

        return Row(
          children: [
            Expanded(child: left),
            const SizedBox(width: 16),
            Expanded(child: right),
          ],
        );
      },
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;

  const _FormField({
    required this.label,
    required this.hint,
    required this.controller,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 8),
          child: Text(
            label.toUpperCase(),
            style: GoogleFonts.raleway(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.primary.withValues(alpha: 0.7),
              letterSpacing: 10 * 0.2,
            ),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style: GoogleFonts.raleway(fontSize: 14, color: AppColors.onSurface),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.raleway(
              fontSize: 14,
              color: AppColors.onSurface.withValues(alpha: 0.2),
            ),
            filled: true,
            fillColor: AppColors.surfaceContainerLow,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: AppColors.primary.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _CheckoutItem extends StatelessWidget {
  final CartItemModel item;

  const _CheckoutItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.05),
        ),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: SizedBox(
              width: 64,
              height: 80,
              child: Image.network(
                item.product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    Container(color: AppColors.surfaceContainerHigh),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.product.name.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.raleway(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                    letterSpacing: 0.2,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SIZE: ${item.selectedSize}  QTY: ${item.quantity}',
                  style: GoogleFonts.raleway(
                    fontSize: 9,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.6),
                    letterSpacing: 9 * 0.15,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '\$${item.totalPrice.toStringAsFixed(2)}',
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

class _TotalRow extends StatelessWidget {
  final String label;
  final String value;
  final bool highlight;

  const _TotalRow({
    required this.label,
    required this.value,
    this.highlight = false,
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
            color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
            letterSpacing: 10 * 0.1,
          ),
        ),
        Text(
          value.toUpperCase(),
          style: GoogleFonts.raleway(
            fontSize: highlight ? 11 : 13,
            fontWeight: FontWeight.w600,
            color: highlight ? AppColors.primary : AppColors.onSurface,
            letterSpacing: highlight ? 11 * 0.12 : 0,
          ),
        ),
      ],
    );
  }
}

class _EmptyCheckout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
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
              'Add products before placing an order.',
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 13,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.55),
              ),
            ),
            const SizedBox(height: 22),
            GestureDetector(
              onTap: () => context.go('/main?tab=1'),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 26,
                  vertical: 14,
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
                  'SHOP PRODUCTS',
                  style: GoogleFonts.raleway(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: AppColors.onPrimary,
                    letterSpacing: 11 * 0.14,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
