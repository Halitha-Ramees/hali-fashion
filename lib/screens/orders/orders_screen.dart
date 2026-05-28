import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_colors.dart';
import '../../models/cart_item_model.dart';
import '../../models/order_model.dart';
import '../../providers/orders_provider.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  int _selectedTab = 0;
  static const _tabs = ['All', 'Processing', 'Delivered', 'Cancelled'];

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<OrdersProvider>().orders;
    final filteredOrders = _filterOrders(orders);

    return Scaffold(
      backgroundColor: AppColors.surfaceContainerLowest,
      body: CustomScrollView(
        slivers: [
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
                          Icon(
                            Icons.receipt_long_outlined,
                            color: AppColors.primary,
                            size: 24,
                          ),
                          const SizedBox(width: 16),
                          Text(
                            'MY ORDERS',
                            style: GoogleFonts.raleway(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                              letterSpacing: 16 * 0.18,
                            ),
                          ),
                        ],
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
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 24, 24, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ordered Pieces',
                    style: GoogleFonts.raleway(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    orders.isEmpty
                        ? 'Products you checkout will appear here.'
                        : '${orders.length} ORDERS SAVED',
                    style: GoogleFonts.raleway(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                      letterSpacing: 12 * 0.08,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizedBox(
              height: 46,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: _tabs.length,
                separatorBuilder: (_, _) => const SizedBox(width: 10),
                itemBuilder: (_, index) {
                  final active = _selectedTab == index;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedTab = index),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 160),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: active
                            ? AppColors.primary
                            : AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(999),
                      ),
                      child: Text(
                        _tabs[index].toUpperCase(),
                        style: GoogleFonts.raleway(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: active
                              ? AppColors.onPrimary
                              : AppColors.onSurfaceVariant,
                          letterSpacing: 10 * 0.08,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          if (filteredOrders.isEmpty)
            SliverFillRemaining(
              hasScrollBody: false,
              child: _EmptyOrders(
                title: orders.isEmpty
                    ? 'No orders yet'
                    : 'No ${_tabs[_selectedTab]} orders',
                subtitle: orders.isEmpty
                    ? 'Add products to cart and place an order.'
                    : 'Try another order filter.',
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 96),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (_, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _OrderCard(order: filteredOrders[index]),
                  ),
                  childCount: filteredOrders.length,
                ),
              ),
            ),
        ],
      ),
    );
  }

  List<OrderModel> _filterOrders(List<OrderModel> orders) {
    if (_selectedTab == 0) return orders;
    final status = _tabs[_selectedTab];
    return orders.where((order) => order.status == status).toList();
  }
}

class _OrderCard extends StatelessWidget {
  final OrderModel order;

  const _OrderCard({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.08),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    order.id,
                    style: GoogleFonts.raleway(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(order.createdAt),
                    style: GoogleFonts.raleway(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              _StatusBadge(status: order.status),
            ],
          ),
          const SizedBox(height: 18),
          ...order.items.map(
            (item) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _OrderedItem(item: item),
            ),
          ),
          const SizedBox(height: 4),
          Divider(color: AppColors.outlineVariant.withValues(alpha: 0.16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${_orderItemCount(order)} ITEMS',
                style: GoogleFonts.raleway(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 10 * 0.12,
                ),
              ),
              Text(
                '\$${order.total.toStringAsFixed(2)}',
                style: GoogleFonts.raleway(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.primary,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          if (order.deliveryAddress.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              order.deliveryAddress,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.raleway(
                fontSize: 11,
                color: AppColors.onSurfaceVariant.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ],
        ],
      ),
    );
  }

  int _orderItemCount(OrderModel order) {
    return order.items.fold(0, (sum, item) => sum + item.quantity);
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[date.month - 1];
    return '$month ${date.day}, ${date.year}';
  }
}

class _OrderedItem extends StatelessWidget {
  final CartItemModel item;

  const _OrderedItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: SizedBox(
            width: 58,
            height: 76,
            child: Image.network(
              item.product.imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) =>
                  Container(color: AppColors.surfaceContainerHigh),
            ),
          ),
        ),
        const SizedBox(width: 14),
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
                  height: 1.25,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                'SIZE: ${item.selectedSize}  QTY: ${item.quantity}',
                style: GoogleFonts.raleway(
                  fontSize: 10,
                  color: AppColors.onSurfaceVariant,
                  letterSpacing: 10 * 0.08,
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
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isProcessing = status == 'Processing';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isProcessing
            ? AppColors.primary.withValues(alpha: 0.16)
            : AppColors.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        status.toUpperCase(),
        style: GoogleFonts.raleway(
          fontSize: 9,
          fontWeight: FontWeight.w800,
          color: isProcessing ? AppColors.primary : AppColors.onSurfaceVariant,
          letterSpacing: 9 * 0.12,
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  final String title;
  final String subtitle;

  const _EmptyOrders({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 56,
              color: AppColors.outlineVariant,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              textAlign: TextAlign.center,
              style: GoogleFonts.raleway(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
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
