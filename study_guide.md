import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../editor/cv_model.dart';
import '../dashboard/dashboard_screen.dart';

// ── Form data holders (now with dispose) ──────────────────────────────────────

class ExperienceForm {
  final title   = TextEditingController();
  final company = TextEditingController();
  final date    = TextEditingController();
  final desc    = TextEditingController();
  void dispose() { title.dispose(); company.dispose(); date.dispose(); desc.dispose(); }
  void loadFrom(Experience e) { title.text = e.jobTitle; company.text = e.company; date.text = e.dateRange; desc.text = e.description; }
  Experience toModel() => Experience(title.text, company.text, date.text, desc.text);
}

class EducationForm {
  final degree      = TextEditingController();
  final institution = TextEditingController();
  final date        = TextEditingController();
  final result      = TextEditingController();
  void dispose() { degree.dispose(); institution.dispose(); date.dispose(); result.dispose(); }
  void loadFrom(Education e) { degree.text = e.degree; institution.text = e.institution; date.text = e.dateRange; result.text = e.result; }
  Education toModel() => Education(degree.text, institution.text, date.text, result.text);
}

class ResearchForm {
  final title = TextEditingController();
  final role  = TextEditingController();
  final desc  = TextEditingController();
  void dispose() { title.dispose(); role.dispose(); desc.dispose(); }
  void loadFrom(Research r) { title.text = r.title; role.text = r.role; desc.text = r.description; }
  Research toModel() => Research(title.text, role.text, desc.text);
}

class ProjectForm {
  final title     = TextEditingController();
  final techStack = TextEditingController();
  final desc      = TextEditingController();
  void dispose() { title.dispose(); techStack.dispose(); desc.dispose(); }
  void loadFrom(Project p) { title.text = p.title; techStack.text = p.techStack; desc.text = p.description; }
  Project toModel() => Project(title.text, techStack.text, desc.text);
}

class CertificationForm {
  final title  = TextEditingController();
  final issuer = TextEditingController();
  final year   = TextEditingController();
  void dispose() { title.dispose(); issuer.dispose(); year.dispose(); }
  void loadFrom(Certification c) { title.text = c.title; issuer.text = c.issuer; year.text = c.year; }
  Certification toModel() => Certification(title.text, issuer.text, year.text);
}

class ActivityForm {
  final role = TextEditingController();
  final org  = TextEditingController();
  final desc = TextEditingController();
  void dispose() { role.dispose(); org.dispose(); desc.dispose(); }
  void loadFrom(Activity a) { role.text = a.role; org.text = a.organization; desc.text = a.description; }
  Activity toModel() => Activity(role.text, org.text, desc.text);
}

class ReferenceForm {
  final name    = TextEditingController();
  final title   = TextEditingController();
  final org     = TextEditingController();
  final contact = TextEditingController();
  void dispose() { name.dispose(); title.dispose(); org.dispose(); contact.dispose(); }
  void loadFrom(Reference r) { name.text = r.name; title.text = r.title; org.text = r.organization; contact.text = r.contactInfo; }
  Reference toModel() => Reference(name.text, title.text, org.text, contact.text);
}

// ── Step metadata ──────────────────────────────────────────────────────────────

class _Step {
  final String index;
  final String title;
  final String subtitle;
  const _Step(this.index, this.title, this.subtitle);
}

const _steps = [
  _Step('01', 'Profile',    'Identity & summary'),
  _Step('02', 'Career',     'Experience & education'),
  _Step('03', 'Portfolio',  'Projects & achievements'),
  _Step('04', 'References', 'Who vouches for you'),
];

// ── Main Screen ────────────────────────────────────────────────────────────────

class InputScreen extends ConsumerStatefulWidget {
  final String? resumeId;
  final CVModel? initialData;

  const InputScreen({super.key, this.resumeId, this.initialData});

