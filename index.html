import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class QuoteData {
  final String text;
  final String author;
  const QuoteData({required this.text, required this.author});
}

class QuoteService {
  static const _cacheKey  = 'quote_cache_text';
  static const _authorKey = 'quote_cache_author';
  static const _dateKey   = 'quote_cache_date';

  /// Offline fallback quotes — career & growth themed.
  static const _offlineQuotes = [
    QuoteData(text: 'The future depends on what you do today.', author: 'Mahatma Gandhi'),
    QuoteData(text: 'Opportunities don\'t happen. You create them.', author: 'Chris Grosser'),
    QuoteData(text: 'Hard work beats talent when talent doesn\'t work hard.', author: 'Tim Notke'),
    QuoteData(text: 'Success usually comes to those who are too busy to be looking for it.', author: 'Henry David Thoreau'),
    QuoteData(text: 'Don\'t watch the clock; do what it does. Keep going.', author: 'Sam Levenson'),
    QuoteData(text: 'The way to get started is to quit talking and begin doing.', author: 'Walt Disney'),
    QuoteData(text: 'If you really look closely, most overnight successes took a long time.', author: 'Steve Jobs'),
    QuoteData(text: 'Your resume is not your life. Your work is.', author: 'Sheryl Sandberg'),
    QuoteData(text: 'It always seems impossible until it\'s done.', author: 'Nelson Mandela'),
    QuoteData(text: 'You don\'t have to be great to start, but you have to start to be great.', author: 'Zig Ziglar'),
    QuoteData(text: 'Believe you can and you\'re halfway there.', author: 'Theodore Roosevelt'),
    QuoteData(text: 'The secret of getting ahead is getting started.', author: 'Mark Twain'),
    QuoteData(text: 'Act as if what you do makes a difference. It does.', author: 'William James'),
    QuoteData(text: 'Quality is not an act, it is a habit.', author: 'Aristotle'),
    QuoteData(text: 'Excellence is not a destination but a continuous journey.', author: 'Brian Tracy'),
  ];

  static const _careerTips = [
    'Quantify your achievements — "Increased sales by 35%" beats "Improved sales".',
    'Tailor your CV for each job. One-size-fits-all rarely works.',
    'Use action verbs to start each bullet: Led, Built, Developed, Achieved.',
    'Keep your CV to 1–2 pages. Recruiters scan for 6–7 seconds on average.',
    'A professional email address matters more than you think.',
    'List your most recent experience first (reverse chronological order).',
    'Proofread twice. Grammar errors are the #1 reason CVs get rejected.',
    'LinkedIn profile URL in your CV header can increase responses by 40%.',
    'Include keywords from the job description to pass ATS filters.',
    'A strong professional summary can double your interview callbacks.',
    'Volunteer work and projects count as real experience.',
    'References are ready if asked — no need to list them on the CV itself.',
    'Be specific about your tech stack: "React 18, Node.js, PostgreSQL" beats just "Web development".',
    'Save your CV as a PDF — Word files often lose formatting.',
    'Update your CV every 6 months, even if you\'re not job hunting.',
  ];

  // ── Fetch today's motivational quote ─────────────────────────
  Future<QuoteData> fetchTodayQuote() async {
    // 1. Check if today's quote is already cached
    final cached = await _getCachedToday();
    if (cached != null) return cached;

    // 2. Try ZenQuotes API
    try {
      final res = await http
          .get(Uri.parse('https://zenquotes.io/api/today'))
          .timeout(const Duration(seconds: 6));
      if (res.statusCode == 200) {
        final list = jsonDecode(res.body) as List;
        if (list.isNotEmpty) {
          final q = list.first as Map<String, dynamic>;
          final data = QuoteData(
            text: q['q'] as String,
            author: q['a'] as String,
          );
          await _saveCache(data);
          return data;
        }
      }
    } catch (_) {}

    // 3. Fallback: deterministic offline quote based on day of year
    return _offlineQuotes[
        DateTime.now().dayOfYear % _offlineQuotes.length];
  }

  // ── Get today's career tip (deterministic) ────────────────────
  QuoteData getTodayTip() {
    final tip = _careerTips[DateTime.now().dayOfYear % _careerTips.length];
    return QuoteData(text: tip, author: 'CV Studio Pro Tip');
  }

  // ── Private helpers ───────────────────────────────────────────
  Future<QuoteData?> _getCachedToday() async {
    final prefs = await SharedPreferences.getInstance();
    final savedDate = prefs.getString(_dateKey);
    if (savedDate == null) return null;
    if (savedDate != _todayKey()) return null; // different day
    final text   = prefs.getString(_cacheKey);
    final author = prefs.getString(_authorKey);
    if (text == null || author == null) return null;
    return QuoteData(text: text, author: author);
  }

  Future<void> _saveCache(QuoteData q) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_cacheKey, q.text);
    await prefs.setString(_authorKey, q.author);
    await prefs.setString(_dateKey, _todayKey());
  }

  String _todayKey() {
    final n = DateTime.now();
    return '${n.year}-${n.month}-${n.day}';
  }
}

extension on DateTime {
  int get dayOfYear {
    return difference(DateTime(year, 1, 1)).inDays;
  }
}
