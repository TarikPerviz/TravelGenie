import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool darkMode = false;

  @override
  Widget build(BuildContext context) {
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

        // Settings group
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
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
                  // Dark mode toggle row
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                    child: Row(
                      children: [
                        const Icon(Icons.dark_mode_outlined, color: Colors.black54),
                        const SizedBox(width: 12),
                        const Expanded(
                          child: Text(
                            "Dark Mode",
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Switch(
                          value: darkMode,
                          activeColor: const Color(0xFF1061FF),
                          onChanged: (val) => setState(() => darkMode = val),
                        ),
                      ],
                    ),
                  ),
                  const Divider(height: 1, thickness: 1, color: Color(0xFFF0F2F6)),

                  // Log Out row
                  InkWell(
                    onTap: () {
                      // TODO: implement real logout
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Logged out")),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                      child: Row(
                        children: [
                          Icon(Icons.logout, color: Colors.red),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              "Log Out",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          Icon(Icons.chevron_right, color: Colors.black38),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            "Settings",
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const Spacer(),
          const SizedBox(width: 36), // balans da ostane centrirano
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
          _StatCell(label: "Trips created", value: "$tripsCreated"),
          _DividerY(),
          _StatCell(label: "Trips finished", value: "$tripsFinished"),
          _DividerY(),
          _StatCell(label: "Average Cost", value: "\$$averageCostUSD"),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final String label;
  final String value;
  const _StatCell({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, textAlign: TextAlign.center),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF1061FF),
            ),
          ),
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
