class HistoryEntry {
  final String tab; // 'SMS' or 'Email'
  final String text;
  final bool isSpam;
  final DateTime timestamp;

  HistoryEntry({
    required this.tab,
    required this.text,
    required this.isSpam,
    required this.timestamp,
  });
}

final List<HistoryEntry> globalHistory = [];