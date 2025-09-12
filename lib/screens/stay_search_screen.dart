import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelgenie/models/stay_search_args.dart';


class StaySearchScreen extends StatefulWidget {
  /// Legacy opcionalni parametri (zadržaćemo radi kompatibilnosti)
  final String? location;
  final DateTimeRange? dates;
  final int? people;

  /// NOVO: preset paket (ima prioritet nad pojedinačnim legacy poljima)
  final StaySearchArgs? preset;

  const StaySearchScreen({
    super.key,
    this.location,
    this.dates,
    this.people,
    this.preset,
  });

  @override
  State<StaySearchScreen> createState() => _StaySearchScreenState();
}

class _StaySearchScreenState extends State<StaySearchScreen> {
  final _search = TextEditingController();

  // ── Preset state (za prikaz i čišćenje chipova)
  DateTimeRange? _presetRange;
  int? _presetPeople;

  // ── Filter state
  RangeValues _price = const RangeValues(40, 900);
  final Set<String> _types = <String>{}; // multi-select
  bool _pool = false;
  bool _parking = false;
  bool _freeCancel = false;
  bool _petFriendly = false;

  @override
  void initState() {
    super.initState();

    // Ako postoji preset, on ima prioritet
    if (widget.preset != null) {
      final p = widget.preset!;
      _search.text = p.location;
      _presetRange = p.range;
      _presetPeople = p.people;
      return;
    }

    // U suprotnom, koristi legacy pojedinačne parametre
    if (widget.location != null && widget.location!.isNotEmpty) {
      _search.text = widget.location!;
    }
    _presetRange = widget.dates;
    _presetPeople = widget.people;
  }

