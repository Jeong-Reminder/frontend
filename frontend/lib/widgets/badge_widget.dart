import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;

class DevelopmentBadge extends StatelessWidget {
  final String logoUrl;
  final String title;
  final Color titleColor;
  final Color badgeColor;
  final bool isSelected;
  const DevelopmentBadge(
      {required this.logoUrl,
      required this.title,
      required this.titleColor,
      required this.badgeColor,
      required this.isSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    return badges.Badge(
      badgeContent: IntrinsicWidth(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              logoUrl,
              width: 20,
            ),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
          ],
        ),
      ),
      badgeStyle: badges.BadgeStyle(
        badgeColor: badgeColor,
        shape: badges.BadgeShape.square,
        borderSide: isSelected
            ? const BorderSide(
                color: Color(0xFF2A72E7),
                width: 5.0,
              )
            : BorderSide.none,
      ),
    );
  }
}
