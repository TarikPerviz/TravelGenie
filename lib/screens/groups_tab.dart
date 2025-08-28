import 'package:flutter/material.dart';

class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      itemBuilder: (_, i) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: const [BoxShadow(color: Color(0x143C4B64), blurRadius: 12, offset: Offset(0, 8))],
        ),
        child: Row(
          children: const [
            CircleAvatar(backgroundColor: Color(0xFFE6E9EE), radius: 22),
            SizedBox(width: 12),
            Expanded(child: Text("Travel group placeholder", style: TextStyle(fontWeight: FontWeight.w700))),
          ],
        ),
      ),
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemCount: 8,
    );
  }
}