  @override
  ConsumerState<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends ConsumerState<InputScreen>
    with TickerProviderStateMixin {

  final _pageController = PageController();
  int _currentPage = 0;
  String _saveStatus = ''; // '', 'saving', 'saved', 'error'
  Timer? _saveDebounce;

  late AnimationController _headerAnim;
  late AnimationController _contentAnim;
  late AnimationController _navAnim;
  late Animation<double> _headerFade;
  late Animation<Offset> _headerSlide;
  late Animation<double> _contentFade;
  late Animation<Offset> _contentSlide;
  late Animation<double> _navFade;

  // Profile controllers
  final _name     = TextEditingController();
  final _email    = TextEditingController();
  final _phone    = TextEditingController();
  final _location = TextEditingController();
  final _links    = TextEditingController();
  final _summary  = TextEditingController();
  final _skills   = TextEditingController();
  final _langs    = TextEditingController();

  final List<ExperienceForm>    _experiences    = [];
  final List<EducationForm>     _educations     = [];
  final List<ResearchForm>      _researches     = [];
  final List<ProjectForm>       _projects       = [];
  final List<CertificationForm> _certifications = [];
  final List<ActivityForm>      _activities     = [];
  final List<ReferenceForm>     _references     = [];

  @override
  void initState() {
    super.initState();

    _headerAnim  = AnimationController(vsync: this, duration: const Duration(milliseconds: 700));
    _contentAnim = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _navAnim     = AnimationController(vsync: this, duration: const Duration(milliseconds: 500));

    _headerFade  = CurvedAnimation(parent: _headerAnim,  curve: Curves.easeOut);
    _headerSlide = Tween<Offset>(begin: const Offset(0, -0.08), end: Offset.zero)
        .animate(CurvedAnimation(parent: _headerAnim, curve: Curves.easeOutCubic));
    _contentFade  = CurvedAnimation(parent: _contentAnim, curve: Curves.easeOut);
    _contentSlide = Tween<Offset>(begin: const Offset(0, 0.04), end: Offset.zero)
        .animate(CurvedAnimation(parent: _contentAnim, curve: Curves.easeOutCubic));
    _navFade = CurvedAnimation(parent: _navAnim, curve: Curves.easeOut);

    // Load initial data if editing an existing resume
    if (widget.initialData != null) {
      _populateFromModel(widget.initialData!);
    }

    Future.delayed(const Duration(milliseconds: 80), () {
      if (mounted) {
        _headerAnim.forward();
        Future.delayed(const Duration(milliseconds: 150), () {
          if (mounted) { _contentAnim.forward(); _navAnim.forward(); }
        });
      }
    });

    // Set up auto-save listeners on profile fields
    for (final c in [_name, _email, _phone, _location, _links, _summary, _skills, _langs]) {
      c.addListener(_scheduleAutoSave);
    }
  }

  void _populateFromModel(CVModel m) {
    _name.text = m.name; _email.text = m.email; _phone.text = m.phone;
    _location.text = m.location; _links.text = m.links; _summary.text = m.summary;
    _skills.text = m.skills; _langs.text = m.languages;

    for (final e in m.experiences) { final f = ExperienceForm(); f.loadFrom(e); _experiences.add(f); }
    for (final e in m.educations)  { final f = EducationForm();  f.loadFrom(e); _educations.add(f); }
    for (final e in m.researches)  { final f = ResearchForm();   f.loadFrom(e); _researches.add(f); }
    for (final e in m.projects)    { final f = ProjectForm();    f.loadFrom(e); _projects.add(f); }
    for (final e in m.certifications) { final f = CertificationForm(); f.loadFrom(e); _certifications.add(f); }
    for (final e in m.activities)  { final f = ActivityForm();  f.loadFrom(e); _activities.add(f); }
    for (final e in m.references)  { final f = ReferenceForm(); f.loadFrom(e); _references.add(f); }
  }

  @override
  void dispose() {
    _pageController.dispose();
    _headerAnim.dispose();
    _contentAnim.dispose();
    _navAnim.dispose();
    _saveDebounce?.cancel();
    // Profile controllers
    for (final c in [_name, _email, _phone, _location, _links, _summary, _skills, _langs]) {
      c.dispose();
    }
    // Dynamic form controllers
    for (final f in _experiences)    f.dispose();
    for (final f in _educations)     f.dispose();
    for (final f in _researches)     f.dispose();
    for (final f in _projects)       f.dispose();
    for (final f in _certifications) f.dispose();
    for (final f in _activities)     f.dispose();
    for (final f in _references)     f.dispose();
    super.dispose();
  }

  // ── Auto-save (debounced 2s) ───────────────────────────────────
  void _scheduleAutoSave() {
    if (widget.resumeId == null) return;
    _saveDebounce?.cancel();
    setState(() => _saveStatus = 'saving');
    _saveDebounce = Timer(const Duration(seconds: 2), _performSave);
  }

  Future<void> _performSave() async {
    if (widget.resumeId == null) return;
    try {
      final svc = ref.read(resumeServiceProvider);
      await svc.saveResume(widget.resumeId!, _buildCVModel());
      if (mounted) setState(() => _saveStatus = 'saved');
      await Future.delayed(const Duration(seconds: 2));
      if (mounted) setState(() => _saveStatus = '');
    } catch (_) {
      if (mounted) setState(() => _saveStatus = 'error');
    }
  }

  CVModel _buildCVModel() => CVModel(
        name: _name.text, email: _email.text, phone: _phone.text,
        location: _location.text, links: _links.text, summary: _summary.text,
        skills: _skills.text, languages: _langs.text,
        experiences:    _experiences.map((f) => f.toModel()).toList(),
        educations:     _educations.map((f) => f.toModel()).toList(),
        researches:     _researches.map((f) => f.toModel()).toList(),
        projects:       _projects.map((f) => f.toModel()).toList(),
        certifications: _certifications.map((f) => f.toModel()).toList(),
        activities:     _activities.map((f) => f.toModel()).toList(),
        references:     _references.map((f) => f.toModel()).toList(),
      );

  // ── Navigation ─────────────────────────────────────────────────
  Future<void> _goToPage(int page) async {
    await _contentAnim.reverse();
    await _pageController.animateToPage(page,
        duration: const Duration(milliseconds: 450), curve: Curves.easeInOutQuart);
    _contentAnim.forward();
  }

  void _nextPage() {
    if (_currentPage < 3) _goToPage(_currentPage + 1);
    else _generateCV();
  }

  void _prevPage() {
    if (_currentPage > 0) _goToPage(_currentPage - 1);
  }

  void _generateCV() {
    final cv = _buildCVModel();
    context.push('/preview', extra: {
      'cvData': cv,
      'resumeId': widget.resumeId,
    });
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ));
    return Scaffold(
      backgroundColor: AppColors.canvas,
      body: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
          SafeArea(
            child: Column(
              children: [
                _buildHeader(),
                _buildStepRail(),
                Expanded(
                  child: SlideTransition(
                    position: _contentSlide,
                    child: FadeTransition(
                      opacity: _contentFade,
                      child: PageView(
                        controller: _pageController,
                        physics: const NeverScrollableScrollPhysics(),
                        onPageChanged: (p) => setState(() => _currentPage = p),
                        children: [
                          _scrollWrap(_buildProfileTab()),
                          _scrollWrap(_buildCareerTab()),
                          _scrollWrap(_buildPortfolioTab()),
                          _scrollWrap(_buildReferencesTab()),
                        ],
                      ),
                    ),
                  ),
                ),
                FadeTransition(opacity: _navFade, child: _buildFooter()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Header: Modern Studio Style ───────────────────────────────
  Widget _buildHeader() {
    final step = _steps[_currentPage];
    return SlideTransition(
      position: _headerSlide,
      child: FadeTransition(
        opacity: _headerFade,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
          child: Row(
            children: [
              // Back Button
              GestureDetector(
                onTap: () {
                  ref.invalidate(resumeListProvider);
                  context.go('/dashboard');
                },
                child: Container(
                  width: 44, height: 44,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(color: AppColors.rule),
                  ),
                  child: const Icon(Icons.close_rounded, color: AppColors.ink, size: 20),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('STEP ${step.index}',
                            style: GoogleFonts.inter(
                              fontSize: 10, fontWeight: FontWeight.w900,
                              color: AppColors.accent, letterSpacing: 1.2)),
                        const SizedBox(width: 8),
                        if (_saveStatus == 'saving')
                          Container(
                            width: 6, height: 6,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.amber),
                          ).animate(onPlay: (c) => c.repeat()).scale(duration: 500.ms, end: const Offset(1.5, 1.5)).fadeOut(),
                        if (_saveStatus == 'saved')
                          const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 10),
                      ],
                    ),
                    Text(step.title,
                        style: GoogleFonts.outfit(
                          fontSize: 28, fontWeight: FontWeight.w700,
                          color: AppColors.ink, height: 1.1)),
                  ],
                ),
              ),
              // Floating Preview
              GestureDetector(
                onTap: _generateCV,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: AppColors.ink,
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [BoxShadow(color: AppColors.ink.withOpacity(0.2), blurRadius: 10)],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.visibility_rounded, color: Colors.white, size: 16),
                      const SizedBox(width: 8),
                      Text('PREVIEW', style: GoogleFonts.inter(fontSize: 11, fontWeight: FontWeight.w900, color: Colors.white, letterSpacing: 0.5)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Step Rail: Designer Workspace Index ───────────────────────
  Widget _buildStepRail() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      child: Row(
        children: List.generate(_steps.length, (i) {
          final done = i < _currentPage;
          final active = i == _currentPage;
          return Expanded(
            child: GestureDetector(
              onTap: () => _goToPage(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: EdgeInsets.only(right: i < _steps.length - 1 ? 12 : 0),
                height: 4,
                decoration: BoxDecoration(
                  color: active ? AppColors.ink : done ? AppColors.accent : AppColors.rule,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ── Footer: Floating Glass Navigation ─────────────────────────
  Widget _buildFooter() {
    final isLast = _currentPage == 3;
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.ink.withOpacity(0.95),
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 20, offset: const Offset(0, 5)),
          ],
        ),
        child: Row(
          children: [
            // Back Icon Button
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _currentPage > 0 ? _prevPage : null,
                borderRadius: BorderRadius.circular(18),
                child: Container(
                  width: 48, height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(Icons.arrow_back_ios_new_rounded, 
                      size: 16, color: _currentPage > 0 ? Colors.white : Colors.white24),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Stack(
                alignment: Alignment.centerLeft,
                children: [
                  Container(height: 3, decoration: BoxDecoration(color: Colors.white12, borderRadius: BorderRadius.circular(2))),
                  AnimatedFractionallySizedBox(
                    duration: 400.ms,
                    widthFactor: (_currentPage + 1) / _steps.length,
                    child: Container(height: 3, decoration: BoxDecoration(color: AppColors.green, borderRadius: BorderRadius.circular(2))),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Primary Action
            GestureDetector(
              onTap: _nextPage,
              child: Container(
                height: 48,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                decoration: BoxDecoration(
                  color: isLast ? AppColors.green : Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Row(
                  children: [
                    Text(isLast ? 'GENERATE' : 'NEXT', 
                        style: GoogleFonts.inter(
                          fontSize: 13, fontWeight: FontWeight.w900, 
                          color: isLast ? Colors.white : AppColors.ink, letterSpacing: 1.0)),
                    const SizedBox(width: 8),
                    Icon(isLast ? Icons.auto_awesome : Icons.arrow_forward_rounded, 
                        size: 16, color: isLast ? Colors.white : AppColors.ink),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _scrollWrap(Widget child) => SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(28, 28, 28, 48),
        child: child,
      );

  // ── UI Primitives ──────────────────────────────────────────────

  Widget _groupLabel(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: Text(text,
            style: GoogleFonts.outfit(
              fontSize: 22, fontWeight: FontWeight.w700,
              color: AppColors.ink, letterSpacing: -0.3)),
      );

  Widget _divider() => Container(
        margin: const EdgeInsets.symmetric(vertical: 32),
        height: 1,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            AppColors.rule.withOpacity(0),
            AppColors.rule,
            AppColors.rule.withOpacity(0),
          ]),
        ),
      );

  Widget _labeled(String label, Widget field) => Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label.toUpperCase(),
                style: GoogleFonts.inter(
                  fontSize: 10, letterSpacing: 1.5,
                  color: AppColors.muted, fontWeight: FontWeight.w800)),
            const SizedBox(height: 7),
            field,
          ],
        ),
      );

  Widget _field(TextEditingController controller,
      {String hint = '', int maxLines = 1, VoidCallback? onChange}) {
    return _StyledField(
        controller: controller,
        hint: hint,
        maxLines: maxLines,
        onChange: onChange ?? _scheduleAutoSave);
  }

  Widget _sectionHeader(String label, Color color, VoidCallback onAdd) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.outfit(
                  fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink)),
          GestureDetector(
            onTap: onAdd,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(mainAxisSize: MainAxisSize.min, children: [
                Icon(Icons.add_circle_outline_rounded, size: 14, color: color),
                const SizedBox(width: 6),
                Text('ADD', style: GoogleFonts.inter(
                    fontSize: 11, fontWeight: FontWeight.w900, color: color, letterSpacing: 0.5)),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _entryCard(List<Widget> fields, Color accent, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.rule),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20, offset: const Offset(0,10))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              border: const Border(bottom: BorderSide(color: AppColors.rule)),
            ),
            child: Row(
              children: [
                Container(width: 10, height: 10, decoration: BoxDecoration(color: accent, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                const Spacer(),
                GestureDetector(
                  onTap: onRemove,
                  child: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: fields),
          ),
        ],
      ),
    );
  }

  // ── TABS ───────────────────────────────────────────────────────

  Widget _buildProfileTab() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _groupLabel('Essential Identity'),
      _glassContainer([
        _labeled('Full Name', _field(_name, hint: 'e.g. Md. Siam Hossain')),
        _labeled('Email Address', _field(_email, hint: 'you@email.com')),
        Row(children: [
          Expanded(child: _labeled('Phone', _field(_phone, hint: '+880 1XXX-XXXXXX'))),
          const SizedBox(width: 14),
          Expanded(child: _labeled('Location', _field(_location, hint: 'Dhaka, BD'))),
        ]),
        _labeled('Professional Links', _field(_links, hint: 'linkedin.com/in/... · github.com/...')),
      ]),
      const SizedBox(height: 32),
      _groupLabel('The Pitch'),
      _glassContainer([
        _labeled('Professional Summary',
            _field(_summary, hint: 'A compelling 2–3 sentence pitch...', maxLines: 4)),
        _labeled('Key Expertise',
            _field(_skills, hint: 'Python, Django, Flutter, ML...', maxLines: 2)),
        _labeled('Languages',
            _field(_langs, hint: 'English (Fluent), Bengali (Native)...')),
      ]),
    ]);
  }

  Widget _glassContainer(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: AppColors.rule),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }

  Widget _buildCareerTab() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _sectionHeader('WORK EXPERIENCE', AppColors.accent, () {
        setState(() { final f = ExperienceForm(); f.title.addListener(_scheduleAutoSave); _experiences.insert(0, f); });
      }),
      ..._experiences.map((f) => _entryCard([
            _labeled('Job Title', _field(f.title, hint: 'Software Engineer')),
            _labeled('Company', _field(f.company, hint: 'Datasoft Systems Ltd.')),
            _labeled('Duration', _field(f.date, hint: 'Nov 2024 – Present')),
            _labeled('Key Responsibilities', _field(f.desc, hint: 'What you built, led or improved...', maxLines: 4)),
          ], AppColors.accent, () => setState(() { f.dispose(); _experiences.remove(f); }))),

      const SizedBox(height: 24),
      _sectionHeader('EDUCATION', AppColors.green, () {
        setState(() => _educations.insert(0, EducationForm()));
      }),
      ..._educations.map((f) => _entryCard([
            _labeled('Degree', _field(f.degree, hint: 'B.Sc. in Computer Science')),
            _labeled('Institution', _field(f.institution, hint: 'Daffodil International University')),
            _labeled('Period', _field(f.date, hint: 'Jul 2022 – Jul 2026')),
            _labeled('Result / GPA', _field(f.result, hint: '3.63 / 4.00')),
          ], AppColors.green, () => setState(() { f.dispose(); _educations.remove(f); }))),

      const SizedBox(height: 24),
      _sectionHeader('RESEARCH & PAPERS', AppColors.purple, () {
        setState(() => _researches.insert(0, ResearchForm()));
      }),
      ..._researches.map((f) => _entryCard([
            _labeled('Title', _field(f.title, hint: 'e.g. Guardian on Board, IEEE 2025')),
            _labeled('Your Role', _field(f.role, hint: 'Lead Author / Co-author')),
            _labeled('Abstract', _field(f.desc, hint: 'Brief description...', maxLines: 3)),
          ], AppColors.purple, () => setState(() { f.dispose(); _researches.remove(f); }))),
    ]);
  }

  Widget _buildPortfolioTab() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _sectionHeader('PROJECTS', AppColors.teal, () {
        setState(() => _projects.insert(0, ProjectForm()));
      }),
      ..._projects.map((f) => _entryCard([
            _labeled('Project Name', _field(f.title, hint: 'BWDB Spike Detection System')),
            _labeled('Tech Stack', _field(f.techStack, hint: 'Django · React · PyTorch')),
            _labeled('Description', _field(f.desc, hint: 'What it does, results achieved...', maxLines: 3)),
          ], AppColors.teal, () => setState(() { f.dispose(); _projects.remove(f); }))),

      const SizedBox(height: 24),
      _sectionHeader('CERTIFICATIONS', AppColors.rose, () {
        setState(() => _certifications.insert(0, CertificationForm()));
      }),
      ..._certifications.map((f) => _entryCard([
            _labeled('Certification', _field(f.title, hint: 'TensorFlow Developer Certificate')),
            _labeled('Issuer', _field(f.issuer, hint: 'Google / Coursera / IEEE')),
            _labeled('Year', _field(f.year, hint: '2024')),
          ], AppColors.rose, () => setState(() { f.dispose(); _certifications.remove(f); }))),

      const SizedBox(height: 24),
      _sectionHeader('EXTRACURRICULARS', AppColors.amber, () {
        setState(() => _activities.insert(0, ActivityForm()));
      }),
      ..._activities.map((f) => _entryCard([
            _labeled('Role', _field(f.role, hint: 'Organizer / Trainer')),
            _labeled('Organization', _field(f.org, hint: 'DIU IoT Lab, Robotech...')),
            _labeled('Details', _field(f.desc, hint: 'Impact & highlights...', maxLines: 3)),
          ], AppColors.amber, () => setState(() { f.dispose(); _activities.remove(f); }))),
    ]);
  }

  Widget _buildReferencesTab() {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.accentSoft.withOpacity(0.5), 
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.accent.withOpacity(0.1))),
        child: Row(children: [
          Container(width: 44, height: 44,
              decoration: BoxDecoration(color: AppColors.accent, borderRadius: BorderRadius.circular(12)),
              child: const Icon(Icons.format_quote_rounded, color: Colors.white, size: 20)),
          const SizedBox(width: 16),
          Expanded(child: Text(
            'References lend credibility. Add 2–3 people who know your work well.',
            style: GoogleFonts.inter(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.accentDark))),
        ]),
      ),
      const SizedBox(height: 12),
      _sectionHeader('REFERENCES', AppColors.subtle, () {
        setState(() => _references.insert(0, ReferenceForm()));
      }),
      ..._references.map((f) => _entryCard([
            _labeled('Full Name', _field(f.name, hint: 'Dr. Jane Smith')),
            _labeled('Position', _field(f.title, hint: 'Associate Professor')),
            _labeled('Institution', _field(f.org, hint: 'Daffodil International University')),
            _labeled('Contact', _field(f.contact, hint: 'jane@diu.edu.bd · +880...')),
          ], AppColors.subtle, () => setState(() { f.dispose(); _references.remove(f); }))),
      if (_references.isEmpty)
        Container(
          margin: const EdgeInsets.only(top: 12),
          padding: const EdgeInsets.symmetric(vertical: 60),
          decoration: BoxDecoration(
            color: AppColors.surface, borderRadius: BorderRadius.circular(28),
            border: Border.all(color: AppColors.rule)),
          child: Column(children: [
            Container(width: 60, height: 60,
                decoration: BoxDecoration(color: AppColors.canvas, borderRadius: BorderRadius.circular(20)),
                child: const Icon(Icons.people_alt_rounded, color: AppColors.muted, size: 24)),
            const SizedBox(height: 20),
            Text('No references yet', style: GoogleFonts.outfit(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink)),
            const SizedBox(height: 4),
            Text('Tap ADD to include professionals in your network', style: GoogleFonts.inter(fontSize: 12, color: AppColors.muted, fontWeight: FontWeight.w500)),
          ]),
        ),
    ]);
  }
}