  int get _activeFilterCount {
    int n = 0;
    // Price active if not full span
    if (_price.start > 0 || _price.end < 1000) n++;
    n += _types.isNotEmpty ? 1 : 0;
    n += [_pool, _parking, _freeCancel, _petFriendly].where((b) => b).length;
    return n;
  }

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  // ── Primijeni filtere na mock listu
  List<_Stay> get _filtered {
  // normalizacija: mala slova, zadrži slova/cifre/razmake, sve ostalo ukloni
  String normalize(String input) =>
      input.toLowerCase().replaceAll(RegExp(r'[^a-z0-9 ]'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();

  final query = normalize(_search.text);
  final tokens = query.isEmpty ? const <String>[] : query.split(' ');

  return _mockStays.where((s) {
    // haystack: spoj title/city/country pa normalizuj
    final hay = normalize('${s.title} ${s.city} ${s.country}');

    // svaki token mora postojati u haystack-u (AND pretraga)
    if (tokens.isNotEmpty && !tokens.every(hay.contains)) return false;

    // cijena
    if (s.pricePerPerson < _price.start || s.pricePerPerson > _price.end) return false;

    // tip smještaja
    if (_types.isNotEmpty && !_types.contains(s.type)) return false;

    // ameniteti
    if (_pool && !s.pool) return false;
    if (_parking && !s.parking) return false;
    if (_freeCancel && !s.freeCancel) return false;
    if (_petFriendly && !s.petFriendly) return false;

    return true;
  }).toList();
}



  void _openFilters() async {
  final theme = Theme.of(context);

  final result = await showModalBottomSheet<_FiltersResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: theme.colorScheme.surface,
    showDragHandle: true,
    builder: (ctx) {
      return DraggableScrollableSheet(
        expand: false,
        initialChildSize: 0.9, // zauzmi 90% visine
        minChildSize: 0.5,
        maxChildSize: 0.95,
        builder: (context, scrollController) {
          return _FiltersSheet(
            scrollController: scrollController,        // ⬅️ VAŽNO
            initialPrice: _price,
            initialTypes: _types,
            pool: _pool,
            parking: _parking,
            freeCancel: _freeCancel,
            petFriendly: _petFriendly,
          );
        },
      );
    },
  );

  if (result != null) {
    setState(() {
      _price = result.price;
      _types
        ..clear()
        ..addAll(result.types);
      _pool = result.pool;
      _parking = result.parking;
      _freeCancel = result.freeCancel;
      _petFriendly = result.petFriendly;
    });
  }
}


  void _clearDatesChip() => setState(() => _presetRange = null);
  void _clearPeopleChip() => setState(() => _presetPeople = null);

  String _fmt(DateTime d) => '${d.day}.${d.month}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final chipBg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

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
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () => context.pop(),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration:
                          BoxDecoration(color: chipBg, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: on),
                    ),
                  ),
                  const Spacer(),
                  Text('Search',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child: Text(
                      'Cancel',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Hero title
            Padding(
              padding: const EdgeInsets.only(top: 4, bottom: 10),
              child: _HeroTitle(),
            ),

            // Search field + Filters button
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: TextField(
                        controller: _search,
                        onChanged: (_) => setState(() {}),
                        textInputAction: TextInputAction.search,
                        decoration: InputDecoration(
                          hintText: 'Search Places',
                          prefixIcon:
                              Icon(Icons.search, color: on.withOpacity(.6)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: _openFilters,
                    child: Container(
                      height: 46,
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: chipBg,
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.tune_rounded, color: on),
                          if (_activeFilterCount > 0) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: theme.colorScheme.primary,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_activeFilterCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Preset chips (ako postoje)
            if (_presetRange != null || _presetPeople != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      if (_presetRange != null)
                        _SmallClosableChip(
                          icon: Icons.calendar_today_rounded,
                          label:
                              '${_fmt(_presetRange!.start)} – ${_fmt(_presetRange!.end)}',
                          onClose: _clearDatesChip,
                        ),
                      if (_presetPeople != null)
                        _SmallClosableChip(
                          icon: Icons.people_alt_rounded,
                          label: '${_presetPeople!} people',
                          onClose: _clearPeopleChip,
                        ),
                    ],
                  ),
                ),
              ),

            // Section title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Search for your stay',
                  style: theme.textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
            ),

            // Results Grid
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  mainAxisExtent: 236,
                ),
                itemCount: _filtered.length,
                itemBuilder: (_, i) => _StayCard(stay: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────  Preset chips  ───────────────────────── */

class _SmallClosableChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onClose;
  const _SmallClosableChip({
    required this.icon,
    required this.label,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    return Container(
      height: 34,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurface.withOpacity(.7)),
          const SizedBox(width: 6),
          Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onClose,
            child: const Icon(Icons.close_rounded, size: 16),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────  Filters bottom sheet  ───────────────────────── */

class _FiltersResult {
  final RangeValues price;
  final Set<String> types;
  final bool pool;
  final bool parking;
  final bool freeCancel;
  final bool petFriendly;
  const _FiltersResult({
    required this.price,
    required this.types,
    required this.pool,
    required this.parking,
    required this.freeCancel,
    required this.petFriendly,
  });
}

class _FiltersSheet extends StatefulWidget {
  // Opcionalno: ako koristiš DraggableScrollableSheet, možeš proslediti controller.
  final ScrollController? scrollController;

  final RangeValues initialPrice;
  final Set<String> initialTypes;
  final bool pool;
  final bool parking;
  final bool freeCancel;
  final bool petFriendly;

  const _FiltersSheet({
    super.key,
    this.scrollController,
    required this.initialPrice,
    required this.initialTypes,
    required this.pool,
    required this.parking,
    required this.freeCancel,
    required this.petFriendly,
  });

  @override
  State<_FiltersSheet> createState() => _FiltersSheetState();
}

class _FiltersSheetState extends State<_FiltersSheet> {
  late RangeValues _price = widget.initialPrice;
  late final Set<String> _types = {...widget.initialTypes};
  late bool _pool = widget.pool;
  late bool _parking = widget.parking;
  late bool _freeCancel = widget.freeCancel;
  late bool _petFriendly = widget.petFriendly;

  void _reset() {
    setState(() {
      _price = const RangeValues(40, 900);
      _types.clear();
      _pool = _parking = _freeCancel = _petFriendly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom; // tastatura

    return SafeArea(
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: Row(
              children: [
                Text(
                  'Filters',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const Spacer(),
                TextButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),
          ),

          // Scrollable sadržaj
          Expanded(
            child: ListView(
              controller: widget.scrollController,
              padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottomInset),
              children: [
                // Price
                Text(
                  'Price per person',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('\$${_price.start.round()}',
                        style: theme.textTheme.labelLarge),
                    Text('\$${_price.end.round()}',
                        style: theme.textTheme.labelLarge),
                  ],
                ),
                RangeSlider(
                  min: 0,
                  max: 1000,
                  divisions: 100,
                  values: _price,
                  labels: RangeLabels(
                    '\$${_price.start.round()}',
                    '\$${_price.end.round()}',
                  ),
                  onChanged: (v) => setState(() => _price = v),
                ),
                const SizedBox(height: 12),

                // Types (multi-select)
                Text(
                  'Type',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final t in const [
                      'Hotel',
                      'Apartments',
                      'Hostels',
                      'Vacation Homes',
                      'Villas',
                    ])
                      _ChoiceChip(
                        label: t,
                        selected: _types.contains(t),
                        onTap: () {
                          setState(() {
                            if (_types.contains(t)) {
                              _types.remove(t);
                            } else {
                              _types.add(t);
                            }
                          });
                        },
                      ),
                  ],
                ),
                const SizedBox(height: 16),

                // Amenities
                Text(
                  'Amenities',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                _AmenityRow(
                  label: 'With pool',
                  value: _pool,
                  onChanged: (v) => setState(() => _pool = v),
                ),
                _AmenityRow(
                  label: 'With free parking',
                  value: _parking,
                  onChanged: (v) => setState(() => _parking = v),
                ),
                _AmenityRow(
                  label: 'Free cancellation',
                  value: _freeCancel,
                  onChanged: (v) => setState(() => _freeCancel = v),
                ),
                _AmenityRow(
                  label: 'Pet friendly',
                  value: _petFriendly,
                  onChanged: (v) => setState(() => _petFriendly = v),
                ),
              ],
            ),
          ),

          // Apply
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(
                      _FiltersResult(
                        price: _price,
                        types: _types,
                        pool: _pool,
                        parking: _parking,
                        freeCancel: _freeCancel,
                        petFriendly: _petFriendly,
                      ),
                    );
                  },
                  child: const Text('Apply filters'),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _ChoiceChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final off = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);
    final bg = selected ? theme.colorScheme.primary : off;
    final fg = selected ? Colors.white : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
        ),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: fg,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _AmenityRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _AmenityRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface.withOpacity(.7);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: on,
              ),
            ),
          ),
          Switch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}


