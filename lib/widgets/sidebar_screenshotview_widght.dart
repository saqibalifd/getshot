import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/widgets/app_logo_widet.dart';

// ─────────────────────────────────────────────
//  Data model for the user card
// ─────────────────────────────────────────────
class SidebarUser {
  final String name;
  final String ipAddress;
  final bool isActive;
  final DateTime? lastActive;
  final String? imageUrl;
  final String? latitude; // ← added
  final String? longitude; // ← added

  const SidebarUser({
    required this.name,
    required this.ipAddress,
    required this.isActive,
    this.lastActive,
    this.imageUrl,
    this.latitude, // ← added
    this.longitude, // ← added
  });
}

// ─────────────────────────────────────────────
//  Main sidebar widget
// ─────────────────────────────────────────────
class SidebarScreenshotviewWidght extends StatefulWidget {
  final VoidCallback? onAllUserTap;
  final VoidCallback? onScreenshotTap;

  final SidebarUser? selectedUser;

  const SidebarScreenshotviewWidght({
    super.key,
    this.onAllUserTap,
    this.onScreenshotTap,
    this.selectedUser,
  });

  @override
  State<SidebarScreenshotviewWidght> createState() =>
      _SidebarScreenshotviewWidghtState();
}

class _SidebarScreenshotviewWidghtState
    extends State<SidebarScreenshotviewWidght>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _pulseAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.06).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Container(
      width: width / 5,
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(right: BorderSide(color: kSurface, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppLogoWidet(withTitle: true),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: Text(
              'OVERVIEW',
              style: TextStyle(
                color: kGreyColor,
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
          const SizedBox(height: 8),

          _buildSidebarItem(Icons.people_alt_rounded, 'Users', true),

          if (widget.selectedUser != null) ...[
            const SizedBox(height: 12),
            _UserInfoCard(user: widget.selectedUser!),
          ],

          const Spacer(),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _isPressed ? 0.95 : _pulseAnimation.value,
                  child: child,
                );
              },
              child: GestureDetector(
                onTapDown: (_) => setState(() => _isPressed = true),
                onTapUp: (_) {
                  setState(() => _isPressed = false);
                  widget.onScreenshotTap?.call();
                },
                onTapCancel: () => setState(() => _isPressed = false),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: kPrimaryColor,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: kPrimaryColor.withValues(alpha: .35),
                        blurRadius: 16,
                        spreadRadius: 0,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: .15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.camera_alt_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'Take Screenshot',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Capture screen now',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: .65),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(IconData icon, String label, bool active) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: active ? kPrimaryColor.withValues(alpha: .05) : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        leading: Icon(
          icon,
          size: 18,
          color: active ? kPrimaryColor : kGreyColor,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: active ? kPrimaryColor : kGreyColor,
            fontSize: 13,
            fontWeight: active ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: widget.onAllUserTap,
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Beautiful user info card
// ─────────────────────────────────────────────
class _UserInfoCard extends StatelessWidget {
  final SidebarUser user;

  const _UserInfoCard({required this.user});

  String _formatLastActive(DateTime? dt) {
    if (dt == null) return 'Never';
    final diff = DateTime.now().difference(dt);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = user.isActive
        ? const Color(0xFF22C55E)
        : const Color(0xFF94A3B8);
    final statusLabel = user.isActive ? 'Active' : 'Offline';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Container(
        decoration: BoxDecoration(
          color: kPrimaryColor.withValues(alpha: .04),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: kPrimaryColor.withValues(alpha: .10),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
              child: Row(
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: kPrimaryColor.withValues(alpha: .12),
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: kPrimaryColor.withValues(alpha: .25),
                            width: 1.5,
                          ),
                        ),
                        child: ClipOval(
                          child: user.imageUrl != null
                              ? Image.network(
                                  user.imageUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) => Icon(
                                    Icons.person_rounded,
                                    color: kPrimaryColor.withValues(alpha: .60),
                                    size: 24,
                                  ),
                                )
                              : Icon(
                                  Icons.person_rounded,
                                  color: kPrimaryColor.withValues(alpha: .60),
                                  size: 24,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: Container(
                          width: 11,
                          height: 11,
                          decoration: BoxDecoration(
                            color: statusColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: kSurface, width: 2),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(width: 10),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: kWhiteColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        IntrinsicWidth(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 7,
                              vertical: 2.5,
                            ),
                            decoration: BoxDecoration(
                              color: statusColor.withValues(alpha: .13),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: BoxDecoration(
                                    color: statusColor,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  statusLabel,
                                  style: TextStyle(
                                    color: statusColor,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Divider(
              height: 1,
              thickness: 1,
              color: kPrimaryColor.withValues(alpha: .08),
            ),

            _InfoRow(
              icon: Icons.router_rounded,
              label: 'IP Address',
              value: user.ipAddress,
            ),

            Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: kPrimaryColor.withValues(alpha: .06),
            ),

            _InfoRow(
              icon: Icons.access_time_rounded,
              label: 'Last Active',
              value: _formatLastActive(
                user.lastActive,
              ), // ← still uses DateTime
            ),

            Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: kPrimaryColor.withValues(alpha: .06),
            ),

            _InfoRow(
              icon: Icons.swap_vert,
              label: 'Latitude',
              value: user.latitude ?? 'N/A', // ← fixed: directly use String
            ),

            Divider(
              height: 1,
              thickness: 1,
              indent: 12,
              endIndent: 12,
              color: kPrimaryColor.withValues(alpha: .06),
            ),

            _InfoRow(
              icon: Icons.swap_horiz,
              label: 'Longitude',
              value: user.longitude ?? 'N/A', // ← fixed: directly use String
              isLast: true,
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  Reusable label-value row inside the card
// ─────────────────────────────────────────────
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(12, 8, 12, isLast ? 12 : 8),
      child: Row(
        children: [
          Icon(icon, size: 13, color: kPrimaryColor.withValues(alpha: .55)),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: kWhiteColor.withValues(alpha: .60),
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          Flexible(
            child: Text(
              value,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                color: kWhiteColor,
                fontSize: 10,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
