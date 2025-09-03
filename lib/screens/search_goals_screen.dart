import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SearchGoalsScreen extends StatefulWidget {
  const SearchGoalsScreen({super.key});

  @override
  State<SearchGoalsScreen> createState() => _SearchGoalsScreenState();
}

class _SearchGoalsScreenState extends State<SearchGoalsScreen> {
  /// Primarni filteri (prikazani kao plave pilule u 2 kolone)
  static const List<String> topFilters = [
    'Restaurants',
    'Attractions',
    'Cafes',
    'Entertainment',
  ];

  /// Svi filteri u modalu “See All”
  static const List<String> allFilters = [
    'Restaurants',
    'Attractions',
    'Cafes',
    'Entertainment',
    'Photo spots',
    'Cheap eats',
    'Breakfast and brunch',
    'Bakeries',
    'Breweries and beer',
    'Parks',
    'Shopping',
    'Viewpoints',
  ];

  /// Mock rezultati
  static const List<_Place> results = [
    _Place('Schachtelwirt', 'Restaurant', 'Vienna, Austria'),
    _Place('Sisi Museum', 'Museum', 'Vienna, Austria'),
    _Place('Cafe Central', 'Cafe', 'Vienna, Austria'),
    _Place('Prater Park', 'Attraction', 'Vienna, Austria'),
  ];

  /// 👉 MULTI-SELECT: čuvamo *nazive* aktivnih filtera (radi i za top i za “See All”)
  final Set<String> _selectedFilters = <String>{};

  Color _activePillColor(BuildContext ctx) =>
      Theme.of(ctx).brightness == Brightness.dark
          ? const Color(0xFF3A57CC)
          : const Color(0xFF5E8CFF);

  void _toggleFilter(String label) {
    setState(() {
      if (_selectedFilters.contains(label)) {
        _selectedFilters.remove(label);
      } else {
        _selectedFilters.add(label);
      }
    });
    // TODO: ovdje filtriraj rezultate prema _selectedFilters
  }

  void _openFiltersModal() {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final active = _activePillColor(context);
    const basePill = Color(0xFF2F6BFF);

    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      backgroundColor: theme.cardColor,
      constraints: const BoxConstraints(maxHeight: 520),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModal) {
            void toggle(String label) {
              // osvježi i modal i parent
              setModal(() {
                if (_selectedFilters.contains(label)) {
                  _selectedFilters.remove(label);
                } else {
                  _selectedFilters.add(label);
                }
              });
              setState(() {}); // reflektiraj i na glavnom ekranu
            }

            return SafeArea(
              top: false,
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
                itemCount: allFilters.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: onSurface.withValues(alpha: .08)),
                itemBuilder: (_, i) {
                  final label = allFilters[i];
                  final selected = _selectedFilters.contains(label);
                  final bg = selected ? active : theme.cardColor;
                  final txt = selected ? Colors.white : onSurface;

                  return InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => toggle(label),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 140),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: selected && theme.brightness == Brightness.light
                            ? const [
                                BoxShadow(
                                  color: Color(0x332F6BFF),
                                  blurRadius: 14,
                                  offset: Offset(0, 8),
                                ),
                              ]
                            : null,
                        border: selected
                            ? Border.all(color: basePill.withOpacity(.0))
                            : Border.all(
                                color: onSurface.withValues(alpha: .06)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              label,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: txt,
                              ),
                            ),
                          ),
                          Icon(
                            selected
                                ? Icons.check_circle_rounded
                                : Icons.radio_button_unchecked,
                            color: selected ? Colors.white : onSurface.withValues(alpha: .45),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    final imageBg = theme.brightness == Brightness.dark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE6E9EE);

    const basePill = Color(0xFF2F6BFF);
    final activePill = _activePillColor(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Top bar
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
                child: Row(
                  children: [
                    _CircleIconButton(
                      icon: Icons.arrow_back_ios_new_rounded,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                    const Spacer(),
                    const Text(
                      'Search',
                      style:
                          TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () => Navigator.of(context).maybePop(),
                      child: const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            color: Color(0xFF1061FF),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),

            // Title
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 6, 16, 10),
                child: RichText(
                  text: TextSpan(
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    children: const [
                      TextSpan(text: 'Chose '),
                      TextSpan(text: 'your goal '),
                      TextSpan(
                        text: 'destination',
                        style: TextStyle(color: Color(0xFFFF7A00)),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Search field
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SizedBox(
                  height: 46,
                  child: TextField(
                    textInputAction: TextInputAction.search,
                    decoration: InputDecoration(
                      hintText: 'Search Places',
                      prefixIcon: Icon(Icons.search,
                          color: onSurface.withValues(alpha: .6)),
                      suffixIcon: Icon(Icons.mic_none_rounded,
                          color: onSurface.withValues(alpha: .6)),
                    ),
                    onSubmitted: (q) {
                      // TODO: pretraga
                    },
                  ),
                ),
              ),
            ),

            // See All
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 10),
                child: Row(
                  children: [
                    const SizedBox.shrink(),
                    const Spacer(),
                    GestureDetector(
                      onTap: _openFiltersModal,
                      child: Text(
                        'See All',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: const Color(0xFF1061FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // FILTER PILL GRID — 2 u redu, MULTI-SELECT
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: GridView.builder(
                  itemCount: topFilters.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 14,
                    mainAxisExtent: 42,
                  ),
                  itemBuilder: (context, i) {
                    final label = topFilters[i];
                    final selected = _selectedFilters.contains(label);
                    final bgColor = selected ? activePill : basePill;

                    return InkWell(
                      borderRadius: BorderRadius.circular(14),
                      onTap: () => _toggleFilter(label),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 160),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: theme.brightness == Brightness.dark
                              ? null
                              : const [
                                  BoxShadow(
                                    color: Color(0x332F6BFF),
                                    blurRadius: 16,
                                    offset: Offset(0, 8),
                                  ),
                                ],
                        ),
                        child: Text(
                          label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // "Search for a destination"
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 10),
                child: Text(
                  'Search for a destination',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w700),
                ),
              ),
            ),

            // Grid rezultata (2 kolone)
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (context, i) {
                    final p = results[i];
                    return _ResultCard(place: p);
                  },
                  childCount: results.length,
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 14,
                  mainAxisExtent: 220,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final _Place place;
  const _ResultCard({required this.place});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final imageBg = theme.brightness == Brightness.dark
        ? const Color(0xFF2A2F3A)
        : const Color(0xFFE6E9EE);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => context.push('/place/details'),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(18),
          boxShadow: theme.brightness == Brightness.dark
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x143C4B64),
                    blurRadius: 14,
                    offset: Offset(0, 8),
                  ),
                ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
              child: Container(
                height: 120,
                width: double.infinity,
                color: imageBg,
                alignment: Alignment.center,
                child: Icon(Icons.image_outlined,
                    size: 36, color: onSurface.withValues(alpha: .45)),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                place.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Row(
                children: [
                  Icon(Icons.location_on_outlined,
                      size: 14, color: onSurface.withValues(alpha: .6)),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      place.city,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: onSurface.withValues(alpha: .6),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                place.kind,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: onSurface.withValues(alpha: .55),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Place {
  final String title;
  final String kind;
  final String city;
  const _Place(this.title, this.kind, this.city);
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
