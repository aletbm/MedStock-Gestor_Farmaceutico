import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:medstock/domain/entities/product.dart';
import 'package:medstock/domain/entities/user.dart';
import 'package:medstock/presentations/providers/router_provider.dart';
import 'package:medstock/presentations/providers/session_provider.dart';
import 'package:medstock/presentations/screens/settings/about_screen.dart';
import 'package:medstock/presentations/screens/settings/apparence_screen.dart';
import 'package:medstock/presentations/screens/settings/export_screen.dart';
import 'package:medstock/presentations/screens/settings/inventory_screen.dart';
import 'package:medstock/presentations/screens/users/edit_profile.dart';
import 'package:medstock/presentations/screens/products/product_details.dart';
import 'package:medstock/presentations/screens/products/product_form_screen.dart';
import 'package:medstock/presentations/screens/products/product_list_screen.dart';
import 'package:medstock/presentations/screens/auth/login_screen.dart';
import 'package:medstock/presentations/screens/users/profile_screen.dart';
import 'package:medstock/presentations/screens/auth/register_screen.dart';
import 'package:medstock/presentations/screens/settings/settings_screen.dart';
import 'package:medstock/presentations/screens/splash_screen.dart';


final appRouterProvider = Provider((ref) {
  final notifier = ref.watch(routerNotifierProvider);

  return GoRouter(
    initialLocation: '/login',
    refreshListenable: notifier,
    redirect: (context, state) {
          final session = ref.read(sessionProvider);
          final splashDone = ref.read(splashDoneProvider);
          //print('REDIRECT → ${state.matchedLocation} | session: $session');
          if (session == null || !splashDone) return '/splash';

          final publicRoutes = ['/login', '/register'];

          if(session == true && publicRoutes.contains(state.matchedLocation)) return '/product-list';
          if(session == false && !publicRoutes.contains(state.matchedLocation)) return '/login';
          return null;
        },
    routes: [
      GoRoute(path: '/splash', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/login', builder: (context, state) => const LoginScreen()),
      GoRoute(path: '/register', builder: (context, state) => const RegisterScreen()),
      GoRoute(path: '/product-list', builder: (context, state) => const ProductListScreen()),
      GoRoute(path: '/product-form', builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return ProductFormScreen(
          mode: extra['mode'] as String,
          producto: extra['producto'] as Product?,
          );
        },
      ),
      GoRoute(path: '/product-details', builder: (context, state) {
        final producto = state.extra as Product;
        return ProductDetailsScreen(producto: producto);
        },
      ),
      GoRoute(path: '/profile', builder: (context, state) => const ProfileScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(path: '/edit-profile', builder: (context, state) => EditProfileScreen(userData: state.extra as User)),
      GoRoute(path: '/apparence', builder: (context, state) => const ApparenceScreen()),
      GoRoute(path: '/inventory', builder: (context, state) => const InventoryScreen()),
      GoRoute(path: '/export-data', builder: (context, state) => const ExportScreen()),
      GoRoute(path: '/about', builder: (context, state) => const AboutScreen())
      ],
    );
  }
);