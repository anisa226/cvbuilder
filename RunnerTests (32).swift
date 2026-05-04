import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../features/editor/resume_service.dart';
import '../../services/weather_service.dart';
import '../../services/quote_service.dart';

// ── Providers ─────────────────────────────────────────────────────────────────

final resumeServiceProvider = Provider<ResumeService>((ref) {
  return ResumeService(ref.watch(supabaseClientProvider));
});

final resumeListProvider = FutureProvider<List<ResumeRecord>>((ref) async {
  return ref.watch(resumeServiceProvider).fetchResumes();
});

final weatherProvider = FutureProvider<WeatherData?>((ref) async {
  return WeatherService().fetchWeather();
});

final quoteProvider = FutureProvider<QuoteData>((ref) async {
  return QuoteService().fetchTodayQuote();
});

// ── Dashboard Screen ──────────────────────────────────────────────────────────

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  late Timer _clockTimer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _now = DateTime.now());
    });
  }

  @override
  void dispose() {
    _clockTimer.cancel();
    super.dispose();
  }

  Future<void> _createNewResume() async {
    final svc = ref.read(resumeServiceProvider);
    try {
      final id = await svc.createResume(title: 'My Resume');
      if (mounted) {
        context.push('/editor', extra: {'resumeId': id, 'resumeData': null});
        ref.invalidate(resumeListProvider);
      }
    } catch (e) {
      _showError('Could not create resume. Check your connection.');
    }
  }

  Future<void> _deleteResume(String id) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text('Delete Resume'),
        content: const Text('This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await ref.read(resumeServiceProvider).deleteResume(id);
      ref.invalidate(resumeListProvider);
    }
  }

  void _signOut() async {
    await ref.read(authServiceProvider).signOut();
    if (mounted) context.go('/login');
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(msg),
      backgroundColor: AppColors.error,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;
    final firstName = (user?.userMetadata?['full_name'] as String? ?? 'there')
        .split(' ')
        .first;

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.canvas,
              AppColors.accentSoft.withOpacity(0.5),
            ],
          ),
        ),
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // ── App Bar ─────────────────────────────────────────
            SliverAppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              scrolledUnderElevation: 0,
              pinned: true,
              title: Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [AppColors.green, AppColors.accent],
                      ),
                      borderRadius: BorderRadius.circular(9),
                    ),
                    child: const Icon(Icons.description_rounded,
                        color: Colors.white, size: 16),
                  ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'CV Studio',
                      style: GoogleFonts.outfit(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      'developed by Neo Thinkers',
                      style: GoogleFonts.inter(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: AppColors.subtle,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            actions: [
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert_rounded,
                    color: AppColors.subtle, size: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: AppColors.surface,
                onSelected: (v) {
                  if (v == 'signout') _signOut();
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                    value: 'signout',
                    child: Row(children: [
                      const Icon(Icons.logout_rounded,
                          color: AppColors.error, size: 18),
                      const SizedBox(width: 10),
                      Text('Sign Out',
                          style:
                              const TextStyle(color: AppColors.error, fontSize: 14)),
                    ]),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
          ),

            // ── Content ──────────────────────────────────────────
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  const SizedBox(height: 12),
                  // ── Studio Hero ──────────────────────────────
                  _buildStudioHero(firstName),
                  const SizedBox(height: 28),

                  // ── Quick Actions ────────────────────────────
                  _buildQuickActions(),
                  const SizedBox(height: 32),

                  // ── My Library Section ───────────────────────
                  Row(
                    children: [
                      Text('Resume Library',
                          style: GoogleFonts.outfit(
                            fontSize: 26,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          )),
                      const Spacer(),
                      _buildMiniAddBtn(),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Resume Gallery ───────────────────────────
                  _buildResumeGrid(),
                  const SizedBox(height: 40),

                  // ── Career Insights ──────────────────────────
                  _buildCareerTip(),
                  const SizedBox(height: 40),
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniAddBtn() {
    return GestureDetector(
      onTap: _createNewResume,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.add_rounded, size: 14, color: Colors.white),
            SizedBox(width: 4),
            Text('NEW', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w800)),
          ],
        ),
      ),
    );
  }

  // ── Studio Hero: The Glassmorphic Creative Center ──────────────
  Widget _buildStudioHero(String firstName) {
    final hour = _now.hour;
    final greeting = hour < 12 ? 'Morning' : hour < 17 ? 'Afternoon' : 'Evening';
    
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.accent.withOpacity(0.35),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Hey $firstName,',
                      style: GoogleFonts.outfit(
                        fontSize: 26,
                        fontWeight: FontWeight.w500,
                        color: Colors.white.withOpacity(0.8),
                        height: 1.0,
                      ),
                    ),
                    Text(
                      'Good $greeting',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatsRing(),
            ],
          ),
          const SizedBox(height: 32),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withOpacity(0.2)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        DateFormat('hh:mm a').format(_now),
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: -1,
                        ),
                      ),
                      Text(
                        DateFormat('EEE, MMM d').format(_now).toUpperCase(),
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Colors.white.withOpacity(0.6),
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Consumer(
                  builder: (context, ref, child) {
                    final weather = ref.watch(weatherProvider);
                    return weather.when(
                      loading: () => const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)),
                      error: (err, stack) => Text('Weather Offline', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5))),
                      data: (data) => data == null 
                        ? Text('Location Syncing...', style: TextStyle(fontSize: 10, color: Colors.white.withOpacity(0.5)))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(data.emoji, style: const TextStyle(fontSize: 18)),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${data.tempC.round()}°',
                                    style: const TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                data.city.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white.withOpacity(0.7),
                                  letterSpacing: 1,
                                ),
                              ),
                            ],
                          ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 800.ms).slideY(begin: 0.1, curve: Curves.easeOutBack);
  }

  Widget _buildStatsRing() {
    return Container(
      width: 70,
      height: 70,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.1), width: 3),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircularProgressIndicator(
            value: 0.85,
            strokeWidth: 4,
            backgroundColor: Colors.white.withOpacity(0.1),
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('85', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
              Text('STR', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 8, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }

  // ── Quick Actions Hub ──────────────────────────────────────────
  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _actionTile('Scan', Icons.document_scanner_rounded, AppColors.teal),
        _actionTile('Gallery', Icons.auto_awesome_mosaic_rounded, AppColors.purple),
        _actionTile('Advice', Icons.psychology_rounded, AppColors.amber),
        _actionTile('Expert', Icons.verified_user_rounded, AppColors.indigo),
      ],
    );
  }

  Widget _actionTile(String label, IconData icon, Color color) {
    return GestureDetector(
      onTap: () => _showError('$label feature coming soon to CV Studio Pro!'),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: color.withOpacity(0.15)),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: AppColors.ink.withOpacity(0.7),
            ),
          ),
        ],
      ),
    ).animate().scale(delay: 400.ms, duration: 300.ms, curve: Curves.easeOutBack);
  }

  // ── Resume Gallery ─────────────────────────────────────────────
  Widget _buildResumeGrid() {
    final resumeAsync = ref.watch(resumeListProvider);
    return resumeAsync.when(
      data: (resumes) {
        if (resumes.isEmpty) return _buildEmptyResumes();
        
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: resumes.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.85,
          ),
          itemBuilder: (ctx, i) {
            final r = resumes[i];
            return _ResumeTile(
              record: r,
              onEdit: () {
                context.push('/editor', extra: {'resumeId': r.id, 'resumeData': r.cvData});
              },
              onDelete: () => _deleteResume(r.id),
            );
          },
        ).animate().fadeIn(duration: 600.ms);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Text('Error: $e'),
    );
  }

  // ── Quote of the day ───────────────────────────────────────────
  Widget _buildQuoteCard() {
    final quote = ref.watch(quoteProvider);
    return quote.when(
      data: (q) => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.accent.withOpacity(0.15)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.format_quote_rounded,
                color: AppColors.accent.withOpacity(0.6), size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    q.text,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.ink,
                      height: 1.5,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '— ${q.author}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.accent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ).animate().fadeIn(delay: 200.ms, duration: 500.ms),
      loading: () => Container(
        height: 70,
        decoration: BoxDecoration(
          color: AppColors.accentSoft,
          borderRadius: BorderRadius.circular(16),
        ),
      ),
      error: (_, __) => const SizedBox(),
    );
  }

  // ── Career tip ─────────────────────────────────────────────────
  Widget _buildCareerTip() {
    final tip = QuoteService().getTodayTip();
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.rule),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.amber.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.lightbulb_outline_rounded,
                color: AppColors.amber, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Career Tip of the Day',
                  style: TextStyle(
                    fontSize: 10,
                    letterSpacing: 1.0,
                    color: AppColors.amber,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(tip.text,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.ink,
                      height: 1.4,
                    )),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 500.ms);
  }

  // ── Empty state ────────────────────────────────────────────────
  Widget _buildEmptyResumes() {
    return GestureDetector(
      onTap: _createNewResume,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 48),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.rule),
        ),
        child: Column(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(Icons.add_rounded,
                  color: AppColors.accent, size: 30),
            ),
            const SizedBox(height: 16),
            const Text('Create your first resume',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink)),
            const SizedBox(height: 6),
            Text('Tap to get started',
                style: TextStyle(fontSize: 13, color: AppColors.muted)),
          ],
        ),
      ).animate().scale(
            begin: const Offset(0.95, 0.95),
            duration: 400.ms,
            curve: Curves.easeOutBack,
          ),
    );
  }
}

