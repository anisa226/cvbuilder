import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import '../../features/editor/cv_model.dart';
import '../../features/dashboard/dashboard_screen.dart';
import '../../services/pdf_service.dart';

// ── Template definitions ───────────────────────────────────────────────────────

class _TemplateInfo {
  final String id;
  final String name;
  final Color color;
  final IconData icon;
  const _TemplateInfo(this.id, this.name, this.color, this.icon);
}

const _templates = [
  _TemplateInfo('classic',   'Classic',   AppColors.ink,    Icons.article_rounded),
  _TemplateInfo('modern',    'Modern',    AppColors.accent,  Icons.view_column_rounded),
  _TemplateInfo('minimal',   'Minimal',   AppColors.green,  Icons.minimize_rounded),
  _TemplateInfo('executive', 'Executive', AppColors.amber,  Icons.workspace_premium_rounded),
  _TemplateInfo('creative',  'Creative',  AppColors.purple, Icons.palette_rounded),
  _TemplateInfo('academic',  'Academic',  AppColors.subtle, Icons.school_rounded),
  _TemplateInfo('tech',      'Tech',      AppColors.teal,   Icons.code_rounded),
  _TemplateInfo('timeline',  'Timeline',  AppColors.rose,   Icons.timeline_rounded),
];

// ── Preview Screen ─────────────────────────────────────────────────────────────

class PreviewScreen extends ConsumerStatefulWidget {
  final CVModel cvData;
  final String? resumeId;

  const PreviewScreen({super.key, required this.cvData, this.resumeId});

  @override
  ConsumerState<PreviewScreen> createState() => _PreviewScreenState();
}

