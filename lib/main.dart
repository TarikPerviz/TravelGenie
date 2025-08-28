import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'theme.dart';
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';

void main() => runApp(const TravelGenieApp());

class TravelGenieApp extends StatelessWidget {
  const TravelGenieApp({super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      // Za brzi prototip:
      // initialLocation: '/home',
      // Za realni flow s prijavom:
      initialLocation: '/signin',

      routes: [
        GoRoute(
          name: 'signin',
          path: '/signin',
          pageBuilder: (context, state) => _transitionPage(
            key: state.pageKey,
            child: const SignInScreen(),
          ),
        ),
        GoRoute(
          name: 'signup',
          path: '/signup',
          pageBuilder: (context, state) => _transitionPage(
            key: state.pageKey,
            child: const SignUpScreen(),
          ),
        ),
        GoRoute(
          name: 'home',
          path: '/home',
          pageBuilder: (context, state) => _transitionPage(
            key: state.pageKey,
            child: const HomeScreen(),
          ),
        ),
      ],

      // Ako ruta ne postoji — pošalji na signin.
      errorPageBuilder: (context, state) => _transitionPage(
        key: state.pageKey,
        child: const SignInScreen(),
      ),
    );

    return MaterialApp.router(
      title: 'TravelGenie',
      theme: tgTheme(),
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}

/// iOS-like fade+slide tranzicija koja radi i na Androidu bez dodatnih paketa.
CustomTransitionPage _transitionPage({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage(
    key: key,
    child: child,
    transitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetTween =
          Tween<Offset>(begin: const Offset(0.02, 0), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));

      return FadeTransition(
        opacity: animation,
        child: SlideTransition(
          position: animation.drive(offsetTween),
          child: child,
        ),
      );
    },
  );
}
