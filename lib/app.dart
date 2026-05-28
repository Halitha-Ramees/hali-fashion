import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';
import 'providers/cart_provider.dart';
import 'providers/orders_provider.dart';
import 'providers/products_provider.dart';
import 'providers/user_provider.dart';

class KaliFashionApp extends StatefulWidget {
  const KaliFashionApp({super.key});

  @override
  State<KaliFashionApp> createState() => _KaliFashionAppState();
}

class _KaliFashionAppState extends State<KaliFashionApp> {
  late final UserProvider _userProvider;
  late final AppRouter _appRouter;

  @override
  void initState() {
    super.initState();
    _userProvider = UserProvider();
    _appRouter = AppRouter(_userProvider);
  }

  @override
  void dispose() {
    _appRouter.dispose();
    _userProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
        ChangeNotifierProvider(create: (_) => OrdersProvider(_userProvider)),
        ChangeNotifierProvider.value(value: _userProvider),
      ],
      child: MaterialApp.router(
        title: 'Kali Fashion',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        routerConfig: _appRouter.router,
      ),
    );
  }
}