class _PreviewScreenState extends ConsumerState<PreviewScreen>
    with TickerProviderStateMixin {

  String _selectedTemplate = 'classic';
  bool _isSharing = false;

  late AnimationController _entryAnim;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideUp;
  late AnimationController _statsAnim;
  late List<Animation<double>> _statAnims;

  @override
  void initState() {
    super.initState();

    _entryAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fadeIn = CurvedAnimation(parent: _entryAnim, curve: Curves.easeOut);
    _slideUp = Tween<Offset>(begin: const Offset(0, 0.06), end: Offset.zero)
        .animate(CurvedAnimation(parent: _entryAnim, curve: Curves.easeOutCubic));

    _statsAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _statAnims = List.generate(4, (i) => CurvedAnimation(
      parent: _statsAnim,
      curve: Interval(i * 0.15, 0.6 + i * 0.1, curve: Curves.easeOutBack),
    ));

    Future.delayed(const Duration(milliseconds: 100), () {
      _entryAnim.forward();
      Future.delayed(const Duration(milliseconds: 200), () => _statsAnim.forward());
    });
  }

  @override
  void dispose() {
    _entryAnim.dispose();
    _statsAnim.dispose();
    super.dispose();
  }

  // ── Save template preference to Supabase ────────────────────────
  Future<void> _onTemplateSelected(String templateId) async {
    setState(() => _selectedTemplate = templateId);
    if (widget.resumeId != null) {
      try {
        final svc = ref.read(resumeServiceProvider);
        await svc.updateTemplate(widget.resumeId!, templateId);
      } catch (_) {}
    }
  }

  // ── Share PDF ─────────────────────────────────────────────────────
  Future<void> _sharePdf() async {
    setState(() => _isSharing = true);
    try {
      final bytes = await PdfService.generateCV(widget.cvData, templateId: _selectedTemplate);
      final name = widget.cvData.name.isNotEmpty
          ? '${widget.cvData.name.replaceAll(' ', '_')}_CV.pdf'
          : 'CV.pdf';
      await Printing.sharePdf(bytes: bytes, filename: name);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Export failed: ${e.toString()}'),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ));
      }
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));

    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildAppBar(context),
            FadeTransition(
              opacity: _fadeIn,
              child: SlideTransition(
                position: _slideUp,
                child: Column(
                  children: [
                    _buildStatsRow(),
                    _buildTemplateSelector(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: FadeTransition(
                opacity: _fadeIn,
                child: SlideTransition(
                  position: _slideUp,
                  child: _buildPreviewArea(),
                ),
              ),
            ),
            _buildBottomBar(),
          ],
        ),
      ),
    );
  }

  // ── App Bar ─────────────────────────────────────────────────────
  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              width: 40, height: 40,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.rule),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
              ),
              child: const Icon(Icons.arrow_back_rounded, color: AppColors.ink, size: 18),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.cvData.name.isNotEmpty ? widget.cvData.name : 'Your CV',
                  style: GoogleFonts.outfit(
                    fontSize: 22, fontWeight: FontWeight.w600,
                    color: AppColors.ink, height: 1.0, letterSpacing: -0.5),
                ),
                const SizedBox(height: 2),
                Text('Ready to export',
                    style: GoogleFonts.inter(
                        fontSize: 11, color: AppColors.muted, fontWeight: FontWeight.w400)),
              ],
            ),
          ),
          // Export button (now actually works!)
          GestureDetector(
            onTap: _isSharing ? null : _sharePdf,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: _isSharing ? AppColors.subtle : AppColors.ink,
                borderRadius: BorderRadius.circular(10),
                boxShadow: _isSharing ? [] : [
                  BoxShadow(color: AppColors.ink.withOpacity(0.2), blurRadius: 12, offset: const Offset(0, 4)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _isSharing
                      ? const SizedBox(width: 14, height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Icon(Icons.ios_share_rounded, size: 14, color: Colors.white),
                  const SizedBox(width: 7),
                  Text(_isSharing ? 'Exporting…' : 'Export',
                      style: GoogleFonts.inter(
                          fontSize: 12, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Stats row ───────────────────────────────────────────────────
  Widget _buildStatsRow() {
    final d = widget.cvData;
    final items = [
      _StatItem('Experience', d.experiences.length, AppColors.accent),
      _StatItem('Education',  d.educations.length,  AppColors.green),
      _StatItem('Projects',   d.projects.length,    AppColors.teal),
      _StatItem('References', d.references.length,  AppColors.purple),
    ];
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 10),
      child: Row(
        children: List.generate(items.length, (i) {
          final item = items[i];
          return Expanded(
            child: ScaleTransition(
              scale: _statAnims[i],
              child: Padding(
                padding: EdgeInsets.only(right: i < items.length - 1 ? 8 : 0),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: AppColors.rule),
                  ),
                  child: Column(
                    children: [
                      Container(width: 5, height: 5,
                          decoration: BoxDecoration(
                            color: item.count > 0 ? item.color : AppColors.rule,
                            shape: BoxShape.circle)),
                      const SizedBox(height: 6),
                      Text('${item.count}',
                          style: GoogleFonts.outfit(
                            fontSize: 22, fontWeight: FontWeight.w700,
                            color: item.count > 0 ? item.color : AppColors.muted, height: 1.0)),
                      const SizedBox(height: 3),
                      Text(item.label.toUpperCase(),
                          style: GoogleFonts.inter(
                            fontSize: 8, color: AppColors.muted, fontWeight: FontWeight.w800, letterSpacing: 0.5),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Template selector ───────────────────────────────────────────
  Widget _buildTemplateSelector() {
    return SizedBox(
      height: 70,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
        itemCount: _templates.length,
        itemBuilder: (_, i) {
          final t = _templates[i];
          final selected = _selectedTemplate == t.id;
          return GestureDetector(
            onTap: () => _onTemplateSelected(t.id),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutCubic,
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: selected ? t.color : AppColors.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: selected ? t.color : AppColors.rule,
                  width: selected ? 0 : 1,
                ),
                boxShadow: selected ? [
                  BoxShadow(color: t.color.withOpacity(0.3), blurRadius: 10, offset: const Offset(0, 4)),
                ] : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(t.icon, size: 13, color: selected ? Colors.white : t.color),
                  const SizedBox(width: 6),
                  Text(t.name,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: selected ? Colors.white : AppColors.ink,
                      )),
                ],
              ),
            ).animate(delay: Duration(milliseconds: 40 * i)).fadeIn().slideX(begin: 0.2),
          );
        },
      ),
    );
  }

  // ── PDF Preview area ─────────────────────────────────────────────
  Widget _buildPreviewArea() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 0),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.rule),
        boxShadow: [BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 24, offset: const Offset(0, 8))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: PdfPreview(
          key: ValueKey(_selectedTemplate), // rebuild when template changes
          build: (_) => PdfService.generateCV(widget.cvData, templateId: _selectedTemplate),
          allowPrinting: true,
          allowSharing: true,
          canChangePageFormat: false,
          canChangeOrientation: false,
          canDebug: false,
          pdfPreviewPageDecoration: const BoxDecoration(color: Colors.transparent),
          previewPageMargin: const EdgeInsets.all(12),
          padding: EdgeInsets.zero,
          loadingWidget: const _PreviewLoader(),
          actions: const [],
          initialPageFormat: PdfPageFormat.a4,
        ),
      ),
    );
  }

  // ── Bottom bar ───────────────────────────────────────────────────
  Widget _buildBottomBar() {
    final pct = widget.cvData.completeness();
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: const BoxDecoration(
        color: AppColors.canvas,
        border: Border(top: BorderSide(color: AppColors.rule)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('$pct% complete',
                    style: GoogleFonts.inter(
                        fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink)),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(2),
                  child: LinearProgressIndicator(
                    value: pct / 100,
                    backgroundColor: AppColors.rule,
                    color: AppColors.accent,
                    minHeight: 3,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // Share PDF button (actually works!)
          GestureDetector(
            onTap: _isSharing ? null : _sharePdf,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
              decoration: BoxDecoration(
                color: AppColors.accent,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(color: AppColors.accent.withOpacity(0.3), blurRadius: 14, offset: const Offset(0, 5)),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.ios_share_rounded, size: 15, color: Colors.white),
                  const SizedBox(width: 8),
                  Text('Share PDF',
                      style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem {
  final String label;
  final int count;
  final Color color;
  const _StatItem(this.label, this.count, this.color);
}

class _PreviewLoader extends StatefulWidget {
  const _PreviewLoader();

  @override
  State<_PreviewLoader> createState() => _PreviewLoaderState();
}

class _PreviewLoaderState extends State<_PreviewLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _scale = Tween<double>(begin: 0.92, end: 1.0)
        .animate(CurvedAnimation(parent: _pulse, curve: Curves.easeInOut));
  }

  @override
  void dispose() { _pulse.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          ScaleTransition(
            scale: _scale,
            child: Container(
              width: 56, height: 56,
              decoration: BoxDecoration(
                color: AppColors.accentSoft,
                borderRadius: BorderRadius.circular(14)),
              child: const Icon(Icons.description_outlined, color: AppColors.accent, size: 26),
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(width: 24, height: 24,
              child: CircularProgressIndicator(strokeWidth: 2,
                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.accent))),
          const SizedBox(height: 16),
          Text('Composing your CV…',
              style: GoogleFonts.inter(
                  fontSize: 13, letterSpacing: 0.2, color: AppColors.muted, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
