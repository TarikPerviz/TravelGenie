import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../screens/signin_screen.dart';
// Import other screens here as you create them

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final goRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/signin',
  routes: [
    GoRoute(
      path: '/signin',
      name: 'signin',
      pageBuilder: (context, state) => MaterialPage(
        key: state.pageKey,
        child: const SignInScreen(),
      ),
    ),
    // Add more routes as you create more screens
    // Example:
    // GoRoute(
    //   path: '/home',
    //   name: 'home',
    //   pageBuilder: (context, state) => MaterialPage(
    //     key: state.pageKey,
    //     child: const HomeScreen(),
    //   ),
    // ),
  ],
);
