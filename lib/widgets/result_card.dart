import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class ResultCard extends StatelessWidget {
  final bool isSpam;
  final String label;

  const ResultCard({super.key, required this.isSpam, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bg = isSpam ? const Color(0xFFFFF1F0) : const Color(0xFFEFFAF4);
    final bgDark = isSpam ? const Color(0xFF2A1515) : const Color(0xFF112A1E);
    final accent = isSpam ? AppTheme.spamRed : AppTheme.safeGreen;
    final accentDark = isSpam ? AppTheme.spamRedDark : AppTheme.safeGreenDark;
    final activeAccent = isDark ? accentDark : accent;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? bgDark : bg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: activeAccent.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: activeAccent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isSpam ? Icons.warning_amber_rounded : Icons.verified_rounded,
              color: activeAccent,
              size: 26,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isSpam ? 'Spam Detected' : 'Looks Safe',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: activeAccent,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  isSpam
                      ? 'This message appears to be spam'
                      : 'No spam patterns found',
                  style: TextStyle(
                    fontSize: 13,
                    color: activeAccent.withValues(alpha: 0.7),
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