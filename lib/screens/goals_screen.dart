import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoalsScreen extends StatelessWidget {
  const GoalsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // TopBar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  const Text(
                    "Goals",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => Navigator.of(context).maybePop(),
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        'Done',
                        style: TextStyle(
                          color: Color(0xFF1061FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                children: const [
                  _DayGoals(
                    dayLabel: "Sunday 17 February",
                    goals: ["Belvedere Museum Vienna"],
                  ),
                  _DayGoals(
                    dayLabel: "Monday 18 February",
                    goals: ["Belvedere Museum Vienna"],
                  ),
                  _DayGoals(
                    dayLabel: "Tuesday 19 February",
                    goals: ["Belvedere Museum Vienna"],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayGoals extends StatelessWidget {
  final String dayLabel;
  final List<String> goals;
  const _DayGoals({required this.dayLabel, required this.goals});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final cardColor = theme.cardColor;

    return Padding(
      padding: const EdgeInsets.only(bottom: 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(dayLabel,
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),

          // Goals list
          for (final g in goals) ...[
            InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => context.push('/place/details'),
              child: Container(
                decoration: BoxDecoration(
                  color: cardColor,
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: theme.brightness == Brightness.light
                      ? const [
                          BoxShadow(
                            color: Color(0x143C4B64),
                            blurRadius: 14,
                            offset: Offset(0, 8),
                          ),
                        ]
                      : null,
                ),
                child: Row(
                  children: [
                    // Image placeholder
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        bottomLeft: Radius.circular(18),
                      ),
                      child: Container(
                        width: 92,
                        height: 76,
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFF2A2F3A)
                            : const Color(0xFFE6E9EE),
                        alignment: Alignment.center,
                        child: Icon(Icons.image_outlined,
                            size: 28, color: onSurface.withValues(alpha: .45)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            g,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "Vienna, Austria",
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withValues(alpha: .6),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    TextButton(
                      onPressed: () {},
                      child: const Text("Delete"),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],

          // Add new goal
          TextButton.icon(
            onPressed: () => context.push('/trips/search-goals'),
            icon: const Icon(Icons.add_circle_outline, color: Color(0xFF1061FF)),
            label: const Text(
              "Add new goal",
              style: TextStyle(
                color: Color(0xFF1061FF),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
