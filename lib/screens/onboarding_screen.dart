import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  final List<_OnboardPage> _pages = const [
    _OnboardPage(
      image: Icons.location_city, // zamijeni assetima iz Figma-e
      title: "Explore with ease,\nanywhere you dream",
      subtitle:
          "Plan your perfect getaway with TravelGenie. From famous landmarks to hidden gems – your next adventure starts here.",
      button: "Get Started",
    ),
    _OnboardPage(
      image: Icons.landscape,
      title: "Smart plans,\nunforgettable journeys",
      subtitle:
          "Create personalized itineraries in minutes. We'll help you organize routes, days, and details – stress-free.",
      button: "Next",
    ),
    _OnboardPage(
      image: Icons.beach_access,
      title: "Travel your way, with\ntotal freedom",
      subtitle:
          "From booking to navigation, TravelGenie keeps everything in one place – so you can focus on the fun, not logistics.",
      button: "Next",
    ),
  ];

  void _next() {
    if (_page < _pages.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Gotov onboarding → login
      context.go('/signin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: () => context.go('/signin'),
                child: const Text("Skip"),
              ),
            ),

            // PageView
            Expanded(
              child: PageView.builder(
                controller: _controller,
                onPageChanged: (i) => setState(() => _page = i),
                itemCount: _pages.length,
                itemBuilder: (_, i) => _pages[i],
              ),
            ),

            // Indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (i) => Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _page == i ? 18 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: _page == i
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withValues(alpha: .3),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _next,
                  child: Text(
                    _page == 0 ? "Get Started" : (_page == _pages.length - 1 ? "Finish" : "Next"),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _OnboardPage extends StatelessWidget {
  final IconData image;
  final String title;
  final String subtitle;
  final String button;

  const _OnboardPage({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.button,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          Icon(image, size: 180, color: theme.colorScheme.primary), // zamijeni slikama
          const SizedBox(height: 60),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: .7),
            ),
          ),
        ],
      ),
    );
  }
}
