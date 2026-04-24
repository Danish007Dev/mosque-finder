import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/home/presentation/pages/home_page.dart';
import '../../features/mosque_detail/presentation/pages/mosque_detail_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';
import '../theme/app_colors.dart';
import 'route_names.dart';

/// Provider for GoRouter instance
final goRouterProvider = Provider<GoRouter>((ref) {
  return AppRouter.createRouter();
});

/// Application router configuration using GoRouter
class AppRouter {
  AppRouter._();

  static final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');

  static GoRouter createRouter() {
    return GoRouter(
      navigatorKey: _rootNavigatorKey,
      initialLocation: RouteNames.homePath,
      debugLogDiagnostics: true,

      // Error page
      errorBuilder: (context, state) => _ErrorPage(error: state.error),

      // Routes
      routes: [
        // Home shell with bottom navigation
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return _HomeShell(navigationShell: navigationShell);
          },
          branches: [
            // Home tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.homePath,
                  name: RouteNames.home,
                  builder: (context, state) => const HomePage(),
                ),
              ],
            ),
            // Map tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.mapViewPath,
                  name: RouteNames.mapView,
                  builder: (context, state) => const HomePage(
                    initialTabIndex: 1,
                  ),
                ),
              ],
            ),
            // Favorites tab
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: RouteNames.favoritesPath,
                  name: RouteNames.favorites,
                  builder: (context, state) => const FavoritesPage(),
                ),
              ],
            ),
          ],
        ),

        // Settings - full screen route (no bottom nav)
        GoRoute(
          path: RouteNames.settingsPath,
          name: RouteNames.settings,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) => const SettingsPage(),
        ),

        // Mosque Detail - full screen route
        GoRoute(
          path: RouteNames.mosqueDetailPath,
          name: RouteNames.mosqueDetail,
          parentNavigatorKey: _rootNavigatorKey,
          builder: (context, state) {
            final mosqueId = state.pathParameters['id'] ?? '';
            return MosqueDetailPage(mosqueId: mosqueId);
          },
        ),
      ],
    );
  }
}

/// Shell widget with bottom navigation bar
class _HomeShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const _HomeShell({required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.mosque_outlined),
            selectedIcon: Icon(Icons.mosque),
            label: 'Mosques',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Map',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favorites',
          ),
        ],
      ),
    );
  }
}

/// Error page widget
class _ErrorPage extends StatelessWidget {
  final Object? error;

  const _ErrorPage({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 80,
                color: AppColors.error.withValues(alpha: 0.7),
              ),
              const SizedBox(height: 16),
              Text(
                'Oops!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'The page you are looking for does not exist.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.grey600,
                    ),
              ),
              const SizedBox(height: 32),
              FilledButton.icon(
                onPressed: () => context.go(RouteNames.homePath),
                icon: const Icon(Icons.home),
                label: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