// ── Resume Tile (Creative Grid Item) ──────────────────────────────────────────

class _ResumeTile extends StatelessWidget {
  final ResumeRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _ResumeTile({
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  Color _templateColor(String id) {
    switch (id) {
      case 'modern':    return AppColors.teal;
      case 'minimal':   return AppColors.purple;
      case 'executive': return AppColors.amber;
      case 'creative':  return AppColors.rose;
      case 'academic':  return AppColors.green;
      case 'tech':      return AppColors.ink;
      case 'timeline':  return AppColors.accent;
      default:          return AppColors.accent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final tColor = _templateColor(record.templateId);
    final pct = record.completeness;

    return GestureDetector(
      onTap: onEdit,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.rule),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: Stack(
            children: [
              // Visual document feel
              Positioned(
                right: -15,
                bottom: -15,
                child: Transform.rotate(
                  angle: -0.2,
                  child: Icon(
                    Icons.description_rounded,
                    color: tColor.withOpacity(0.06),
                    size: 110,
                  ),
                ),
              ),
              
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: tColor.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(7),
                      ),
                      child: Text(
                        record.templateId.toUpperCase(),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.0,
                          color: tColor,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      record.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        height: 1.2,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    // Small progress bar info
                    Row(
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: LinearProgressIndicator(
                              value: pct / 100,
                              minHeight: 2.5,
                              backgroundColor: AppColors.rule,
                              color: tColor,
                            ),
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text('$pct%', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: tColor)),
                      ],
                    ),
                  ],
                ),
              ),
              
              // Floating actions on long press or top right
              Positioned(
                top: 8, right: 8,
                child: GestureDetector(
                  onTap: onDelete,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4)],
                    ),
                    child: const Icon(Icons.close_rounded, size: 12, color: AppColors.muted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ActionBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn(
      {required this.icon, required this.color, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(9),
        ),
        child: Icon(icon, size: 16, color: color),
      ),
    );
  }
}

String _relativeTime(DateTime dt) {
  final diff = DateTime.now().difference(dt);
  if (diff.inMinutes < 1) return 'just now';
  if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
  if (diff.inHours < 24) return '${diff.inHours}h ago';
  if (diff.inDays < 7) return '${diff.inDays}d ago';
  return DateFormat('d MMM').format(dt);
}


