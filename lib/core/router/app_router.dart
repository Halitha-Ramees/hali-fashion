import 'package:go_router/go_router.dart';
import '../../screens/splash/splash_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/register_screen.dart';
import '../../screens/main_scaffold/main_scaffold.dart';
import '../../screens/product/product_detail_screen.dart';
import '../../screens/checkout/checkout_screen.dart';
import '../../models/product_model.dart';
import '../../providers/user_provider.dart';

class AppRouter {
  AppRouter(UserProvider userProvider)
    : router = GoRouter(
        initialLocation: splash,
        refreshListenable: userProvider,
        redirect: (context, state) {
          final path = state.uri.path;
          final isLoggedIn = userProvider.isLoggedIn;
          final isAuthRoute = path == login || path == register;
          final isProtectedRoute = path == main || path == checkout;

          if (!isLoggedIn && isProtectedRoute) {
            return login;
          }

          if (isLoggedIn && isAuthRoute) {
            return main;
          }

          return null;
        },
        routes: [
          GoRoute(
            path: splash,
            builder: (context, state) => const SplashScreen(),
          ),
          GoRoute(
            path: login,
            builder: (context, state) => const LoginScreen(),
          ),
          GoRoute(
            path: register,
            builder: (context, state) => const RegisterScreen(),
          ),
          GoRoute(
            path: main,
            builder: (context, state) {
              final tab =
                  int.tryParse(state.uri.queryParameters['tab'] ?? '') ?? 0;
              return MainScaffold(initialIndex: tab);
            },
          ),
          GoRoute(
            path: productDetail,
            builder: (context, state) {
              final product = state.extra as ProductModel;
              return ProductDetailScreen(product: product);
            },
          ),
          GoRoute(
            path: checkout,
            builder: (context, state) => const CheckoutScreen(),
          ),
        ],
      );

  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String main = '/main';
  static const String productDetail = '/product-detail';
  static const String checkout = '/checkout';

  final GoRouter router;

  void dispose() {
    router.dispose();
  }
}
