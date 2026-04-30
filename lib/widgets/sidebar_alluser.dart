import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';
import 'package:getshotapp/widgets/app_logo_widet.dart';

class SidebarAlluser extends StatelessWidget {
  final VoidCallback? onAllUserTap;
  const SidebarAlluser({super.key, this.onAllUserTap});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final width = size.width;
    return Container(
      width: width / 5,
      decoration: const BoxDecoration(
        color: kSurface,
        border: Border(right: BorderSide(color: kSurface, width: 1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo area
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
        onTap: onAllUserTap,
      ),
    );
  }
}
