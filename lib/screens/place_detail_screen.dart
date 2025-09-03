import 'package:flutter/material.dart';

class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({
    super.key,
    this.title = 'Hotel Indigo Vienna',
    this.kind = 'Hotel',               // 👈 hotel by default
    this.city = 'Vienna, Austria',
    this.price = 599,                  // USD
    this.unitLabel = 'Night',          // 👈 '/Night' for hotels; change to 'Person' for restaurants
    this.rating = 4.7,
    this.reviews = 2498,
  });

  final String title;
  final String kind;           // Hotel / Apartment / etc.
  final String city;
  final int price;             // USD
  final String unitLabel;      // 'Night' (hotel) | 'Person' (restaurant)
  final double rating;         // 0..5
  final int reviews;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;

    final heroBg = isDark ? const Color(0xFF2A2F3A) : const Color(0xFFE6E9EE);
    final chipBg = isDark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);
    final boxShadow = isDark
        ? null
        : const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 18,
              offset: Offset(0, -10),
            ),
          ];

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          // ===== Scroll (hero + sheet) ======================================
          CustomScrollView(
            slivers: [
              // Hero image placeholder
              SliverToBoxAdapter(
                child: Container(
                  height: 360,
                  width: double.infinity,
                  color: heroBg,
                  alignment: Alignment.center,
                  child: Icon(
                    Icons.image_outlined,
                    size: 72,
                    color: onSurface.withValues(alpha: .45),
                  ),
                ),
              ),

              // Sheet (rounded top) as part of scroll
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(26)),
                    boxShadow: boxShadow,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // grabber
                        Center(
                          child: Container(
                            width: 44,
                            height: 4,
                            decoration: BoxDecoration(
                              color: onSurface.withValues(alpha: .15),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Title + Show on map
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: theme.textTheme.titleLarge?.copyWith(
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    kind,
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: onSurface.withValues(alpha: .6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(Icons.place_outlined, size: 18),
                              label: const Text('Show on map'),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Meta row (location • rating • price)
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16,
                                color: onSurface.withValues(alpha: .6)),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                city,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: onSurface.withValues(alpha: .7),
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Icon(Icons.star_rounded,
                                size: 18, color: Color(0xFFFFC107)),
                            const SizedBox(width: 4),
                            Text(
                              '$rating',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '($reviews)',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: onSurface.withValues(alpha: .6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              '\$$price',
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            Text(
                              '/$unitLabel',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: onSurface.withValues(alpha: .6),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        // Mini gallery (placeholders)
                        SizedBox(
                          height: 56,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (_, __) =>
                                const SizedBox(width: 10),
                            itemBuilder: (_, i) => ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 56,
                                height: 56,
                                color: heroBg,
                                child: Icon(
                                  Icons.image_outlined,
                                  size: 20,
                                  color: onSurface.withValues(alpha: .45),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        // About Hotel
                        Text(
                          'About Hotel',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        RichText(
                          text: TextSpan(
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: onSurface.withValues(alpha: .85),
                            ),
                            children: [
                              const TextSpan(
                                text:
                                    'A modern hotel ideal for city breaks. Spacious rooms, great breakfast and family-friendly amenities. Close to public transport and main attractions… ',
                              ),
                              TextSpan(
                                text: 'Read More',
                                style: TextStyle(
                                  color: theme.colorScheme.primary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // CTA
                        SafeArea(
                          top: false,
                          minimum: const EdgeInsets.only(bottom: 8),
                          child: SizedBox(
                            width: double.infinity,
                            height: 54,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text('Book Now'), // 👈 hotel CTA
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 8)),
            ],
          ),

          // Floating back / heart over hero
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
              child: Row(
                children: [
                  _ChipIcon(
                    bg: chipBg,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => Navigator.of(context).maybePop(),
                  ),
                  const Spacer(),
                  _ChipIcon(
                    bg: chipBg,
                    icon: Icons.favorite_border_rounded,
                    onTap: () {},
                  ),
                ],
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
  final Color? bg;
  const _ChipIcon({required this.icon, required this.onTap, this.bg});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: bg ??
              (theme.brightness == Brightness.dark
                  ? const Color(0xFF1B1F27)
                  : const Color(0xFFF3F5F8)),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
