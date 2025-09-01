import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // MOCK kao na profilu
    const tripsCreated = 5;
    const tripsFinished = 4;
    const averageBookingCost = 359.0;

    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TopBar()),
        SliverToBoxAdapter(
          child: Container(
            color: theme.scaffoldBackgroundColor,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: const Column(
              children: [
                _AvatarBlock(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
        // Stats card — identičan princip kao na profilu
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _StatsCard(
              tripsCreated: tripsCreated,
              tripsFinished: tripsFinished,
              averageCostUSD: averageBookingCost,
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // Lista opcija
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _SettingsGroup(items: const [
              _SettingsItemData(
                icon: Icons.alternate_email_outlined,
                label: "Change Email",
              ),
              _SettingsItemData(
                icon: Icons.lock_outline,
                label: "Change Password",
              ),
            ]),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 28)),
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
      color: theme.scaffoldBackgroundColor,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          Text(
            "Account",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const Spacer(),
          // ostavljamo prazno da naslov ostane centriran (simetrija sa edit na profilu)
          const SizedBox(width: 36),
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
    final isDark = theme.brightness == Brightness.dark;
    final chip = isDark ? const Color(0xFF1B1F27) : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: chip,
          shape: BoxShape.circle,
          boxShadow: isDark
              ? null
              : const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  )
                ],
        ),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Column(
      children: [
        const CircleAvatar(
          radius: 42,
          backgroundColor: Color(0xFFFFE3EC), // dekorativno, isto kao na profilu
          child: Icon(Icons.person, size: 44, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        Text(
          "Tarik",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          "tarik@gmail.com",
          style: theme.textTheme.bodyMedium?.copyWith(
            color: onSurface.withValues(alpha: 0.6),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _StatsCard extends StatelessWidget {
  final int tripsCreated;
  final int tripsFinished;
  final double averageCostUSD;

  const _StatsCard({
    required this.tripsCreated,
    required this.tripsFinished,
    required this.averageCostUSD,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: theme.cardColor, // card po temi (light/dark)
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatCell(
            label: "Trips created",
            value: Text(
              "$tripsCreated",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _DividerY(),
          _StatCell(
            label: "Trips finished",
            value: Text(
              "$tripsFinished",
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          _DividerY(),
          _StatCell(
            label: "Average Cost",
            value: Text(
              "\$${averageCostUSD.toStringAsFixed(0)}",
              style: theme.textTheme.titleMedium?.copyWith(
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

class _StatCell extends StatelessWidget {
  final String label;
  final Widget value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodySmall?.copyWith(
              color: onSurface.withValues(alpha: 0.6),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          value,
        ],
      ),
    );
  }
}

class _DividerY extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 1,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: theme.dividerColor, // divider po temi
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItemData> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor, // card po temi
        borderRadius: BorderRadius.circular(18),
        boxShadow: isDark
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
        children: [
          for (int i = 0; i < items.length; i++) ...[
            _SettingsRow(data: items[i]),
            if (i != items.length - 1)
              Divider(
                height: 1,
                thickness: 1,
                color: theme.dividerColor, // divider po temi
              ),
          ],
        ],
      ),
    );
  }
}

class _SettingsItemData {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  const _SettingsItemData({
    required this.icon,
    required this.label,
    this.onTap,
  });
}

class _SettingsRow extends StatelessWidget {
  final _SettingsItemData data;
  const _SettingsRow({required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: data.onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(data.icon, color: onSurface.withValues(alpha: 0.7)),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.label,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: onSurface,
                ),
              ),
            ),
            Icon(Icons.chevron_right, color: onSurface.withValues(alpha: 0.55)),
          ],
        ),
      ),
    );
  }
}
