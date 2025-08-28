import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'package:flutter/services.dart';

// Auth
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';

// Tabs
import 'screens/home_tab.dart';
import 'screens/trips_tab.dart';
import 'screens/explore_tab.dart';
import 'screens/groups_tab.dart';
import 'screens/profile_tab.dart';

import 'widgets/tg_nav_bar.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent, // providan nav bar
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark, // ikone tamne
      statusBarColor: Colors.transparent, // već koristimo SafeArea
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const TravelGenieApp());
}

class TravelGenieApp extends StatelessWidget {
  const TravelGenieApp({super.key});

  static const _routes = ['/home', '/trips', '/explore', '/groups', '/profile'];

  int _indexFromLocation(String loc) {
    final i = _routes.indexWhere((r) => loc.startsWith(r));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      // za prototip testiraj sa /home; za realni flow koristi /signin
      // initialLocation: '/home',
      initialLocation: '/home',

      routes: [
        // AUTH rute van Shell-a
        GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),

        // SHELL sa zajedničkim navbarom
        ShellRoute(
          builder: (context, state, child) {
            final idx = _indexFromLocation(state.matchedLocation);
            return Scaffold(
              backgroundColor: const Color(0xFFF7F8FA),
              body: SafeArea(
                top: true,
                bottom: false, // bottom već štiti TGNavBar
                child: child,
              ),
              bottomNavigationBar: TGNavBar(
                currentIndex: idx,
                onItemSelected: (i) => context.go(_routes[i]),
              ),
            );
          },
          routes: [
            GoRoute(
              path: '/home',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const HomeTab(),
              ),
            ),
            GoRoute(
              path: '/trips',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const TripsTab(),
              ),
            ),
            GoRoute(
              path: '/explore',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const ExploreTab(),
              ),
            ),
            GoRoute(
              path: '/groups',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const GroupsTab(),
              ),
            ),
            GoRoute(
              path: '/profile',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const ProfileTab(),
              ),
            ),
          ],
        ),
      ],
    );

    return MaterialApp.router(
      title: 'TravelGenie',
      theme: tgTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

CustomTransitionPage _transitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 220),
    transitionsBuilder: (context, animation, secondary, child) {
      final slide =
          Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
      return FadeTransition(
        opacity: animation,
        child: SlideTransition(position: animation.drive(slide), child: child),
      );
    },
  );
}
