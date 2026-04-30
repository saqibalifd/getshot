import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData? icon;
  final Widget? action;

  const EmptyStateWidget({
    super.key,
    this.title = 'Nothing to show',
    this.subtitle = 'No data found here.\nItems will appear once available.',
    this.icon,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final heihgt = size.height;
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: heihgt / 7),
          _IconRing(icon: icon ?? Icons.inbox_outlined),
          const SizedBox(height: 28),
          Text(
            title,
            style: const TextStyle(
              color: kWhiteColor,
              fontSize: 20,
              fontWeight: FontWeight.w500,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: kGreyColor,
              fontSize: 13,
              height: 1.7,
            ),
          ),
          const SizedBox(height: 28),
          action ?? const _WaitingBadge(),
        ],
      ),
    );
  }
}

class _IconRing extends StatelessWidget {
  final IconData icon;
  const _IconRing({required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: kPrimaryColor.withOpacity(0.06),
        border: Border.all(color: kPrimaryColor.withOpacity(0.18), width: 1),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // outer ring
          Container(
            width: 116,
            height: 116,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: kSecondaryColor.withOpacity(0.12),
                width: 1,
              ),
            ),
          ),
          Icon(icon, size: 36, color: kPrimaryColor.withOpacity(0.7)),
        ],
      ),
    );
  }
}

class _WaitingBadge extends StatelessWidget {
  const _WaitingBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
      decoration: BoxDecoration(
        border: Border.all(color: kPrimaryColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(20),
        color: kPrimaryColor.withOpacity(0.07),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: kPrimaryColor.withOpacity(0.7),
            ),
          ),
          const SizedBox(width: 8),
          const Text(
            'Waiting for data',
            style: TextStyle(color: kPrimaryColor, fontSize: 12),
          ),
        ],
      ),
    );
  }
}
