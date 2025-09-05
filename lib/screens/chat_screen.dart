import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/user_avatar.dart';

class ChatScreen extends StatefulWidget {
  final String chatTitle;
  const ChatScreen({super.key, this.chatTitle = 'Vienna 2025 Group'});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final List<_Msg> _messages = [
    _Msg.date('Today'),
    _Msg.text('Hello!', me: true, time: '9:24', status: _Status.read),
    _Msg.text(
      'Would you like to go on this adventure with me guys?\n'
      'The hotel is nice and the city is beautiful.',
      me: true,
      time: '9:30',
      status: _Status.read,
    ),
    _Msg.text('Hello!', avatarColor: const Color(0xFFFFEAF1), time: '9:34'),
    _Msg.text("I can't wait! Wohoooooooo",
        avatarColor: const Color(0xFFFFEAF1), time: '9:35', status: _Status.delivered),
    _Msg.text(
      'I need to pack some stuff, will someone be at home?',
      avatarColor: const Color(0xFFE7FFF1),
      time: '9:37',
      status: _Status.read,
    ),
    _Msg.text('I will be at home', me: true, time: '9:39', status: _Status.read),
  ];

  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            // Top bar
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
              child: Row(
                children: [
                  _CircleIcon(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          widget.chatTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Active Now',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: const Color(0xFF2CD35A),
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _CircleIcon(
                    icon: Icons.add_rounded,
                    onTap: () => context.push('/invite'),
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            // Messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 12),
                itemCount: _messages.length,
                itemBuilder: (context, i) {
                  final m = _messages[i];
                  if (m.isDate) return _DateChip(text: m.text!);

                  return _Bubble(
                    msg: m,
                    showAvatar: !m.me,
                  );
                },
              ),
            ),

            // Input bar
            SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12, 6, 12, 10),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        decoration: BoxDecoration(
                          color: theme.brightness == Brightness.dark
                              ? const Color(0xFF1B1F27)
                              : const Color(0xFFF3F5F8),
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: TextField(
                          controller: _controller,
                          textInputAction: TextInputAction.newline,
                          minLines: 1,
                          maxLines: 4,
                          decoration: InputDecoration(
                            hintText: 'Type your message',
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            prefixIcon: Icon(Icons.emoji_emotions_outlined,
                                color: onSurface.withOpacity(.55)),
                            suffixIcon: Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.attachment_rounded,
                                  color: onSurface.withOpacity(.55)),
                            ),
                            prefixIconConstraints:
                                const BoxConstraints(minWidth: 44),
                            suffixIconConstraints:
                                const BoxConstraints(minWidth: 44),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        // send / voice action
                      },
                      child: Container(
                        width: 52,
                        height: 52,
                        decoration: const BoxDecoration(
                          color: Color(0xFF1061FF),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Color(0x332F6BFF),
                              blurRadius: 16,
                              offset: Offset(0, 8),
                            )
                          ],
                        ),
                        child: const Icon(Icons.mic_rounded,
                            color: Colors.white, size: 26),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/* ─────────────────────────  Widgets  ───────────────────────── */

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

class _DateChip extends StatelessWidget {
  final String text;
  const _DateChip({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = theme.brightness == Brightness.dark
        ? const Color(0xFF1B2533)
        : const Color(0xFFF1F3F6);
    final on = theme.colorScheme.onSurface;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: on.withOpacity(.7),
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  final _Msg msg;
  final bool showAvatar;
  const _Bubble({required this.msg, this.showAvatar = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final on = theme.colorScheme.onSurface;

    final sentBg = theme.brightness == Brightness.dark
        ? const Color(0xFF162844)
        : const Color(0xFFEAF4FF);
    final recvBg = theme.brightness == Brightness.dark
        ? const Color(0xFF151922)
        : Colors.white;

    final align = msg.me ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = BorderRadius.only(
      topLeft: const Radius.circular(16),
      topRight: const Radius.circular(16),
      bottomLeft: Radius.circular(msg.me ? 16 : 4),
      bottomRight: Radius.circular(msg.me ? 4 : 16),
    );

    return Padding(
      padding: EdgeInsets.fromLTRB(
        msg.me ? 72 : 8,
        6,
        msg.me ? 8 : 72,
        6,
      ),
      child: Row(
        crossAxisAlignment:
            msg.me ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        mainAxisAlignment:
            msg.me ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!msg.me && showAvatar)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: UserAvatar(
                isGroup: false,
                online: false, // nema podatka; možeš dodati u model ako treba
                radius: 16,
                background: msg.avatarColor ?? const Color(0xFFE6F0FF),
              ),
            ),
          Flexible(
            child: Column(
              crossAxisAlignment: align,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: msg.me ? sentBg : recvBg,
                    borderRadius: radius,
                    boxShadow: theme.brightness == Brightness.dark
                        ? null
                        : const [
                            BoxShadow(
                              color: Color(0x143C4B64),
                              blurRadius: 14,
                              offset: Offset(0, 8),
                            ),
                          ],
                    border:
                        msg.me ? null : Border.all(color: on.withOpacity(.06)),
                  ),
                  child: Text(
                    msg.text!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: on,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      msg.time ?? '',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: on.withOpacity(.45),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (msg.me && msg.status != null) ...[
                      const SizedBox(width: 4),
                      _StatusIcon(status: msg.status!),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/* ─────────────────────────  Model & helpers  ───────────────────────── */

enum _Status { sent, delivered, read }

class _StatusIcon extends StatelessWidget {
  final _Status status;
  const _StatusIcon({required this.status});

  @override
  Widget build(BuildContext context) {
    final on = Theme.of(context).colorScheme.onSurface.withOpacity(.55);
    switch (status) {
      case _Status.sent:
        return Icon(Icons.check_rounded, size: 16, color: on);
      case _Status.delivered:
        return Icon(Icons.done_all_rounded, size: 16, color: on);
      case _Status.read:
        return const Icon(Icons.done_all_rounded,
            size: 16, color: Color(0xFF1061FF));
    }
  }
}

class _Msg {
  final bool me;
  final String? text;
  final String? time;
  final _Status? status;
  final Color? avatarColor;
  final bool isDate;

  _Msg.text(this.text,
      {this.me = false, this.time, this.status, this.avatarColor})
      : isDate = false;

  _Msg.date(String label)
      : me = false,
        text = label,
        time = null,
        status = null,
        avatarColor = null,
        isDate = true;
}
