import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelgenie/models/place_details_args.dart';

import '../widgets/user_avatar.dart';
import '../models/trip_overview_args.dart';
import '../models/stay_search_args.dart';

class TripOverviewScreen extends StatelessWidget {
  const TripOverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    // ⬇️ PROČITAJ ARGUMENTE (ako je došao StaySelection iz details screena)
    final args = GoRouterState.of(context).extra as TripOverviewArgs?;
    final selected = args?.selectedStay;

    // ⬇️ Izvedene vrijednosti za karticu "My Stay"
    final stayTitle = selected?.title ?? 'Hotel Indigo Vienna';
    final staySubtitle = selected != null
        ? '${selected.city}, ${selected.country}'
        : 'Vienna, Austria';

    // helper da otvorimo Stay Search s presetom
    void openStaySearch() {
      context.push(
        '/search/stay',
        extra: StaySearchArgs(
          location: selected != null
              ? '${selected.city}, ${selected.country}'
              : 'Vienna, Austria',
          range: null, // TODO: proslijedi stvarne datume kada ih budeš imao
          people: 2,   // TODO: proslijedi stvaran broj ljudi iz tripa
        ),
      );
    }

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _TopBar()),
        // Title
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 4, 20, 16),
            child: _HeroTitle(),
          ),
        ),
        // Month capsule (simplified calendar)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _MonthCapsule(),
          ),
        ),

        // Trip Group
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 8),
            child: Row(
              children: [
                Text(
                  'Trip Group',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push('/invite'),
                  child: Text(
                    'Invite people',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _AvatarRow(),
          ),
        ),

        // My Stay
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Row(
              children: [
                Text(
                  'My Stay',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: openStaySearch,
                  child: Text(
                    'Change',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _InfoCard(
              dateRange: '17–21 February 2025',
              title: stayTitle,
              subtitle: staySubtitle,
              onTap: () {
                context.push(
                  '/place/details',
                  extra: PlaceDetailsArgs(
                    title: stayTitle,
                    kind: 'Hotel',           // ili izvedi iz state-a ako ga imaš
                    city: staySubtitle,
                    price: 599,              // mock dok ne dođe API
                    unitLabel: 'Night',
                    rating: 4.7,
                    reviews: 2498,
                    selectable: false,       // 👈 BOOK varijanta
                  ),
                );
              },
            ),
          ),
        ),

        // My Goals (dynamic)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
            child: Row(
              children: [
                Text(
                  'My Goals',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: onSurface,
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: () => context.push('/trips/goals'), // 👈 vodi na Goals screen
                  child: Text(
                    "Edit",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1061FF),
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                for (int i = 0; i < _mockGoals.length; i++) ...[
                  _InfoCard(
                    dateRange: _mockGoals[i].dateRange,
                    title: _mockGoals[i].title,
                    subtitle: _mockGoals[i].subtitle,
                    onTap: () => _onGoalTap(_mockGoals[i]),
                  ),
                  if (i != _mockGoals.length - 1)
                    const SizedBox(height: 12),
                ],
              ],
            ),
          ),
        ),

        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

// ───────────────────────────────── Top bar ─────────────────────────────────

class _TopBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _ChipIcon(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          Text(
            'Overview',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => context.push('/invite'),
            child: Text(
              'Invite people',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChipIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ChipIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: chip, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}

// ─────────────────────────────── Title / Hero ──────────────────────────────

class _HeroTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleLarge?.copyWith(
      fontSize: 22,
      fontWeight: FontWeight.w800,
    );

    return RichText(
      text: TextSpan(
        style: base?.copyWith(color: theme.colorScheme.onSurface),
        children: [
          const TextSpan(text: 'Your trip '),
          TextSpan(
            text: 'overview',
            style: TextStyle(color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────── Month capsule (simplified) ────────────────────

class _MonthCapsule extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final chipBg = isDark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
            ? null
            : const [
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 14,
                  offset: Offset(0, 8),
                ),
              ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'February, 2025',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              Text(
                'Chose',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              _ChipIcon(icon: Icons.chevron_left_rounded, onTap: () {}),
              const SizedBox(width: 6),
              _ChipIcon(icon: Icons.chevron_right_rounded, onTap: () {}),
            ],
          ),
          const SizedBox(height: 12),

          Row(
            children: [
              _DayChip(label: 'S', selected: false, bg: chipBg),
              _DayChip(label: 'M', selected: false, bg: chipBg),
              _DayChip(label: 'T', selected: false, bg: chipBg),
              _DayChip(label: 'W', selected: false, bg: chipBg),
              _DayChip(label: 'T', selected: true,  bg: theme.colorScheme.primary),
              _DayChip(label: 'F', selected: false, bg: chipBg),
              _DayChip(label: 'S', selected: false, bg: chipBg),
            ],
          ),
          const SizedBox(height: 6),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(7, (i) {
              final n = [17, 18, 19, 20, 21, 22, 23][i];
              final sel = i == 4;
              return Expanded(
                child: Container(
                  height: 34,
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: sel
                        ? theme.colorScheme.primary
                        : (theme.brightness == Brightness.dark
                            ? const Color(0xFF1B1F27)
                            : Colors.transparent),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '$n',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: sel ? Colors.white : theme.colorScheme.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _DayChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color bg;
  const _DayChip({required this.label, required this.selected, required this.bg});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 34,
      height: 28,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: selected ? theme.colorScheme.primary : bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: theme.textTheme.labelLarge?.copyWith(
          color: selected ? Colors.white : theme.colorScheme.onSurface,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

// ───────────────────────────── Trip Group avatars ───────────────────────────

class _AvatarRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chip = theme.brightness == Brightness.dark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE6E9EE);

    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        children: [
          // ✅ Globalni avatari umjesto plain krugova
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: UserAvatar(
              isGroup: false,
              online: true,
              radius: 16,
              background: Color(0xFFFFE3AC), // topla žuta
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: UserAvatar(
              isGroup: false,
              online: false,
              radius: 16,
              background: Color(0xFFFFEAF1), // roza
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: UserAvatar(
              isGroup: false,
              online: true,
              radius: 16,
              background: Color(0xFFE6F0FF), // plava pastel
            ),
          ),
          const Spacer(),
          InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () => GoRouter.of(context).push('/invite'), // 👈 Invite
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: chip, shape: BoxShape.circle),
              child: Icon(Icons.add, size: 20, color: theme.colorScheme.onSurface),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────── Reusable info card ─────────────────────────

class _InfoCard extends StatelessWidget {
  final String dateRange;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _InfoCard({
    required this.dateRange,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    final shadow = const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 8),
      )
    ];

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? null : shadow,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // slika placeholder
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 84,
                height: 64,
                color: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE6E9EE),
                child: Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: onSurface.withOpacity(.45),
                ),
              ),
            ),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: onSurface.withOpacity(.55)),
                      const SizedBox(width: 6),
                      Text(
                        dateRange,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: onSurface.withOpacity(.55),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(Icons.location_on_outlined,
                          size: 16, color: onSurface.withOpacity(.6)),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: onSurface.withOpacity(.65),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: onSurface.withOpacity(.55)),
          ],
        ),
      ),
    );
  }
}

// ───────────────────────────── Goals model + data ───────────────────────────

class GoalItem {
  final String dateRange;
  final String title;
  final String subtitle;
  const GoalItem({
    required this.dateRange,
    required this.title,
    required this.subtitle,
  });
}

const _mockGoals = <GoalItem>[
  GoalItem(
    dateRange: '17 February 2025',
    title: 'Belvedere Museum Vienna',
    subtitle: 'Vienna, Austria',
  ),
  GoalItem(
    dateRange: '18 February 2025',
    title: 'Schönbrunn Palace',
    subtitle: 'Vienna, Austria',
  ),
  GoalItem(
    dateRange: '19 February 2025',
    title: "St. Stephen's Cathedral",
    subtitle: 'Vienna, Austria',
  ),
];

void _onGoalTap(GoalItem item) {
  // TODO: navigate to detail if/when needed
}
