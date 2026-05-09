import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_theme.dart';
import '../widgets/result_card.dart';

class AnalysisScreen extends StatefulWidget {
  final String mode;
  final void Function(String text, bool isSpam) onResult;

  const AnalysisScreen(
      {super.key, required this.mode, required this.onResult});

  @override
  State<AnalysisScreen> createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen> {
  final TextEditingController _ctrl = TextEditingController();

  bool? _isSpam;
  bool _loading = false;
  bool _modelReady = false;
  bool _hasText = false;

  Map<String, dynamic>? _vocab;
  List<dynamic>? _weights;
  double? _bias;

  @override
  void initState() {
    super.initState();
    _loadModel();
    _ctrl.addListener(() {
      final has = _ctrl.text.trim().isNotEmpty;
      if (has != _hasText) setState(() => _hasText = has);
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  Future<void> _loadModel() async {
    try {
      final vocabStr = await rootBundle.loadString('assets/tfidf_vocab.json');
      final weightsStr =
      await rootBundle.loadString('assets/svm_weights.json');
      final vocabMap = json.decode(vocabStr);
      final weightsMap = json.decode(weightsStr);
      setState(() {
        _vocab = vocabMap;
        _weights = weightsMap['weights'];
        _bias = weightsMap['bias'];
        _modelReady = true;
      });
    } catch (_) {
      setState(() => _modelReady = false);
    }
  }

  void _analyze() {
    if (!_modelReady || _ctrl.text.trim().isEmpty) return;
    setState(() {
      _loading = true;
      _isSpam = null;
    });

    Future.delayed(const Duration(milliseconds: 400), () {
      final raw = _ctrl.text.toLowerCase();
      final clean = raw.replaceAll(RegExp(r'[^\w\s]'), '');
      final tokens = clean.split(' ');

      final vector = List<double>.filled(1000, 0.0);
      for (final word in tokens) {
        if (_vocab!.containsKey(word)) {
          final idx = _vocab![word] as int;
          if (idx < 1000) vector[idx] = 1.0;
        }
      }

      double score = _bias!;
      for (int i = 0; i < vector.length; i++) {
        score += vector[i] * (_weights![i] as num).toDouble();
      }

      final spam = score > 0;
      widget.onResult(_ctrl.text, spam);
      setState(() {
        _isSpam = spam;
        _loading = false;
      });
    });
  }

  void _clear() {
    _ctrl.clear();
    setState(() => _isSpam = null);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isEmail = widget.mode == 'Email';

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top info card
          _InfoBanner(isEmail: isEmail, isDark: isDark),
          const SizedBox(height: 20),

          // Input label
          Text(
            isEmail ? 'Email Content' : 'SMS Message',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: cs.onSurface.withValues(alpha: 0.55),
              letterSpacing: 0.4,
            ),
          ),
          const SizedBox(height: 8),

          // Text field
          TextField(
            controller: _ctrl,
            maxLines: isEmail ? 11 : 7,
            decoration: InputDecoration(
              hintText: isEmail
                  ? 'Paste the full email here (subject + body)...'
                  : 'Paste the SMS message here...',
              contentPadding: const EdgeInsets.all(16),
            ),
            style: TextStyle(
              fontSize: 14,
              height: 1.6,
              color: cs.onSurface,
            ),
          ),
          const SizedBox(height: 16),

          // Buttons row
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed:
                    _modelReady && _hasText && !_loading ? _analyze : null,
                    child: _loading
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                          strokeWidth: 2.5, color: Colors.white),
                    )
                        : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.search_rounded, size: 18),
                        SizedBox(width: 6),
                        Text('Analyze'),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              SizedBox(
                height: 48,
                child: OutlinedButton(
                  onPressed: _hasText ? _clear : null,
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    side: BorderSide(
                        color: cs.onSurface.withValues(alpha: 0.2)),
                    padding: const EdgeInsets.symmetric(horizontal: 18),
                  ),
                  child: const Text('Clear'),
                ),
              ),
            ],
          ),

          // Model loading indicator
          if (!_modelReady) ...[
            const SizedBox(height: 20),
            Row(
              children: [
                SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: cs.onSurface.withValues(alpha: 0.3)),
                ),
                const SizedBox(width: 10),
                Text('Loading ML model…',
                    style: TextStyle(
                        fontSize: 13,
                        color: cs.onSurface.withValues(alpha: 0.4))),
              ],
            ),
          ],

          // Result
          if (_isSpam != null) ...[
            const SizedBox(height: 24),
            ResultCard(isSpam: _isSpam!, label: ''),
          ],
        ],
      ),
    );
  }
}

class _InfoBanner extends StatelessWidget {
  final bool isEmail;
  final bool isDark;

  const _InfoBanner({required this.isEmail, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppTheme.primary.withValues(alpha: isDark ? 0.1 : 0.07),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
            color: AppTheme.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(
            isEmail ? Icons.email_rounded : Icons.sms_rounded,
            color: AppTheme.primary,
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              isEmail
                  ? 'Paste any suspicious email to detect phishing or spam'
                  : 'Paste any SMS to check for spam, scams, or fraud',
              style: TextStyle(
                fontSize: 13,
                color: cs.onSurface.withValues(alpha: 0.7),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}