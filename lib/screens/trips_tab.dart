import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TripsTab extends StatelessWidget {
  const TripsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TopBar()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              'My Trips',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 10),
            child: Text(
              'February 2025',
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.onSurface.withValues(alpha: .85),
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _TripCard(
              dateLabel: '17 February 2025',
              title: 'Vienna, Austria',
              statusLabel: 'Active trip',
              statusColor: const Color(0xFF22C55E), // zeleno kao na figmi
              onTap: () => context.push('/trips/overview'),
            ),
          ),
        ),

        // Prazan prostor da kartica ne “udara” u CTA
        const SliverToBoxAdapter(child: SizedBox(height: 16)),

        // Bottom CTA – prislonjen dnu ali poštuje nav bar preko SafeArea
        SliverFillRemaining(
          hasScrollBody: false,
          fillOverscroll: false,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: () {},
                  child: const Text('Create a trip'),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.scaffoldBackgroundColor, // isto kao na ostalim screenovima
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              // u tab kontekstu obično nema back – no-op
            },
          ),
          const Spacer(),
          Text(
            'Trips',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          const SizedBox(width: 36), // balans naslova u sredini
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
    final chip =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: chip,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}

class _TripCard extends StatelessWidget {
  final String dateLabel;
  final String title;
  final String statusLabel;
  final Color statusColor;
  final VoidCallback onTap;

  const _TripCard({
    required this.dateLabel,
    required this.title,
    required this.statusLabel,
    required this.statusColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    final lightShadow = const [
      BoxShadow(
        color: Color(0x14000000),
        blurRadius: 12,
        offset: Offset(0, 6),
      )
    ];

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: isDark ? null : lightShadow,
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                width: 78,
                height: 64,
                color: isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE6E9EE),
                child: Icon(
                  Icons.image_outlined,
                  size: 28,
                  color: onSurface.withValues(alpha: .45),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Srednji dio
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date row
                  Row(
                    children: [
                      Icon(Icons.calendar_today_rounded,
                          size: 14, color: onSurface.withValues(alpha: .55)),
                      const SizedBox(width: 6),
                      Text(
                        dateLabel,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: onSurface.withValues(alpha: .55),
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: onSurface,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Status chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: .12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.check_circle, size: 14, color: statusColor),
                        const SizedBox(width: 6),
                        Text(
                          statusLabel,
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: statusColor,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(width: 8),
            Icon(Icons.chevron_right, color: onSurface.withValues(alpha: .55)),
          ],
        ),
      ),
    );
  }
}
