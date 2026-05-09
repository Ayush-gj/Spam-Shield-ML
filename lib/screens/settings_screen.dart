import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

class SettingsScreen extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onThemeToggle;

  const SettingsScreen({super.key, required this.isDark, required this.onThemeToggle});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 40),
      children: [
        _SectionLabel(label: 'Appearance'),
        _SettingsCard(
          children: [
            _ThemeToggleTile(isDark: isDark, onToggle: onThemeToggle),
          ],
        ),
        const SizedBox(height: 24),
        _SectionLabel(label: 'About'),
        _SettingsCard(
          children: [
            _InfoTile(icon: Icons.shield_rounded, iconColor: AppTheme.primary, title: 'Spam Shield', subtitle: 'Version 1.0.0'),
            _Divider(),
            _InfoTile(icon: Icons.psychology_rounded, iconColor: const Color(0xFF7C5CBF), title: 'ML Model', subtitle: 'TF-IDF + Linear SVM'),
            _Divider(),
            _InfoTile(icon: Icons.calendar_today_rounded, iconColor: const Color(0xFF2E7D5E), title: 'Created', subtitle: '2025'),
            _Divider(),
            _InfoTile(icon: Icons.info_rounded, iconColor: const Color(0xFFB06A1C), title: 'Description', subtitle: 'On-device spam detection for SMS and email using a lightweight ML pipeline.', multiline: true),
          ],
        ),
        const SizedBox(height: 24),
        _SectionLabel(label: 'ML Pipeline'),
        _SettingsCard(
          children: [
            _PipelineStep(step: '1', label: 'Pre-processing', desc: 'Lowercase + clean'),
            _Divider(),
            _PipelineStep(step: '2', label: 'Vectorization', desc: 'TF-IDF (1000 features)'),
            _Divider(),
            _PipelineStep(step: '3', label: 'Classification', desc: 'Linear SVM'),
            _Divider(),
            _PipelineStep(step: '4', label: 'Result', desc: 'Score threshold at 0'),
          ],
        ),
      ],
    );
  }
}

class _ThemeToggleTile extends StatelessWidget {
  final bool isDark;
  final ValueChanged<bool> onToggle;

  const _ThemeToggleTile({required this.isDark, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: (isDark ? const Color(0xFF7C5CBF) : const Color(0xFFB06A1C)).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
              size: 19,
              color: isDark ? const Color(0xFF9B7FD4) : const Color(0xFFCB8A2A),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text(
            isDark ? 'Dark Mode' : 'Light Mode',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
            ),
                Text(
                  isDark ? 'Currently using dark theme' : 'Currently using light theme',
                  style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.45)),
                ),
              ],
            ),
          ),
          Switch(
            value: isDark,
            onChanged: onToggle,
            activeThumbColor: AppTheme.primary,
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(label.toUpperCase(), style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.35), letterSpacing: 1.1)),
    );
  }
}

class _SettingsCard extends StatelessWidget {
  final List<Widget> children;
  const _SettingsCard({required this.children});
  @override
  Widget build(BuildContext context) { return Card(child: Column(children: children)); }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) { return Divider(height: 1, color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.07), indent: 56); }
}

class _InfoTile extends StatelessWidget {
  final IconData icon; final Color iconColor; final String title; final String subtitle; final bool multiline;
  const _InfoTile({required this.icon, required this.iconColor, required this.title, required this.subtitle, this.multiline = false});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          Container(width: 38, height: 38, decoration: BoxDecoration(color: iconColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(10)), child: Icon(icon, size: 19, color: iconColor)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), const SizedBox(height: 2), Text(subtitle, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.45), height: multiline ? 1.5 : 1.0))]))
        ],
      ),
    );
  }
}

class _PipelineStep extends StatelessWidget {
  final String step; final String label; final String desc;
  const _PipelineStep({required this.step, required this.label, required this.desc});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: Row(
        children: [
          Container(width: 28, height: 28, decoration: BoxDecoration(color: AppTheme.primary.withValues(alpha: 0.12), shape: BoxShape.circle), child: Center(child: Text(step, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppTheme.primary)))),
          const SizedBox(width: 14),
          Expanded(child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)), Text(desc, style: TextStyle(fontSize: 12, color: cs.onSurface.withValues(alpha: 0.45)))]))
        ],
      ),
    );
  }
}