/* ─────────────────────────  Hero title  ───────────────────────── */

class _HeroTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.titleLarge?.copyWith(
      fontWeight: FontWeight.w800,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20), // razmak lijevo/desno
      child: RichText(
        textAlign: TextAlign.center, // centriraj tekst
        text: TextSpan(
          style: base?.copyWith(color: theme.colorScheme.onSurface),
          children: [
            const TextSpan(text: "Let's find your "),
            TextSpan(
              text: "perfect stay",
              style: TextStyle(color: theme.colorScheme.primary),
            ),
            const TextSpan(text: " for your next "),
            const TextSpan(
              text: "trip!",
              style: TextStyle(color: Color(0xFFFF7A00)),
            ),
          ],
        ),
      ),
    );
  }
}


/* ─────────────────────────  MOCK: card & data  ───────────────────────── */

class _StayCard extends StatelessWidget {
  final _Stay stay;
  const _StayCard({required this.stay});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final imageBg =
        theme.brightness == Brightness.dark ? const Color(0xFF2A2F3A) : const Color(0xFFE6E9EE);

    final lightShadow = const [
      BoxShadow(
        color: Color(0x143C4B64),
        blurRadius: 14,
        offset: Offset(0, 8),
      ),
    ];

    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () => context.push('/place/details'), // placeholder
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(16),
          boxShadow: theme.brightness == Brightness.light ? lightShadow : null,
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // image
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                height: 112,
                width: double.infinity,
                color: imageBg,
                child: Icon(Icons.image_outlined,
                    size: 32, color: on.withOpacity(.45)),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              stay.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${stay.city}, ${stay.country}',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodySmall?.copyWith(
                color: on.withOpacity(.65),
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: Color(0xFFFFC107), size: 18),
                const SizedBox(width: 4),
                Text('${stay.rating}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const Spacer(),
                Text('\$${stay.pricePerPerson.toStringAsFixed(0)}',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(fontWeight: FontWeight.w800)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Stay {
  final String title;
  final String city;
  final String country;
  final double rating;
  final double pricePerPerson;
  final String type;
  final bool pool;
  final bool parking;
  final bool freeCancel;
  final bool petFriendly;

  const _Stay({
    required this.title,
    required this.city,
    required this.country,
    required this.rating,
    required this.pricePerPerson,
    required this.type,
    this.pool = false,
    this.parking = false,
    this.freeCancel = false,
    this.petFriendly = false,
  });
}

const _mockStays = <_Stay>[
  _Stay(
    title: 'Hotel Indigo Vienna',
    city: 'Vienna',
    country: 'Austria',
    rating: 4.7,
    pricePerPerson: 120,
    type: 'Hotel',
    pool: true,
    parking: true,
    freeCancel: true,
    petFriendly: false,
  ),
  _Stay(
    title: 'Alps View Apartments',
    city: 'Zell am See',
    country: 'Austria',
    rating: 4.5,
    pricePerPerson: 80,
    type: 'Apartments',
    parking: true,
    freeCancel: true,
    petFriendly: true,
  ),
  _Stay(
    title: 'Backpackers Hub',
    city: 'Prague',
    country: 'Czechia',
    rating: 4.2,
    pricePerPerson: 35,
    type: 'Hostels',
    freeCancel: false,
    petFriendly: false,
  ),
  _Stay(
    title: 'Belvedere Vacation Home',
    city: 'Vienna',
    country: 'Austria',
    rating: 4.6,
    pricePerPerson: 150,
    type: 'Vacation Homes',
    pool: true,
    parking: false,
    freeCancel: true,
  ),
  _Stay(
    title: 'Sunrise Villas',
    city: 'Bali',
    country: 'Indonesia',
    rating: 4.8,
    pricePerPerson: 210,
    type: 'Villas',
    pool: true,
    parking: true,
    petFriendly: true,
  ),
];
