import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/user_avatar.dart';

class InviteScreen extends StatefulWidget {
  /// Možeš promijeniti naslov (npr. "Invite to Trip")
  final String title;
  const InviteScreen({super.key, this.title = 'Friends'});

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  final TextEditingController _search = TextEditingController();
  final List<_Friend> _friends = const [
    _Friend('Sajib  Rahman', online: true),
    _Friend('Nedim Dzafic', online: true),
    _Friend('Dino Keco', online: true),
    _Friend('Emir Sultan', online: false),
    _Friend('Enis Tvrtko', online: false),
    _Friend('Amina Hodzic', online: true),
    _Friend('Selma K.', online: false),
  ];

  final Set<String> _invited = <String>{};

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

  void _toggleInvite(String name) {
    setState(() {
      if (_invited.contains(name)) {
        _invited.remove(name);
      } else {
        _invited.add(name);
      }
    });
  }

  // Pastel paleta (ista vibra kao Groups tab)
  static const _avatarPalette = <Color>[
    Color(0xFFFFE3AC), // amber
    Color(0xFFFFE3EC), // pink
    Color(0xFFE6F0FF), // blue
    Color(0xFFE7FFF1), // mint
    Color(0xFFFFEAF1), // rose
    Color(0xFFF2E6FF), // violet
  ];

  Color _bgFor(String name) {
    // deterministički indeks na osnovu imena
    final code = name.runes.fold<int>(0, (a, b) => (a + b) & 0x7fffffff);
    return _avatarPalette[code % _avatarPalette.length];
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
            // Top bar (ujednačen stil)
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  _CircleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  _CircleIcon(icon: Icons.more_horiz_rounded, onTap: () {}),
                ],
              ),
            ),

            // Subtitle + (zadržano malo desno kao u figmi)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
              child: Row(
                children: [
                  Text(
                    'Invite a friend',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const Spacer(),
                  Icon(Icons.edit_outlined, size: 20, color: on.withOpacity(.7)),
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

            const SizedBox(height: 4),

            // List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
                itemCount: _filtered.length,
                separatorBuilder: (_, __) =>
                    Divider(height: 1, color: on.withOpacity(.06)),
                itemBuilder: (_, i) {
                  final f = _filtered[i];
                  final invited = _invited.contains(f.name);
                  return _FriendRow(
                    friend: f,
                    bg: _bgFor(f.name),
                    invited: invited,
                    onInvite: () => _toggleInvite(f.name),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────  ROW  ───────────────────────── */

class _FriendRow extends StatelessWidget {
  final _Friend friend;
  final Color bg;
  final bool invited;
  final VoidCallback onInvite;

  const _FriendRow({
    required this.friend,
    required this.bg,
    required this.invited,
    required this.onInvite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
      child: Row(
        children: [
          // Globalni avatar (isti kao Groups tab)
          UserAvatar(
            isGroup: false,
            online: friend.online,
            radius: 22,
            background: bg,
          ),
          const SizedBox(width: 12),

          // Name + subtitle
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
                  'Invite a friend',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: on.withOpacity(.55),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          // Invite button (plavi kvadrat) -> Invited state
          GestureDetector(
            onTap: onInvite,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: 56,
              height: 40,
              decoration: BoxDecoration(
                color: invited ? const Color(0xFF50C878) : const Color(0xFF2F6BFF),
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x142F6BFF),
                    blurRadius: 12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                invited ? Icons.check_rounded : Icons.add_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Friend {
  final String name;
  final bool online;
  const _Friend(this.name, {this.online = false});
}

/* ─────────────────────────  Helpers  ───────────────────────── */

class _CircleIcon extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _CircleIcon({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B1F27)
        : const Color(0xFFF3F5F8);

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(color: bg, shape: BoxShape.circle),
        child: Icon(icon, size: 18, color: theme.colorScheme.onSurface),
      ),
    );
  }
}
