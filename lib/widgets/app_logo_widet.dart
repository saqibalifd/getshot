import 'package:flutter/material.dart';
import 'package:getshotapp/constants/app_colors.dart';

class AppLogoWidet extends StatelessWidget {
  final bool? withTitle;
  const AppLogoWidet({super.key, this.withTitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 24),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [kPrimaryColor, kSecondaryColor],
              ),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.hub_rounded, color: kWhiteColor, size: 18),
          ),
          Visibility(
            visible: withTitle ?? false,
            child: Row(
              children: [
                const SizedBox(width: 10),
                const Text(
                  'GetShot',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    color: kWhiteColor,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
