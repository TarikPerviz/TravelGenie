import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelgenie/models/place_details_args.dart';
import 'package:travelgenie/models/stay_search_args.dart';
import 'package:travelgenie/models/explore_focus_args.dart';
import 'package:travelgenie/screens/add_friend_screen.dart';
import 'package:travelgenie/screens/chat_screen.dart';
import 'package:travelgenie/screens/goals_screen.dart';
import 'package:travelgenie/screens/invite_screen.dart';
import 'package:travelgenie/screens/notifications_screen.dart';
import 'package:travelgenie/screens/place_detail_screen.dart';
import 'package:travelgenie/screens/search_goals_screen.dart';
import 'package:travelgenie/screens/stay_search_screen.dart';
import 'package:travelgenie/screens/trip_create_screen.dart';
import 'package:travelgenie/screens/trip_overview_screen.dart';
import 'theme.dart';
import 'package:flutter/services.dart';
import 'theme_controller.dart';

// Auth
import 'screens/signin_screen.dart';
import 'screens/signup_screen.dart';

// Tabs
import 'screens/home_tab.dart';
import 'screens/trips_tab.dart';
import 'screens/explore_tab.dart';
import 'screens/groups_tab.dart';
import 'screens/profile_tab.dart';
import 'screens/edit_profile_screen.dart';
import 'screens/account_screen.dart';
import 'screens/settings_screen.dart';

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

class TravelGenieApp extends StatefulWidget {
  const TravelGenieApp({super.key});

  @override
  State<TravelGenieApp> createState() => _TravelGenieAppState();
}

class _TravelGenieAppState extends State<TravelGenieApp> {
  final themeController = ThemeController(); // naš kontroler za theme

  static const _routes = ['/home', '/trips', '/explore', '/groups', '/profile'];

  int _indexFromLocation(String loc) {
    final i = _routes.indexWhere((r) => loc.startsWith(r));
    return i == -1 ? 0 : i;
  }

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(path: '/signin', builder: (_, __) => const SignInScreen()),
        GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
        ShellRoute(
          builder: (context, state, child) {
            final idx = _indexFromLocation(state.matchedLocation);
            return Scaffold(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              body: SafeArea(
                top: true,
                bottom: false,
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
              builder: (context, state) {
                final args = state.extra as ExploreFocusArgs?;
                return ExploreTab(focusedId: args?.goalId);
              },
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
            GoRoute(
              path: '/profile/edit',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const EditProfileScreen(),
              ),
            ),
            GoRoute(
              path: '/profile/account',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const AccountScreen(),
              ),
            ),
            GoRoute(
              path: '/profile/settings',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const SettingsScreen(),
              ),
            ),
            GoRoute(
              path: '/trips/overview',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const TripOverviewScreen(),
              ),
            ),
            GoRoute(
              path: '/place/details',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const PlaceDetailScreen(),
              ),
            ),
            GoRoute(
              path: '/trips/goals',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const GoalsScreen(),
              ),
            ),
            GoRoute(
              path: '/trips/search-goals',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const SearchGoalsScreen(),
              ),
            ),
            GoRoute(
              path: '/notifications',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const NotificationsScreen(),
              ),
            ),
            GoRoute(
              path: '/chat',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: ChatScreen(chatTitle: (state.extra as String?) ?? 'Group'),
              ),
            ),
            GoRoute(
              path: '/invite',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const InviteScreen(), // ili InviteScreen(title: 'Invite to Trip')
              ),
            ),
            GoRoute(
              path: '/groups/add-friend',
              pageBuilder: (context, state) => _transitionPage(
                key: state.pageKey,
                child: const AddFriendScreen(),
              ),
            ),
            GoRoute(
              path: '/trips/create',
              pageBuilder: (context, state) => MaterialPage(
                key: state.pageKey,
                child: const CreateTripScreen(), // 👈 koristi ime klase koje stvarno postoji
              ),
            ),
            GoRoute(
              path: '/search/stay',
              pageBuilder: (context, state) {
                final args = state.extra is StaySearchArgs ? state.extra as StaySearchArgs : null;
                return MaterialPage(
                  child: StaySearchScreen(preset: args), // ⬅️ prosleđujemo preset
                );
              },
            ),
            GoRoute(
              path: '/place/details',
              builder: (context, state) {
                final args = state.extra as PlaceDetailsArgs?;
                return PlaceDetailScreen(
                  title: args?.title ?? 'Hotel Indigo Vienna',
                  kind: args?.kind ?? 'Hotel',
                  city: args?.city ?? 'Vienna, Austria',
                  price: args?.price ?? 599,
                  unitLabel: args?.unitLabel ?? 'Night',
                  rating: args?.rating ?? 4.7,
                  reviews: args?.reviews ?? 2498,
                  selectable: args?.selectable ?? false,
                );
              },
            ),


          ],
        ),
      ],
    );

    return AppTheme( // InheritedNotifier iz theme_controller.dart
      controller: themeController,
      child: AnimatedBuilder(
        animation: themeController,
        builder: (context, _) {
          return MaterialApp.router(
            title: 'TravelGenie',
            theme: tgTheme(),
            darkTheme: tgDarkTheme(),
            themeMode: themeController.mode, // ⬅️ kontrolira light/dark
            routerConfig: router,
            debugShowCheckedModeBanner: false,
          );
        },
      ),
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
