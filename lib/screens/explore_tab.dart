import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ExploreTab extends StatelessWidget {
  const ExploreTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return SafeArea(
      top: true,
      bottom: false,
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 520),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Glavni tekstovi
                Text(
                  "You dont have any active trips yet..",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: on.withValues(alpha: .70),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Would you like to start one?",
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 24),

                // Dugme
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => context.push('/trips/create'),
                    child: const Text("Create a trip"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
