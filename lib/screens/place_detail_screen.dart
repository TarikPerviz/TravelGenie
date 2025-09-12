import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/stay_selection.dart';
import '../models/place_details_args.dart';
import '../models/explore_focus_args.dart';
  
class PlaceDetailScreen extends StatelessWidget {
  const PlaceDetailScreen({
    super.key,
    this.title = 'Hotel Indigo Vienna',
    this.kind = 'Hotel',
    this.city = 'Vienna, Austria',
    this.price = 599,
    this.unitLabel = 'Night',
    this.rating = 4.7,
    this.reviews = 2498,
    this.selectable = false, // 👈 kada je true, prikazuje i "Select for Trip"
    this.mapGoalId,
  });

  final String title;
  final String kind;
  final String city;      // očekuje format "Grad, Država" (npr. "Vienna, Austria")
  final int price;
  final String unitLabel;
  final double rating;
  final int reviews;
  final bool selectable;
  final String? mapGoalId;        
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final onSurface = theme.colorScheme.onSurface;
    // ⬇️ OVDJE dodaj ovu liniju (prije nego koristiš args)
    final args = GoRouterState.of(context).extra as PlaceDetailsArgs?;
    // Ako su poslati args, prepiši lokalne vrijednosti (zadrži default ako null)
    final String _title      = args?.title      ?? title;
    final String _kind       = args?.kind       ?? kind;
    final String _city       = args?.city       ?? city;
    final int _price         = args?.price      ?? price;
    final String _unitLabel  = args?.unitLabel  ?? unitLabel;
    final double _rating     = args?.rating     ?? rating;
    final int _reviews       = args?.reviews    ?? reviews;
    final bool _selectable   = args?.selectable ?? selectable;
    // Colors
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

    // helper za razdvajanje "City, Country"
    StaySelection _toSelection() {
      final parts = city.split(',');
      final c = parts.isNotEmpty ? parts.first.trim() : city;
      final country = parts.length > 1 ? parts.last.trim() : '';
      return StaySelection(title: title, city: c, country: country);
    }

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // Hero
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

              // Sheet
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
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

                        // Title + map
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
                                      color: onSurface.withOpacity(.6),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            TextButton.icon(
                              onPressed: () {
                                // 1) Ako imamo tačan map pin id, koristi njega
                                String? id = mapGoalId;

                                // 2) Ako nije zadan, probaj vrlo jednostavan “fallback” po title-u
                                id ??= _guessMapIdByTitle(title);

                                // 3) Navigiraj na Explore i fokusiraj
                                context.push('/explore', extra: ExploreFocusArgs(id));
                              },
                              icon: const Icon(Icons.place_outlined, size: 18),
                              label: const Text('Show on map'),
                              style: TextButton.styleFrom(
                                foregroundColor: theme.colorScheme.primary,
                                padding: const EdgeInsets.symmetric(horizontal: 10),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),

                        // Meta (location • rating • price)
                        Row(
                          children: [
                            Icon(Icons.location_on_outlined,
                                size: 16, color: onSurface.withValues(alpha: .6)),
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

                        // mini gallery
                        SizedBox(
                          height: 56,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: 5,
                            separatorBuilder: (_, __) => const SizedBox(width: 10),
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

                        // About
                        Text(
                          'About $kind',
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
                                    'A modern place ideal for city breaks. Spacious rooms, great breakfast and family-friendly amenities. Close to public transport and main attractions… ',
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
                          child: _selectable
                              ? Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Booking flow (coming soon)'),
                                            ),
                                          );
                                        },
                                        child: const Text('Book now'),
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () => context.pop(_toSelection()),
                                        child: const Text('Select for Trip'),
                                      ),
                                    ),
                                  ],
                                )
                              : SizedBox(
                                  width: double.infinity,
                                  height: 54,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('Booking flow (coming soon)'),
                                        ),
                                      );
                                    },
                                    child: const Text('Book Now'),
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

          // Floating back / heart
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
String _guessMapIdByTitle(String title) {
  // jednostavna mapa za prototip; u MVP-u će doći iz backend-a
  const map = {
    'Hotel Indigo Vienna': 'indigo',
    'Belvedere Museum': 'belvedere',
    'Schönbrunn Palace': 'schoenbrunn',
    "St. Stephen's Cathedral": 'ststephen',
  };
  return map[title] ?? 'indigo'; // default fallback
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