// ── Styled text field ─────────────────────────────────────────────────────────

class _StyledField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final VoidCallback? onChange;

  const _StyledField({
    required this.controller,
    this.hint = '',
    this.maxLines = 1,
    this.onChange,
  });

  @override
  State<_StyledField> createState() => _StyledFieldState();
}

class _StyledFieldState extends State<_StyledField>
    with SingleTickerProviderStateMixin {
  bool _focused = false;
  late AnimationController _anim;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(vsync: this, duration: const Duration(milliseconds: 200));
    _glow = CurvedAnimation(parent: _anim, curve: Curves.easeOut);
    widget.controller.addListener(() => widget.onChange?.call());
  }

  @override
  void dispose() { _anim.dispose(); super.dispose(); }

  void _onFocus(bool v) {
    setState(() => _focused = v);
    if (v) _anim.forward(); else _anim.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: AppColors.accent.withOpacity(0.1 * _glow.value),
              blurRadius: 15 * _glow.value,
              offset: Offset(0, 4 * _glow.value),
            )
          ],
        ),
        child: child!,
      ),
      child: Focus(
        onFocusChange: _onFocus,
        child: TextFormField(
          controller: widget.controller,
          maxLines: widget.maxLines,
          style: GoogleFonts.plusJakartaSans(
              fontSize: 14, fontWeight: FontWeight.w500, color: AppColors.ink, height: 1.5),
          decoration: InputDecoration(
            hintText: widget.hint,
            filled: true,
            fillColor: _focused ? AppColors.surface : AppColors.canvas.withOpacity(0.5),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.rule, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: AppColors.accent, width: 1.5),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Dot-grid background ────────────────────────────────────────────────────────

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColors.rule.withOpacity(0.15)..strokeCap = StrokeCap.round;
    const step = 28.0;
    for (double x = step; x < size.width; x += step) {
      for (double y = step; y < size.height; y += step) {
        canvas.drawCircle(Offset(x, y), 1.0, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter old) => false;
}
