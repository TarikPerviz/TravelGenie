import 'package:flutter/material.dart';
import '../widgets/user_avatar.dart';

class AddFriendScreen extends StatefulWidget {
  const AddFriendScreen({super.key});

  @override
  State<AddFriendScreen> createState() => _AddFriendScreenState();
}

class _AddFriendScreenState extends State<AddFriendScreen> {
  final TextEditingController _search = TextEditingController();

  final List<_Friend> _friends = const [
    _Friend("Sajib Rahman",  avatarBg: Color(0xFFFFE3AC), online: true),
    _Friend("Nedim Dzafic",  avatarBg: Color(0xFFE6F0FF), online: true),
    _Friend("Dino Keco",     avatarBg: Color(0xFFE7FFF1)),
    _Friend("Emir Sultan",   avatarBg: Color(0xFFFFEAF1)),
    _Friend("Enis Tvrtko",   avatarBg: Color(0xFFF2E6FF)),
    _Friend("Amina Hodzic",  avatarBg: Color(0xFFFFE3EC), online: true),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<_Friend> get _filtered {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return _friends;
    return _friends.where((f) => f.name.toLowerCase().contains(q)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // ── TOP BAR (isti stil kao ostatak aplikacije)
            const _TopBar(title: 'Add Friend'),

            // Title
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Find people',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),

            // Search
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: SizedBox(
                height: 46,
                child: TextField(
                  controller: _search,
                  onChanged: (_) => setState(() {}),
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search for people',
                    prefixIcon: Icon(Icons.search, color: on.withOpacity(.6)),
                  ),
                ),
              ),
            ),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: on.withOpacity(.06)),
                itemBuilder: (_, i) => _FriendRow(friend: _filtered[i]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────  Top bar (unified)  ───────────────────────── */

class _TopBar extends StatelessWidget {
  final String title;
  const _TopBar({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgBtn = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          // back
          InkWell(
            borderRadius: BorderRadius.circular(20),
            onTap: () => Navigator.of(context).maybePop(),
            child: Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(color: bgBtn, shape: BoxShape.circle),
              child: Icon(Icons.arrow_back_ios_new_rounded,
                  size: 18, color: theme.colorScheme.onSurface),
            ),
          ),
          const Spacer(),
          const Text(
            'Add Friend',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const Spacer(),
          // prazno za balans
          const SizedBox(width: 36, height: 36),
        ],
      ),
    );
  }
}

/* ─────────────────────────  Rows  ───────────────────────── */

class _FriendRow extends StatelessWidget {
  final _Friend friend;
  const _FriendRow({required this.friend});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        children: [
          // globalni avatar (isti kao na Groups tabu)
          UserAvatar(
            isGroup: false,
            online: friend.online,
            radius: 22,
            background: friend.avatarBg,
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.w700)),
                const SizedBox(height: 2),
                Text(
                  'Add a friend',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: on.withOpacity(.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Add button
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Friend request sent to ${friend.name}'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(40, 36),
              padding: const EdgeInsets.symmetric(horizontal: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────  Model  ───────────────────────── */

class _Friend {
  final String name;
  final Color avatarBg;
  final bool online;

  const _Friend(this.name, {required this.avatarBg, this.online = false});
}
