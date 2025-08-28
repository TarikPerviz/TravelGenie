import 'package:flutter/material.dart';

class TGNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onItemSelected;

  const TGNavBar({
    super.key,
    required this.currentIndex,
    required this.onItemSelected,
  });

  static const _blue = Color(0xFF2F6BFF);
  static const _labelInactive = Color(0xFF9AA3AE);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        height: 84,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: const Border(
            top: BorderSide(color: Color(0x11000000), width: 1),
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0F000000),
              blurRadius: 12,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _NavItem(
              icon: currentIndex == 0 ? Icons.home_rounded : Icons.home_outlined,
              label: 'Home',
              selected: currentIndex == 0,
              onTap: () => onItemSelected(0),
            ),
            _NavItem(
              icon: currentIndex == 1
                  ? Icons.event_note
                  : Icons.event_note_outlined,
              label: 'Trips',
              selected: currentIndex == 1,
              onTap: () => onItemSelected(1),
            ),

            // SREDNJE PLAVO DUGME (bez labela)
            GestureDetector(
              onTap: () => onItemSelected(2),
              child: Container(
                width: 56,
                height: 56,
                decoration: const BoxDecoration(
                  color: _blue,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Color(0x332F6BFF),
                      blurRadius: 16,
                      offset: Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(Icons.explore, color: Colors.white, size: 28),
              ),
            ),

            _NavItem(
              icon: currentIndex == 3
                  ? Icons.groups
                  : Icons.groups_outlined,
              label: 'Groups',
              selected: currentIndex == 3,
              onTap: () => onItemSelected(3),
            ),
            _NavItem(
              icon: currentIndex == 4
                  ? Icons.person
                  : Icons.person_outline,
              label: 'Profile',
              selected: currentIndex == 4,
              onTap: () => onItemSelected(4),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  static const _blue = Color(0xFF2F6BFF);
  static const _labelInactive = Color(0xFF9AA3AE);

  @override
  Widget build(BuildContext context) {
    final color = selected ? _blue : Colors.black87;
    final labelColor = selected ? _blue : _labelInactive;

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: SizedBox(
        width: 62,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: labelColor,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
