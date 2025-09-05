import 'package:flutter/material.dart';

/// Univerzalni avatar za **osobu** ili **grupu**, sa:
/// - pastel pozadinom
/// - ikonom (person/groups) po potrebi
/// - online indikatorom (s bijelim obrubom)
///
/// Koristi default radius 22 (isti kao na Groups tabu).
class UserAvatar extends StatelessWidget {
  final bool isGroup;
  final bool online;
  final double radius;
  final Color background;
  final Color iconColor;
  final IconData? icon; // ako želiš nadjačati default ikonu

  const UserAvatar({
    super.key,
    this.isGroup = false,
    this.online = false,
    this.radius = 22,
    this.background = const Color(0xFFE6F0FF),
    this.iconColor = Colors.black54,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = radius; // za čitljivost

    return Stack(
      children: [
        CircleAvatar(
          radius: size,
          backgroundColor: background,
          child: Icon(
            icon ?? (isGroup ? Icons.groups : Icons.person),
            color: iconColor,
          ),
        ),
        if (!isGroup)
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: (size * 0.5), // skalira s radiusom (npr. 11px na 22px)
              height: (size * 0.5),
              decoration: BoxDecoration(
                color: online ? const Color(0xFF2CD35A) : Colors.grey.shade400,
                shape: BoxShape.circle,
                border: Border.all(
                  color: theme.scaffoldBackgroundColor,
                  width: (size * 0.09), // ~2px na 22px
                ),
              ),
            ),
          ),
      ],
    );
  }
}
