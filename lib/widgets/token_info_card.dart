import 'package:flutter/material.dart';
import 'package:hyper_app/theme/colors.dart';
import 'package:hyper_app/theme/text_style.dart';

class TokenInfoCard extends StatelessWidget {
  final String title;
  final String value;
  final Color? valueColor;
  final IconData? icon;
  final bool isPositive;

  const TokenInfoCard({
    super.key,
    required this.title,
    required this.value,
    this.valueColor,
    this.icon,
    this.isPositive = true,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDarkMode = brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: isDarkMode ? cardBackgroundDark : cardBackground,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 16,
                    color: textSecondary,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(
                  title,
                  style: labelMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: valueColor != null
                  ? headingSmall.copyWith(color: valueColor)
                  : headingSmall.copyWith(
                      color: isPositive ? success : error,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
