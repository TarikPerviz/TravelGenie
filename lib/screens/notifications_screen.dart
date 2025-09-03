import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tab;

  // Mock data
  List<_Notif> recents = [
    _Notif("Nedim Dzale", "Lets plan out a coffe!", "Sun, 12:40pm",
        avatarColor: const Color(0xFFFFE3AC), bold: true, isPerson: true),
    _Notif("Super Offer", "Get 60% off in our first booking", "Mon, 11:50pm",
        avatarColor: const Color(0xFFE6F0FF)),
    _Notif("Super Offer", "Get 60% off in our first booking", "Tue, 10:56pm",
        avatarColor: const Color(0xFFE7FFF1)),
    _Notif("Super Offer", "Get 60% off in our first booking", "Wed, 12:40pm",
        avatarColor: const Color(0xFFFFEAF1)),
    _Notif("Super Offer", "Get 60% off in our first booking", "Fri, 11:50pm",
        avatarColor: const Color(0xFFE6F0FF)),
    _Notif("Super Offer", "Get 60% off in our first booking", "Sat, 10:56pm",
        avatarColor: const Color(0xFFF2F2F2)),
  ];

  List<_Notif> offers = List.generate(
    6,
    (i) => _Notif("Super Offer",
        "Get ${50 + i}% off in our first booking", "This week",
        avatarColor: const Color(0xFFE6F0FF)),
  );

  List<_Notif> messages = List.generate(
    5,
    (i) => _Notif("Tarik #$i", "Ping about the trip", "Yesterday, 9:${10 + i}pm",
        avatarColor: const Color(0xFFFFE3AC), isPerson: true),
  );

  @override
  void initState() {
    super.initState();
    _tab = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tab.dispose();
    super.dispose();
  }

  void _clearCurrent() {
    setState(() {
      switch (_tab.index) {
        case 0:
          recents.clear();
          break;
        case 1:
          offers.clear();
          break;
        case 2:
          messages.clear();
          break;
      }
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Cleared')),
    );
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
                  _CircleIconButton(
                    icon: Icons.arrow_back_ios_new_rounded,
                    onTap: () => context.pop(),
                  ),
                  const Spacer(),
                  const Text(
                    'Notification',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
                  ),
                  const Spacer(),
                  GestureDetector(
                    onTap: _clearCurrent,
                    child: const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      child: Text(
                        'Clear all',
                        style: TextStyle(
                          color: Color(0xFF1061FF),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Tabs
            Container(
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: TabBar(
                controller: _tab,
                labelPadding: const EdgeInsets.symmetric(horizontal: 12),
                indicatorColor: const Color(0xFF1061FF),
                indicatorWeight: 2,
                isScrollable: true,
                labelColor: const Color(0xFF1061FF),
                unselectedLabelColor: onSurface.withOpacity(.6),
                labelStyle: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 14),
                unselectedLabelStyle: const TextStyle(
                    fontWeight: FontWeight.w600, fontSize: 14),
                tabs: const [
                  Tab(text: 'Recent'),
                  Tab(text: 'Offers'),
                  Tab(text: 'Messages'),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Content
            Expanded(
              child: TabBarView(
                controller: _tab,
                children: [
                  _NotifList(items: recents, highlightFirst: true),
                  _NotifList(items: offers),
                  _NotifList(items: messages),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NotifList extends StatelessWidget {
  final List<_Notif> items;
  final bool highlightFirst;
  const _NotifList({required this.items, this.highlightFirst = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final onSurface = theme.colorScheme.onSurface;
    final highlight =
        theme.brightness == Brightness.dark ? const Color(0xFF13233B) : const Color(0xFFEAF4FF);

    if (items.isEmpty) {
      return Center(
        child: Text(
          'No notifications',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: onSurface.withOpacity(.6),
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
      itemCount: items.length,
      separatorBuilder: (_, __) =>
          Divider(height: 1, color: onSurface.withOpacity(.06)),
      itemBuilder: (context, i) {
        final n = items[i];
        final bg = (highlightFirst && i == 0) ? highlight : Colors.transparent;

        return InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () {
            // open thread / offer
          },
          child: Container(
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundColor: n.avatarColor,
                  child: Icon(
                    n.isPerson ? Icons.person : Icons.campaign_outlined,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              n.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style:
                                  theme.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            n.time,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: onSurface.withOpacity(.5),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        n.subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: onSurface.withOpacity(.65),
                          fontWeight:
                              n.bold ? FontWeight.w700 : FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _Notif {
  final String title;
  final String subtitle;
  final String time;
  final Color avatarColor;
  final bool bold;
  final bool isPerson;

  _Notif(this.title, this.subtitle, this.time,
      {this.avatarColor = const Color(0xFFE6F0FF),
      this.bold = false,
      this.isPerson = false});
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
