import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';

class AllUsersTile extends StatelessWidget {
  final String name;
  final String role;
  final String ipAddress;
  final String location;
  final bool isActive;

  const AllUsersTile({
    super.key,
    required this.name,
    required this.role,
    required this.ipAddress,
    required this.location,
    required this.isActive,
  });

  String get _initials {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.substring(0, 2).toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: kSurface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isActive
                ? kPrimaryColor.withValues(alpha: 0.15)
                : kGreyColor.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildIpRow(),
            const SizedBox(height: 10),
            _buildLocationRow(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        // Avatar
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: isActive
                ? kPrimaryColor.withValues(alpha: 0.08)
                : kGreyColor.withValues(alpha: 0.1),
            border: Border.all(
              color: isActive
                  ? kPrimaryColor.withValues(alpha: 0.25)
                  : kGreyColor.withValues(alpha: 0.25),
            ),
          ),
          child: Center(
            child: Text(
              _initials,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isActive ? kPrimaryColor : kGreyColor,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Name & Role
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? kWhiteColor
                      : kWhiteColor.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                role.toUpperCase(),
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: kGreyColor,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
        // Status badge
        _buildStatusBadge(),
      ],
    );
  }

  Widget _buildStatusBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isActive
            ? kPrimaryColor.withValues(alpha: 0.1)
            : kGreyColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isActive
              ? kPrimaryColor.withValues(alpha: 0.25)
              : kGreyColor.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 5,
            backgroundColor: isActive ? kPrimaryColor : kGreyColor,
          ),
          const SizedBox(width: 6),
          Text(
            isActive ? 'Active' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: isActive ? kPrimaryColor : kGreyColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'IP ADDRESS',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kGreyColor,
            letterSpacing: 0.5,
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: kSecondaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: kSecondaryColor.withValues(alpha: 0.1)),
          ),
          child: Text(
            ipAddress,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: isActive ? kSecondaryColor : kGreyColor,
              fontFamily: 'monospace',
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLocationRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'LOCATION',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w500,
            color: kGreyColor,
            letterSpacing: 0.5,
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.location_on_outlined,
              size: 13,
              color: isActive ? kSecondaryColor : kGreyColor,
            ),
            const SizedBox(width: 4),
            Text(
              overflow: TextOverflow.ellipsis,
              location,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: isActive ? kSecondaryColor : kGreyColor,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
