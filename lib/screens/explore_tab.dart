import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/place_details_args.dart';

class ExploreTab extends StatefulWidget {
  final String? focusedId;            // ⬅️ NOVO (opciono)
  const ExploreTab({super.key, this.focusedId});

  @override
  State<ExploreTab> createState() => _ExploreTabState();
}

class _ExploreTabState extends State<ExploreTab> {
  final _listController = ScrollController();
  Transport _mode = Transport.car;
  String? _focusedId;                // ⬇️ NOVO
  @override
  void initState() {
    super.initState();
    _focusedId = widget.focusedId; // ⬅️ ako je došao id preko rute, fokusiraj taj pin
  }
  // “Current location” na platnu (relativno: 0..1 na širinu/visinu).
  static const Offset _me = Offset(.5, .90);

  void _focusGoal(MapGoal g) {
    setState(() => _focusedId = g.id);
    final i = _mockGoals.indexWhere((e) => e.id == g.id);
    if (i >= 0) {
      _listController.animateTo(
        i * 88, // približna visina jednog itema
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    }
  }

  int _etaMinutes(MapGoal g) {
    // “Udaljenost” izračunata u relativnim koordinatama pa mapirana na minute.
    final d = (g.pos - _me).distance; // 0..~1.4
    // Pretvaranje u “kilometre” samo za osjećaj
    final km = d * 6.0;
    final kmh = switch (_mode) {
      Transport.car => 40.0,
      Transport.transit => 22.0,
      Transport.walk => 5.0,
    };
    final minutes = (km / kmh) * 60.0;
    return minutes.clamp(2, 120).round();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Stack(
          children: [
            // ==================== MAP CANVAS ====================
            Column(
              children: [
                // Top bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 10, 16, 8),
                  child: Row(
                    children: [
                      Text('Explore',
                          style: theme.textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w700)),
                      const Spacer(),
                      _ModeChip(
                        label: 'Car',
                        icon: Icons.directions_car_rounded,
                        selected: _mode == Transport.car,
                        onTap: () => setState(() => _mode = Transport.car),
                      ),
                      const SizedBox(width: 6),
                      _ModeChip(
                        label: 'Transit',
                        icon: Icons.directions_transit_rounded,
                        selected: _mode == Transport.transit,
                        onTap: () => setState(() => _mode = Transport.transit),
                      ),
                      const SizedBox(width: 6),
                      _ModeChip(
                        label: 'Walk',
                        icon: Icons.directions_walk_rounded,
                        selected: _mode == Transport.walk,
                        onTap: () => setState(() => _mode = Transport.walk),
                      ),
                    ],
                  ),
                ),

                // “Mapa”
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, c) {
                      final w = c.maxWidth;
                      final h = c.maxHeight;
                      return Stack(
                        children: [
                          // Pozadina (grid)
                          Container(
                            width: w,
                            height: h,
                            decoration: BoxDecoration(
                              color: theme.brightness == Brightness.dark
                                  ? const Color(0xFF12161C)
                                  : const Color(0xFFEFF2F6),
                            ),
                            child: CustomPaint(
                              painter: _GridPainter(
                                color: on.withOpacity(
                                    theme.brightness == Brightness.dark ? .06 : .08),
                              ),
                            ),
                          ),

                          // Mock “ruta” od _me do fokusiranog pina (samo radi dojma)
                          if (_focusedId != null)
                            CustomPaint(
                              size: Size(w, h),
                              painter: _RoutePainter(
                                from: Offset(_me.dx * w, _me.dy * h),
                                to: () {
                                  final g = _mockGoals
                                      .firstWhere((e) => e.id == _focusedId);
                                  return Offset(g.pos.dx * w, g.pos.dy * h);
                                }(),
                                color: theme.colorScheme.primary.withOpacity(.7),
                              ),
                            ),

                          // “Ja”
                          Positioned(
                            left: _me.dx * w - 12,
                            top: _me.dy * h - 12,
                            child: _MeDot(color: theme.colorScheme.primary),
                          ),

                          // Pinovi ciljeva
                          for (final g in _mockGoals)
                            Positioned(
                              left: g.pos.dx * w - 18,
                              top: g.pos.dy * h - 18,
                              child: _Pin(
                                goal: g,
                                selected: g.id == _focusedId,
                                onTap: () => _focusGoal(g),
                              ),
                            ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),

            // ==================== BOTTOM SHEET (Goals) ====================
            DraggableScrollableSheet(
              initialChildSize: 0.28,
              minChildSize: 0.22,
              maxChildSize: 0.9,
              builder: (context, controller) {
                return Container(
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(22)),
                    boxShadow: theme.brightness == Brightness.light
                        ? const [
                            BoxShadow(
                              color: Color(0x14000000),
                              blurRadius: 18,
                              offset: Offset(0, -10),
                            ),
                          ]
                        : null,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 8),
                      Container(
                        width: 44,
                        height: 4,
                        decoration: BoxDecoration(
                          color: on.withOpacity(.15),
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          children: [
                            Text('Goals today',
                                style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w800)),
                            const Spacer(),
                            Icon(Icons.tips_and_updates_outlined,
                                size: 18, color: on.withOpacity(.65)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      Expanded(
                        child: ListView.builder(
                          controller: controller
                            ..addListener(() {
                              // “sinkronizuj” eksterni kontroler kad ručno skrolamo
                              if (_listController.hasClients &&
                                  _listController.offset != controller.offset) {
                                _listController.jumpTo(controller.offset);
                              }
                            }),
                          itemCount: _mockGoals.length,
                          itemBuilder: (_, i) {
                            final g = _mockGoals[i];
                            final eta = _etaMinutes(g);
                            return _GoalTile(
                              goal: g,
                              etaMinutes: eta,
                              selected: g.id == _focusedId,
                              onTap: () {
                                _focusGoal(g);
                                context.push(
                                  '/place/details',
                                  extra: PlaceDetailsArgs(
                                    title: g.title,
                                    kind: g.kind,
                                    city: '${g.city}, ${g.country}',
                                    price: g.approxPrice ?? 0,
                                    unitLabel: g.unitLabel ?? 'Person',
                                    rating: g.rating ?? 4.6,
                                    reviews: g.reviews ?? 1200,
                                    selectable: false, // browse mod u Explore
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── helpers & widgets ───────────────────────── */

enum Transport { car, transit, walk }

class MapGoal {
  final String id;
  final String title;
  final String city;
  final String country;
  final String kind; // npr. Museum / Palace / Hotel …
  final Offset pos;  // relativno 0..1
  final int? approxPrice;
  final String? unitLabel;
  final double? rating;
  final int? reviews;

  const MapGoal({
    required this.id,
    required this.title,
    required this.city,
    required this.country,
    required this.kind,
    required this.pos,
    this.approxPrice,
    this.unitLabel,
    this.rating,
    this.reviews,
  });
}

const _mockGoals = <MapGoal>[
  MapGoal(
    id: 'belvedere',
    title: 'Belvedere Museum',
    city: 'Vienna',
    country: 'Austria',
    kind: 'Museum',
    pos: Offset(.28, .42),
    approxPrice: 25,
    unitLabel: 'Person',
    rating: 4.7,
    reviews: 2300,
  ),
  MapGoal(
    id: 'schoenbrunn',
    title: 'Schönbrunn Palace',
    city: 'Vienna',
    country: 'Austria',
    kind: 'Palace',
    pos: Offset(.62, .36),
    approxPrice: 30,
    unitLabel: 'Person',
    rating: 4.8,
    reviews: 4100,
  ),
  MapGoal(
    id: 'ststephen',
    title: "St. Stephen's Cathedral",
    city: 'Vienna',
    country: 'Austria',
    kind: 'Cathedral',
    pos: Offset(.48, .22),
    approxPrice: 0,
    unitLabel: 'Free',
    rating: 4.7,
    reviews: 5200,
  ),
  MapGoal(
    id: 'indigo',
    title: 'Hotel Indigo Vienna',
    city: 'Vienna',
    country: 'Austria',
    kind: 'Hotel',
    pos: Offset(.75, .58),
    approxPrice: 120,
    unitLabel: 'Night',
    rating: 4.6,
    reviews: 1900,
  ),
];

class _ModeChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;
  const _ModeChip({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final off =
        theme.brightness == Brightness.dark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);
    final bg = selected ? theme.colorScheme.primary : off;
    final fg = selected ? Colors.white : theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 34,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(16)),
        child: Row(
          children: [
            Icon(icon, size: 16, color: fg),
            const SizedBox(width: 6),
            Text(label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: fg,
                  fontWeight: FontWeight.w700,
                )),
          ],
        ),
      ),
    );
  }
}

class _MeDot extends StatelessWidget {
  final Color color;
  const _MeDot({required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24, height: 24,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Center(
        child: Container(
          width: 12, height: 12,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
      ),
    );
  }
}

class _Pin extends StatelessWidget {
  final MapGoal goal;
  final bool selected;
  final VoidCallback onTap;
  const _Pin({required this.goal, required this.selected, required this.onTap});

  IconData get _icon => switch (goal.kind.toLowerCase()) {
        'museum' => Icons.museum_rounded,
        'palace' => Icons.apartment_rounded,
        'cathedral' => Icons.church_rounded,
        'hotel' => Icons.bed_rounded,
        _ => Icons.place_rounded,
      };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dot = selected ? theme.colorScheme.primary : theme.colorScheme.secondary;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: const [BoxShadow(color: Color(0x33000000), blurRadius: 8, offset: Offset(0, 3))],
              border: Border.all(
                color: selected ? theme.colorScheme.primary : Colors.transparent,
                width: 2,
              ),
            ),
            child: Icon(_icon, size: 18, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(height: 4),
          Container(width: 6, height: 6, decoration: BoxDecoration(color: dot, shape: BoxShape.circle)),
        ],
      ),
    );
  }
}

class _GoalTile extends StatelessWidget {
  final MapGoal goal;
  final int etaMinutes;
  final bool selected;
  final VoidCallback onTap;
  const _GoalTile({
    required this.goal,
    required this.etaMinutes,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: 88,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
        decoration: BoxDecoration(
          color: selected ? theme.colorScheme.primary.withOpacity(.06) : theme.cardColor,
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: theme.brightness == Brightness.dark ? const Color(0xFF2A2F3A) : const Color(0xFFE6E9EE),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.image_outlined, color: on.withOpacity(.45)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(goal.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.location_on_outlined, size: 14),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          '${goal.city}, ${goal.country}',
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
                  const Spacer(),
                  Text(
                    '${goal.kind} • ~${etaMinutes} min',
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: on.withOpacity(.75),
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.chevron_right_rounded),
          ],
        ),
      ),
    );
  }
}

/* ───────────────────────── painters ───────────────────────── */

class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    const step = 24.0;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    for (double x = 0; x <= size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y <= size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}

class _RoutePainter extends CustomPainter {
  final Offset from;
  final Offset to;
  final Color color;
  const _RoutePainter({required this.from, required this.to, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    final path = Path()
      ..moveTo(from.dx, from.dy)
      // mala kriva radi dojma (bezier)
      ..cubicTo(
        from.dx, (from.dy + to.dy) / 2,
        to.dx,   (from.dy + to.dy) / 2,
        to.dx,   to.dy,
      );

    canvas.drawPath(path, p);
    // destination dot
    canvas.drawCircle(to, 4, Paint()..color = color);
  }

  @override
  bool shouldRepaint(covariant _RoutePainter old) =>
      old.from != from || old.to != to || old.color != color;
}
