import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // isti mock kao na profilu
    const tripsCreated = 5;
    const tripsFinished = 4;
    const averageBookingCost = 359;

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TopBar()),
        SliverToBoxAdapter(
          child: Container(
            color: Colors.white,
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Column(
              children: const [
                _AvatarBlock(),
                SizedBox(height: 12),
              ],
            ),
          ),
        ),
        // Stats card (isti kao na profilu)
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _StatsCard(
              tripsCreated: tripsCreated,
              tripsFinished: tripsFinished,
              averageCostUSD: averageBookingCost.toDouble(),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 16)),
        // LISTA OPCIJA — samo druge stavke
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const _SettingsGroup(items: [
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () => Navigator.of(context).maybePop(),
          ),
          const Spacer(),
          const Text(
            "Account",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const Spacer(),
          // 👇 maknuli smo edit dugme, ostaje prazno mjesto da naslov bude centriran
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
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: const Color(0xFFF3F5F8),
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            )
          ],
        ),
        child: Icon(icon, size: 18, color: Colors.black87),
      ),
    );
  }
}

class _AvatarBlock extends StatelessWidget {
  const _AvatarBlock();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        CircleAvatar(
          radius: 42,
          backgroundColor: Color(0xFFFFE3EC),
          child: Icon(Icons.person, size: 44, color: Colors.black54),
        ),
        SizedBox(height: 10),
        Text(
          "Tarik",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        SizedBox(height: 4),
        Text(
          "tarik@gmail.com",
          style: TextStyle(color: Color(0xFF8D929A), fontWeight: FontWeight.w500),
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
    final labelStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF6C7480),
          fontWeight: FontWeight.w600,
        );
    final valueStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
          color: const Color(0xFF1061FF),
          fontWeight: FontWeight.w700,
        );

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF4FF),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          _StatCell(
            label: "Trips created",
            value: Text("$tripsCreated", style: valueStyle),
          ),
          _DividerY(),
          _StatCell(
            label: "Trips finished",
            value: Text("$tripsFinished", style: valueStyle),
          ),
          _DividerY(),
          _StatCell(
            label: "Average Cost",
            value: Text("\$${averageCostUSD.toStringAsFixed(0)}", style: valueStyle),
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
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, textAlign: TextAlign.center),
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
    return Container(
      width: 1,
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 6),
      color: const Color(0xFFD9E2FF),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  final List<_SettingsItemData> items;
  const _SettingsGroup({required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: const [
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
              const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F6)),
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
    return InkWell(
      onTap: data.onTap ?? () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        child: Row(
          children: [
            Icon(data.icon, color: Colors.black54),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                data.label,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.chevron_right, color: Colors.black38),
          ],
        ),
      ),
    );
  }
}
