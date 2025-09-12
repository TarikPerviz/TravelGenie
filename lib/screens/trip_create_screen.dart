import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:travelgenie/models/stay_search_args.dart';

class CreateTripScreen extends StatefulWidget {
  const CreateTripScreen({super.key});

  @override
  State<CreateTripScreen> createState() => _CreateTripScreenState();
}

class _CreateTripScreenState extends State<CreateTripScreen> {
  // Step state
  int _step = 0; // 0..2
  final _location = TextEditingController();
  DateTimeRange? _range;
  int _people = 2;

  @override
  void dispose() {
    _location.dispose();
    super.dispose();
  }

  void _goBack() {
    if (_step > 0) {
      setState(() => _step--);
    } else {
      Navigator.of(context).maybePop();
    }
  }

  Future<void> _pickRange() async {
    final now = DateTime.now();
    final initial = _range ??
        DateTimeRange(
          start: DateTime(now.year, now.month, now.day + 7),
          end: DateTime(now.year, now.month, now.day + 11),
        );

    final res = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
      initialDateRange: initial,
      saveText: 'Done',
      builder: (context, child) {
        // Card-like sheet look
        final theme = Theme.of(context);
        return Theme(
          data: theme.copyWith(
            dialogTheme: theme.dialogTheme.copyWith(
              backgroundColor: theme.colorScheme.surface,
              surfaceTintColor: Colors.transparent,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: theme.colorScheme.primary,
                textStyle: const TextStyle(fontWeight: FontWeight.w700),
              ),
            ),
          ),
          child: child!,
        );
      },
    );

    if (res != null) {
      setState(() => _range = res);
    }
  }

  bool get _canNext {
    if (_step == 0) return _location.text.trim().length >= 2;
    if (_step == 1) return _range != null;
    return _people > 0;
  }

  void _onNext() {
  if (_step < 2) {
    setState(() => _step++);
    return;
  }

  // smo na step 3 → šaljemo predefinisane filtere na Stay Search
  FocusScope.of(context).unfocus();

  final args = StaySearchArgs(
    location: _location.text.trim(),
    range: _range,      // već garantovano != null jer _canNext to provjerava
    people: _people,    // >= 1
  );

  context.go('/search/stay', extra: args);
}


  static String _fmt(DateTime d) => '${d.day}.${d.month}.${d.year}';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final chip = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    // Central card shadow samo u light
    final lightShadow = const [
      BoxShadow(
        color: Color(0x143C4B64),
        blurRadius: 18,
        offset: Offset(0, 10),
      ),
    ];

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
                    onTap: _goBack,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration:
                          BoxDecoration(color: chip, shape: BoxShape.circle),
                      child: Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18, color: on),
                    ),
                  ),
                  const Spacer(),
                  Text('Create Trip',
                      style: theme.textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700)),
                  const Spacer(),
                  // step pill
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: chip,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '${_step + 1}/3',
                      style: theme.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: on,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 480),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Title
                        _StepTitle(step: _step),
                        const SizedBox(height: 16),

                        // Card container po temi
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: theme.brightness == Brightness.light
                                ? lightShadow
                                : null,
                          ),
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 200),
                            child: _buildStep(theme, on),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // CTA
            SafeArea(
              top: false,
              minimum: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _canNext ? _onNext : null,
                  child: Text(_step == 2 ? 'Search stays' : 'Next'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStep(ThemeData theme, Color on) {
    switch (_step) {
      case 0:
        return _LocationStep(
          controller: _location,
          onChanged: (_) => setState(() {}),
        );
      case 1:
        return _DatesStep(
          range: _range,
          onPick: _pickRange,
        );
      default:
        return _PeopleStep(
          people: _people,
          onMinus: () => setState(() {
            if (_people > 1) _people--;
          }),
          onPlus: () => setState(() => _people++),
        );
    }
  }
}

/* ─────────────────────────  Step title  ───────────────────────── */

class _StepTitle extends StatelessWidget {
  final int step;
  const _StepTitle({required this.step});

  static const _orange = Color(0xFFFF7A00);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final base = theme.textTheme.headlineSmall ??
        const TextStyle(fontSize: 22, fontWeight: FontWeight.w700);

    TextSpan _blue(String t) =>
        TextSpan(text: t, style: TextStyle(color: theme.colorScheme.primary));
    TextSpan _normal(String t) =>
        TextSpan(text: t, style: TextStyle(color: theme.colorScheme.onSurface));
    TextSpan _orangeSpan(String t) =>
        TextSpan(text: t, style: TextStyle(color: _orange));

    switch (step) {
      case 0:
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: base.copyWith(fontWeight: FontWeight.w800, height: 1.25),
            children: [
              _blue('Where '),
              _normal('would you like to '),
              _orangeSpan('go?'),
            ],
          ),
        );
      case 1:
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: base.copyWith(fontWeight: FontWeight.w800, height: 1.25),
            children: [
              _blue('Choose '),
              _normal('dates of your '),
              _orangeSpan('trip'),
            ],
          ),
        );
      default:
        return RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: base.copyWith(fontWeight: FontWeight.w800, height: 1.25),
            children: [
              _blue('How many '),
              _normal('people are '),
              _orangeSpan('going?'),
            ],
          ),
        );
    }
  }
}

