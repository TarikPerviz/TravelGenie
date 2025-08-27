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
      initialLocation: '/signin',
      routes: [
        GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        GoRoute(path: '/home',   builder: (_, __) => const HomeScreen()),
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
