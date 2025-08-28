import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        const SliverToBoxAdapter(child: _TopBar()),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
            child: _HeroTitle(),
          ),
        ),
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: "Best Destination",
            actionText: "View all",
            onAction: () {},
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: 270,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              scrollDirection: Axis.horizontal,
              itemCount: _mockDestinations.length,
              separatorBuilder: (_, __) => const SizedBox(width: 14),
              itemBuilder: (context, i) =>
                  DestinationCard(data: _mockDestinations[i]),
            ),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 12)),
        SliverToBoxAdapter(
          child: _SectionHeader(
            title: "News",
            actionText: "View all",
            onAction: () {},
          ),
        ),
        SliverList.builder(
          itemCount: 4,
          itemBuilder: (_, i) => const Padding(
            padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: _NewsItemPlaceholder(),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.white, // Android; na iOS je transparentno
      ),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F5F8),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: const [
                  CircleAvatar(
                    radius: 14,
                    backgroundColor: Color(0xFFE7EBF0),
                    child: Icon(Icons.person, size: 16, color: Colors.black54),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Tarik',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Color(0xFFF3F5F8),
              ),
              child: IconButton(
                tooltip: 'Notifications',
                splashRadius: 22,
                icon: const Icon(
                  Icons.notifications_none_rounded,
                  color: Colors.black87,
                  size: 20,
                ),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).textTheme.displaySmall ??
        const TextStyle(fontSize: 34);
    return RichText(
      text: TextSpan(
        style: base.copyWith(
          height: 1.1,
          fontWeight: FontWeight.w800,
          color: Colors.black,
          letterSpacing: -0.2,
        ),
        children: const [
          TextSpan(text: "Explore the "),
          TextSpan(text: "world!", style: TextStyle(color: Color(0xFFFF7A00))),
          TextSpan(text: "\nwith "),
          TextSpan(text: "TravelGenie", style: TextStyle(color: Color(0xFF2F6BFF))),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String actionText;
  final VoidCallback onAction;
  const _SectionHeader(
      {required this.title, required this.actionText, required this.onAction});

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: Colors.black87,
          letterSpacing: -0.2,
        );
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
      child: Row(
        children: [
          Text(title, style: titleStyle),
          const Spacer(),
          GestureDetector(
            onTap: onAction,
            child: Text(
              actionText,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF2F6BFF),
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class DestinationCard extends StatelessWidget {
  final Destination data;
  const DestinationCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 264,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x143C4B64),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Container(
                height: 140,
                width: double.infinity,
                color: const Color(0xFFE6E9EE),
                child: const Icon(Icons.image_outlined,
                    size: 44, color: Colors.black38),
              ),
            ),
            const SizedBox(height: 12),
            Text(
              data.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.black87,
                    letterSpacing: -0.1,
                  ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                const Icon(Icons.star_rounded,
                    color: Color(0xFFFFC107), size: 18),
                const SizedBox(width: 4),
                Text(
                  "${data.rating}",
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 16, color: Colors.black54),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    data.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.copyWith(color: Colors.black54),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NewsItemPlaceholder extends StatelessWidget {
  const _NewsItemPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 78,
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
      child: Row(
        children: [
          Container(
            width: 92,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: Color(0xFFE6E9EE),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),
            ),
            child: const Icon(Icons.image_outlined,
                size: 28, color: Colors.black38),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "Travel news headline placeholder",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.black87,
                  ),
            ),
          ),
          const SizedBox(width: 12),
        ],
      ),
    );
  }
}

// Mock data
class Destination {
  final String title;
  final String subtitle;
  final double rating;
  const Destination({required this.title, required this.subtitle, required this.rating});
}

const _mockDestinations = <Destination>[
  Destination(title: "Hotel Indigo Vienna", subtitle: "Vienna, Austria", rating: 4.7),
  Destination(title: "Darmas Beach Resort", subtitle: "Bali, Indonesia", rating: 4.6),
  Destination(title: "Grand Alpine Lodge", subtitle: "Zermatt, Switzerland", rating: 4.8),
];
