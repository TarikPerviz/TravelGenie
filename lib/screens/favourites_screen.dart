import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final isDark = theme.brightness == Brightness.dark;
    final chipBg = isDark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  _CircleIcon(
                    bg: chipBg,
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    'Favorite Places',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const Spacer(),
                  const SizedBox(width: 36),
                ],
              ),
            ),

            // Section title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 10),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Favourite Places',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ),

            // Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 230,
                ),
                itemCount: _mockFavs.length,
                itemBuilder: (_, i) => _FavCard(data: _mockFavs[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color bg;
  const _CircleIcon({required this.icon, required this.onTap, required this.bg});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface;
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: on),
      ),
    );
  }
}

class _FavCard extends StatelessWidget {
  final _Fav data;
  const _FavCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final imgBg = theme.brightness == Brightness.dark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE6E9EE);

    final shadow = theme.brightness == Brightness.dark
        ? null
        : const [
            BoxShadow(
              color: Color(0x143C4B64),
              blurRadius: 14,
              offset: Offset(0, 8),
            ),
          ];

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        // u prototipu otvori place details; u MVP-u proslijedi realne podatke
        context.push('/place/details'); 
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: shadow,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image + heart badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 112,
                    width: double.infinity,
                    color: imgBg,
                    alignment: Alignment.center,
                    child: Icon(Icons.image_outlined, size: 28, color: on.withOpacity(.45)),
                  ),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(theme.brightness == Brightness.dark ? .12 : .85),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.favorite, size: 16, color: Color(0xFFE53935)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on_outlined, size: 14, color: on.withOpacity(.6)),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '${data.city}, ${data.country}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: on.withOpacity(.65),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Fav {
  final String title;
  final String city;
  final String country;
  const _Fav({required this.title, required this.city, required this.country});
}

// MOCK podaci (zamijeni backendom u MVP-u)
const _mockFavs = <_Fav>[
  _Fav(title: 'Hotel Indigo Vienna', city: 'Vienna', country: 'Austria'),
  _Fav(title: 'Casa Las Tirtugas', city: 'Av Damero', country: 'Mexico'),
  _Fav(title: 'Aonang Villa Resort', city: 'Bastola', country: 'Islampur'),
  _Fav(title: 'Rangauti Resort', city: 'Sylhet', country: 'Airport Road'),
  _Fav(title: 'Kachura Resort', city: 'Vellima', country: 'Island'),
  _Fav(title: 'Shakardu Resort', city: 'Shakartu', country: 'Pakistan'),
];
