import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import '../theme/app_theme.dart';

class HistoryScreen extends StatelessWidget {
  final List<HistoryEntry> history;

  const HistoryScreen({super.key, required this.history});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (history.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: cs.onSurface.withValues(alpha: 0.06),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(Icons.history_rounded,
                  size: 36, color: cs.onSurface.withValues(alpha: 0.25)),
            ),
            const SizedBox(height: 16),
            Text(
              'No history yet',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: cs.onSurface.withValues(alpha: 0.5),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Analyzed messages will appear here',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.35),
              ),
            ),
          ],
        ),
      );
    }

    // Group by date
    final Map<String, List<HistoryEntry>> grouped = {};
    for (final e in history.reversed) {
      final key = _dateLabel(e.timestamp);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    // Summary counts
    final spamCount = history.where((e) => e.isSpam).length;
    final safeCount = history.length - spamCount;

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 40),
      children: [
        // Summary bar
        Row(
          children: [
            Expanded(
                child: _SummaryChip(
                    count: history.length,
                    label: 'Total',
                    color: AppTheme.primary)),
            const SizedBox(width: 10),
            Expanded(
                child: _SummaryChip(
                    count: spamCount,
                    label: 'Spam',
                    color: AppTheme.spamRed)),
            const SizedBox(width: 10),
            Expanded(
                child: _SummaryChip(
                    count: safeCount,
                    label: 'Safe',
                    color: AppTheme.safeGreen)),
          ],
        ),
        const SizedBox(height: 24),
        ...grouped.entries.expand((entry) => [
          _DateHeader(label: entry.key),
          ...entry.value.map((e) => _HistoryTile(entry: e)),
          const SizedBox(height: 8),
        ]),
      ],
    );
  }

  String _dateLabel(DateTime dt) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final d = DateTime(dt.year, dt.month, dt.day);
    if (d == today) return 'Today';
    if (d == today.subtract(const Duration(days: 1))) return 'Yesterday';
    return '${dt.day} ${_month(dt.month)} ${dt.year}';
  }

  String _month(int m) => const [
    '',
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
  ][m];
}

class _SummaryChip extends StatelessWidget {
  final int count;
  final String label;
  final Color color;

  const _SummaryChip(
      {required this.count, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Text(
            '$count',
            style: TextStyle(
                fontSize: 22, fontWeight: FontWeight.w700, color: color),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: color.withValues(alpha: 0.7)),
          ),
        ],
      ),
    );
  }
}

class _DateHeader extends StatelessWidget {
  final String label;

  const _DateHeader({required this.label});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10, top: 4),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: cs.onSurface.withValues(alpha: 0.4),
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Divider(
                color: cs.onSurface.withValues(alpha: 0.08), height: 1),
          ),
        ],
      ),
    );
  }
}

class _HistoryTile extends StatelessWidget {
  final HistoryEntry entry;

  const _HistoryTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final spamColor = isDark ? AppTheme.spamRedDark : AppTheme.spamRed;
    final safeColor = isDark ? AppTheme.safeGreenDark : AppTheme.safeGreen;
    final statusColor = entry.isSpam ? spamColor : safeColor;

    final time =
        '${entry.timestamp.hour.toString().padLeft(2, '0')}:${entry.timestamp.minute.toString().padLeft(2, '0')}';

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            // Type icon
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppTheme.primary.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                entry.tab == 'SMS' ? Icons.sms_rounded : Icons.email_rounded,
                size: 18,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            // Message preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.text,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.85)),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${entry.tab} · $time',
                    style: TextStyle(
                        fontSize: 11,
                        color: cs.onSurface.withValues(alpha: 0.35)),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Status badge
            Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                    color: statusColor.withValues(alpha: 0.25)),
              ),
              child: Text(
                entry.isSpam ? 'Spam' : 'Safe',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: statusColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}