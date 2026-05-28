import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_colors.dart';
import '../../providers/cart_provider.dart';
import '../../providers/orders_provider.dart';
import '../home/home_screen.dart';
import '../shop/product_listing_screen.dart';
import '../cart/cart_screen.dart';
import '../orders/orders_screen.dart';
import '../profile/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  final int initialIndex;

  const MainScaffold({super.key, this.initialIndex = 0});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, 4).toInt();
    _screens = [
      HomeScreen(onShopTap: () => setState(() => _currentIndex = 1)),
      const ProductListingScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final cartCount = context.watch<CartProvider>().itemCount;
    final ordersCount = context.watch<OrdersProvider>().orderCount;

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(
            top: BorderSide(color: AppColors.outlineVariant, width: 0.5),
          ),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (i) => setState(() => _currentIndex = i),
          items: [
            const BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home),
              label: 'HOME',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.shopping_bag_outlined),
              activeIcon: Icon(Icons.shopping_bag),
              label: 'SHOP',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                backgroundColor: AppColors.primary,
                textColor: AppColors.onSurface,
                child: const Icon(Icons.shopping_cart_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                backgroundColor: AppColors.primary,
                textColor: AppColors.onSurface,
                child: const Icon(Icons.shopping_cart),
              ),
              label: 'CART',
            ),
            BottomNavigationBarItem(
              icon: Badge(
                isLabelVisible: ordersCount > 0,
                label: Text('$ordersCount'),
                backgroundColor: AppColors.primary,
                textColor: AppColors.onSurface,
                child: const Icon(Icons.receipt_long_outlined),
              ),
              activeIcon: Badge(
                isLabelVisible: ordersCount > 0,
                label: Text('$ordersCount'),
                backgroundColor: AppColors.primary,
                textColor: AppColors.onSurface,
                child: const Icon(Icons.receipt_long),
              ),
              label: 'ORDERS',
            ),
            const BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              activeIcon: Icon(Icons.person),
              label: 'PROFILE',
            ),
          ],
        ),
      ),
    );
  }
}
