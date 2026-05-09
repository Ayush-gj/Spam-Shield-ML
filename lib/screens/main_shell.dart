import 'package:flutter/material.dart';
import '../models/history_entry.dart';
import '../widgets/app_drawer.dart';
import 'analysis_screen.dart';
import 'history_screen.dart';
import 'settings_screen.dart';

class MainShell extends StatefulWidget {
  final bool Function() getIsDark;
  final ValueChanged<bool> onThemeToggle;

  const MainShell({
    super.key,
    required this.getIsDark,
    required this.onThemeToggle,
  });

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _tab = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void _refresh() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      AnalysisScreen(
        key: const ValueKey('sms'),
        mode: 'SMS',
        onResult: (text, isSpam) {
          globalHistory.add(HistoryEntry(
            tab: 'SMS',
            text: text,
            isSpam: isSpam,
            timestamp: DateTime.now(),
          ));
          _refresh();
        },
      ),
      AnalysisScreen(
        key: const ValueKey('email'),
        mode: 'Email',
        onResult: (text, isSpam) {
          globalHistory.add(HistoryEntry(
            tab: 'Email',
            text: text,
            isSpam: isSpam,
            timestamp: DateTime.now(),
          ));
          _refresh();
        },
      ),
      HistoryScreen(history: globalHistory),

      // ✅ FINAL FIX
      SettingsScreen(
        isDark: widget.getIsDark(),
        onThemeToggle: (val) {
          widget.onThemeToggle(val);
          setState(() {});
        },
      ),
    ];

    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(['SMS Analysis', 'Email Analysis', 'History', 'Settings'][_tab]),
        leading: IconButton(
          icon: const Icon(Icons.menu_rounded),
          onPressed: () => _scaffoldKey.currentState?.openDrawer(),
        ),
      ),
      drawer: AppDrawer(
        currentTab: _tab,
        onTabSelected: (i) => setState(() => _tab = i),
      ),
      body: IndexedStack(index: _tab, children: pages),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _tab,
        onTap: (i) => setState(() => _tab = i),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.sms_outlined), activeIcon: Icon(Icons.sms_rounded), label: 'SMS'),
          BottomNavigationBarItem(icon: Icon(Icons.email_outlined), activeIcon: Icon(Icons.email_rounded), label: 'Email'),
          BottomNavigationBarItem(icon: Icon(Icons.history_outlined), activeIcon: Icon(Icons.history_rounded), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings_outlined), activeIcon: Icon(Icons.settings_rounded), label: 'Settings'),
        ],
      ),
    );
  }
}