/* ─────────────────────────  Step 1: Location  ───────────────────────── */

class _LocationStep extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _LocationStep({
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Column(
      key: const ValueKey('location'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 52,
          child: TextField(
            controller: controller,
            onChanged: onChanged,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(
              hintText: 'Search a city or country (e.g. Vienna, Austria)',
              prefixIcon: Icon(Icons.search, color: on.withValues(alpha: .6)),
            ),
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
        ),
        const SizedBox(height: 14),
        // Quick suggestions (mock)
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final s in const [
              'Vienna, Austria',
              'Prague, Czechia',
              'Paris, France',
              'Bali, Indonesia'
            ])
              _ChipSuggestion(
                label: s,
                onTap: () {
                  controller.text = s;
                  onChanged(s);
                },
              ),
          ],
        ),
      ],
    );
  }
}

class _ChipSuggestion extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  const _ChipSuggestion({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration:
            BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────  Step 2: Dates  ───────────────────────── */

class _DatesStep extends StatelessWidget {
  final DateTimeRange? range;
  final VoidCallback onPick;
  const _DatesStep({required this.range, required this.onPick});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Column(
      key: const ValueKey('dates'),
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: theme.brightness == Brightness.dark
                ? const Color(0xFF1B1F27)
                : const Color(0xFFF5F7FA),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            children: [
              Icon(Icons.calendar_today_rounded,
                  size: 18, color: on.withValues(alpha: .65)),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  range == null
                      ? 'Select your start and end dates'
                      : '${_fmt(range!.start)} – ${_fmt(range!.end)}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              TextButton(
                onPressed: onPick,
                child: const Text('Choose'),
              )
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Tip: You can change dates later from the Overview screen.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: on.withValues(alpha: .6),
          ),
        ),
      ],
    );
  }

  String _fmt(DateTime d) => '${d.day}.${d.month}.${d.year}';
}

/* ─────────────────────────  Step 3: People  ───────────────────────── */

class _PeopleStep extends StatelessWidget {
  final int people;
  final VoidCallback onMinus;
  final VoidCallback onPlus;
  const _PeopleStep({
    required this.people,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;
    final chip = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    Widget _roundBtn(IconData icon, VoidCallback onTap) => InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(24),
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(color: chip, shape: BoxShape.circle),
            child: Icon(icon, color: on),
          ),
        );

    return Column(
      key: const ValueKey('people'),
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 4),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _roundBtn(Icons.remove_rounded, onMinus),
            const SizedBox(width: 18),
            Text(
              '$people',
              style: theme.textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w800,
                letterSpacing: -1,
              ),
            ),
            const SizedBox(width: 18),
            _roundBtn(Icons.add_rounded, onPlus),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          'Adults & friends (children soon)',
          style:
              theme.textTheme.bodySmall?.copyWith(color: on.withValues(alpha: .6)),
        ),
      ],
    );
  }
}
