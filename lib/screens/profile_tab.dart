import 'package:flutter/material.dart';

class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(18),
            boxShadow: const [BoxShadow(color: Color(0x143C4B64), blurRadius: 12, offset: Offset(0, 8))],
          ),
          child: Row(
            children: const [
              CircleAvatar(radius: 28, backgroundColor: Color(0xFFE6E9EE)),
              SizedBox(width: 12),
              Expanded(child: Text("Tarik", style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18))),
            ],
          ),
        ),
        const SizedBox(height: 12),
        for (final item in const ["Edit profile", "Change email", "Change password", "Notifications", "Logout"])
          Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(14),
              boxShadow: const [BoxShadow(color: Color(0x143C4B64), blurRadius: 10, offset: Offset(0, 6))],
            ),
            child: Row(
              children: [
                const Icon(Icons.chevron_right, color: Colors.black45),
                const SizedBox(width: 8),
                Text(item, style: const TextStyle(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
      ],
    );
  }
}
