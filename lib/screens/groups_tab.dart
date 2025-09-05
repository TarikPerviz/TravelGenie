import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/user_avatar.dart';


class GroupsTab extends StatelessWidget {
  const GroupsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TopBar()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 10),
            child: Text(
              'Messages',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: _SearchField()),
        SliverList.builder(
          itemCount: _mockChats.length,
          itemBuilder: (_, i) => _ChatRow(chat: _mockChats[i]),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

/* ─────────────────────────  TOP BAR  ───────────────────────── */

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
      child: Row(
        children: [
          _CircleIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {},
          ),
          const Spacer(),
          const Text(
            'Messages',
            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
          ),
          const Spacer(),
          _CircleIconButton(
            icon: Icons.person_add_alt_1, // 👈 Add friend
            onTap: () => context.push('/groups/add-friend'),
          ),
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

/* ─────────────────────────  SEARCH  ───────────────────────── */

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: SizedBox(
        height: 46,
        child: TextField(
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Search for chats & messages',
            prefixIcon: Icon(
              Icons.search,
              color: theme.colorScheme.onSurface.withOpacity(.6),
            ),
          ),
        ),
      ),
    );
  }
}

/* ─────────────────────────  CHAT ROW  ───────────────────────── */

class _ChatRow extends StatelessWidget {
  final _Chat chat;
  const _ChatRow({required this.chat});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return InkWell(
      onTap: () => context.push('/chat', extra: chat.title),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // avatar + online badge
            UserAvatar(
              isGroup: chat.isGroup,
              online: chat.isOnline,
              radius: 22,
              background: chat.avatarBg,
            ),

            const SizedBox(width: 12),

            // ime, preview, status
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ime + ticks/time/unread
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          chat.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (chat.delivery != null)
                        _TickIcon(state: chat.delivery!),
                      if (chat.unreadCount > 0) ...[
                        const SizedBox(width: 8),
                        _UnreadBadge(count: chat.unreadCount),
                      ],
                      const SizedBox(width: 8),
                      Text(
                        chat.time,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: onSurface.withOpacity(.45),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  // preview / typing
                  Text(
                    chat.isTyping ? 'Typing…' : chat.preview,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: chat.isTyping
                          ? const Color(0xFF1061FF)
                          : onSurface.withOpacity(.6),
                      fontWeight: chat.isTyping
                          ? FontWeight.w700
                          : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _UnreadBadge extends StatelessWidget {
  final int count;
  const _UnreadBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFF1061FF),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(
        '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

enum _Delivery { sent, delivered, read }

class _TickIcon extends StatelessWidget {
  final _Delivery state;
  const _TickIcon({required this.state});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface.withOpacity(.55);
    switch (state) {
      case _Delivery.sent:
        return Icon(Icons.check_rounded, size: 18, color: on);
      case _Delivery.delivered:
        return Icon(Icons.done_all_rounded, size: 18, color: on);
      case _Delivery.read:
        return const Icon(Icons.done_all_rounded,
            size: 18, color: Color(0xFF1061FF));
    }
  }
}

/* ─────────────────────────  MOCK DATA  ───────────────────────── */

class _Chat {
  final String id;
  final String title;
  final String preview;
  final String time;
  final bool isGroup;
  final bool isOnline;
  final bool isTyping;
  final Color avatarBg;
  final int unreadCount;
  final _Delivery? delivery;

  const _Chat({
    required this.id,
    required this.title,
    required this.preview,
    required this.time,
    this.isGroup = false,
    this.isOnline = false,
    this.isTyping = false,
    this.avatarBg = const Color(0xFFE6F0FF),
    this.unreadCount = 0,
    this.delivery,
  });
}

final _mockChats = <_Chat>[
  _Chat(
    id: '1',
    title: 'Sajib  Rahman',
    preview: 'Hi, John! 👋 How are you doing?',
    time: '09:46',
    isOnline: true,
    delivery: _Delivery.read,
    avatarBg: const Color(0xFFFFE3AC),
  ),
  _Chat(
    id: '2',
    title: 'Vienna 2025 Group',
    preview: 'Typing…',
    time: '08:42',
    isGroup: true,
    isTyping: true,
    unreadCount: 2,
    delivery: _Delivery.delivered,
    avatarBg: const Color(0xFFE7FFF1),
  ),
  _Chat(
    id: '3',
    title: 'HR Rumen',
    preview: 'You: Cool! 😄 Let’s meet at 18:00 near the traveling!',
    time: 'Yester\nday',
    delivery: _Delivery.read,
    avatarBg: const Color(0xFFFFEAF1),
  ),
  _Chat(
    id: '4',
    title: 'Anjelina',
    preview: 'You: Hey, will you come to the party on Saturday?',
    time: '07:15',
    delivery: _Delivery.sent,
    avatarBg: const Color(0xFFE6F0FF),
  ),
  _Chat(
    id: '5',
    title: 'Alexa Shorna',
    preview: 'Thank you for coming! Your or…',
    time: '05:55',
    unreadCount: 1,
    delivery: _Delivery.delivered,
    avatarBg: const Color(0xFFF2E6FF),
  ),
];
