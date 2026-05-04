import 'dart:typed_data';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import '../features/editor/cv_model.dart';

class PdfService {

  static Future<Uint8List> generateCV(CVModel cv, {String templateId = 'classic'}) async {
    switch (templateId) {
      case 'modern':    return _generateModern(cv);
      case 'minimal':   return _generateMinimal(cv);
      case 'executive': return _generateExecutive(cv);
      case 'creative':  return _generateCreative(cv);
      case 'academic':  return _generateAcademic(cv);
      case 'tech':      return _generateTech(cv);
      case 'timeline':  return _generateTimeline(cv);
      default:          return _generateClassic(cv);
    }
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 1 — Classic
  // Clean black-and-white, centered header, horizontal dividers
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateClassic(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 36, vertical: 32),
      build: (ctx) => [
        // Header
        pw.Center(child: pw.Text(
          cv.name.isEmpty ? 'YOUR NAME' : cv.name.toUpperCase(),
          style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, letterSpacing: 2),
        )),
        pw.SizedBox(height: 4),
        pw.Center(child: pw.Text(
          [cv.email, cv.phone, cv.location].where((e) => e.isNotEmpty).join('  |  '),
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700),
        )),
        if (cv.links.isNotEmpty)
          pw.Center(child: pw.Text(
            cv.links.split(',').map((s) => s.trim()).join('  -  '),
            style: const pw.TextStyle(fontSize: 9, color: PdfColors.blueGrey800))),
        pw.SizedBox(height: 14),
        pw.Divider(thickness: 1.5, color: PdfColors.black),
        pw.SizedBox(height: 10),

        if (cv.summary.isNotEmpty) ...[
          _classicTitle('PROFESSIONAL SUMMARY'),
          pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
          pw.SizedBox(height: 12),
        ],
        if (cv.experiences.isNotEmpty) ...[
          _classicTitle('WORK EXPERIENCE'),
          ...cv.experiences.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(e.dateRange, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
              ]),
              pw.Text(e.company, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
              if (e.description.isNotEmpty) pw.Padding(
                padding: const pw.EdgeInsets.only(top: 3),
                child: pw.Text(e.description, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
              ),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.educations.isNotEmpty) ...[
          _classicTitle('EDUCATION'),
          ...cv.educations.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(e.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                pw.Text(e.institution, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text(e.dateRange, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
                if (e.result.isNotEmpty) pw.Text('GPA: ${e.result}', style: const pw.TextStyle(fontSize: 10)),
              ]),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.projects.isNotEmpty) ...[
          _classicTitle('PROJECTS'),
          ...cv.projects.map((p) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(p.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                if (p.techStack.isNotEmpty) pw.Text(p.techStack,
                    style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
              ]),
              if (p.description.isNotEmpty) pw.Text(p.description,
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.skills.isNotEmpty || cv.languages.isNotEmpty) ...[
          _classicTitle('SKILLS & LANGUAGES'),
          if (cv.skills.isNotEmpty) pw.Text('Skills: ${cv.skills}', style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
          if (cv.languages.isNotEmpty) pw.Text('Languages: ${cv.languages}', style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 8),
        ],
        if (cv.researches.isNotEmpty) ...[
          _classicTitle('RESEARCH & PUBLICATIONS'),
          ...cv.researches.map((r) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(r.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(r.role, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
              if (r.description.isNotEmpty) pw.Text(r.description, style: const pw.TextStyle(fontSize: 10)),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.certifications.isNotEmpty) ...[
          _classicTitle('CERTIFICATIONS'),
          ...cv.certifications.map((c) => pw.Text('- ${c.title} — ${c.issuer} (${c.year})',
              style: const pw.TextStyle(fontSize: 10, lineSpacing: 2))),
          pw.SizedBox(height: 8),
        ],
        if (cv.activities.isNotEmpty) ...[
          _classicTitle('EXTRACURRICULARS'),
          ...cv.activities.map((a) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(a.role, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text(a.organization, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
              if (a.description.isNotEmpty) pw.Text(a.description, style: const pw.TextStyle(fontSize: 10)),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.references.isNotEmpty) ...[
          _classicTitle('REFERENCES'),
          ...cv.references.map((r) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 4),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(r.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text('${r.title}, ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
            ]),
          )),
        ],
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _classicTitle(String title) => pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 6, top: 4),
    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, letterSpacing: 1.2)),
      pw.Divider(thickness: 0.8, color: PdfColors.black),
      pw.SizedBox(height: 4),
    ]),
  );

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 2 — Modern (Two-column with a blue sidebar)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateModern(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    const accent = PdfColor.fromInt(0xFF059669); // CV Studio Emerald
    const sideW = 160.0;

    pdf.addPage(pw.MultiPage(
      pageTheme: pw.PageTheme(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.zero,
        buildBackground: (ctx) => pw.Row(children: [
          pw.Container(width: sideW, color: accent),
          pw.Expanded(child: pw.Container(color: PdfColors.white)),
        ]),
      ),
      build: (ctx) => [
        pw.Partitions(children: [
          // Sidebar Content
          pw.Partition(
            child: pw.Container(
              width: sideW,
              padding: const pw.EdgeInsets.all(20),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(cv.name.isEmpty ? 'Your Name' : cv.name,
                    style: pw.TextStyle(fontSize: 16, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
                pw.SizedBox(height: 4),
                pw.Divider(color: const PdfColor(1, 1, 1, 0.5), thickness: 0.5),
                pw.SizedBox(height: 10),
                _modernSideSection('CONTACT', [
                  if (cv.email.isNotEmpty)    cv.email,
                  if (cv.phone.isNotEmpty)    cv.phone,
                  if (cv.location.isNotEmpty) cv.location,
                  if (cv.links.isNotEmpty)    cv.links,
                ]),
                if (cv.skills.isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  _modernSideSection('SKILLS', cv.skills.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()),
                ],
                if (cv.languages.isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  _modernSideSection('LANGUAGES', cv.languages.split(',').map((s) => s.trim()).where((s) => s.isNotEmpty).toList()),
                ],
                if (cv.certifications.isNotEmpty) ...[
                  pw.SizedBox(height: 12),
                  _modernSideSection('CERTIFICATIONS', cv.certifications.map((c) => '${c.title} (${c.year})').toList()),
                ],
              ]),
            ),
          ),
          // Main content
          pw.Partition(
            child: pw.Padding(
              padding: const pw.EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                if (cv.summary.isNotEmpty) ...[
                  _modernMainSection('SUMMARY', accent),
                  pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
                  pw.SizedBox(height: 12),
                ],
                if (cv.experiences.isNotEmpty) ...[
                  _modernMainSection('EXPERIENCE', accent),
                  ...cv.experiences.map((e) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 8),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(e.jobTitle, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: accent)),
                      pw.Row(children: [
                        pw.Text(e.company, style: const pw.TextStyle(fontSize: 10)),
                        pw.Text('  |  ${e.dateRange}', style: pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                      ]),
                      if (e.description.isNotEmpty) pw.Padding(
                        padding: const pw.EdgeInsets.only(top: 3),
                        child: pw.Text(e.description, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8))),
                    ]),
                  )),
                  pw.SizedBox(height: 8),
                ],
                if (cv.educations.isNotEmpty) ...[
                  _modernMainSection('EDUCATION', accent),
                  ...cv.educations.map((e) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(e.degree, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: accent)),
                      pw.Text('${e.institution}  |  ${e.dateRange}',
                          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                      if (e.result.isNotEmpty) pw.Text('GPA: ${e.result}', style: const pw.TextStyle(fontSize: 10)),
                    ]),
                  )),
                  pw.SizedBox(height: 8),
                ],
                if (cv.projects.isNotEmpty) ...[
                  _modernMainSection('PROJECTS', accent),
                  ...cv.projects.map((p) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(p.title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: accent)),
                      if (p.techStack.isNotEmpty) pw.Text(p.techStack,
                          style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey700)),
                      if (p.description.isNotEmpty) pw.Text(p.description,
                          style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
                    ]),
                  )),
                ],
                if (cv.researches.isNotEmpty) ...[
                  _modernMainSection('RESEARCH', accent),
                  ...cv.researches.map((r) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(r.title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: accent)),
                      pw.Text(r.role, style: const pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                      if (r.description.isNotEmpty) pw.Text(r.description, style: const pw.TextStyle(fontSize: 10)),
                    ]),
                  )),
                ],
                if (cv.activities.isNotEmpty) ...[
                  _modernMainSection('EXTRACURRICULARS', accent),
                  ...cv.activities.map((a) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 4),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(a.role, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text(a.organization, style: const pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                    ]),
                  )),
                ],
                if (cv.references.isNotEmpty) ...[
                  _modernMainSection('REFERENCES', accent),
                  ...cv.references.map((r) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(r.name, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
                      pw.Text('${r.title}, ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                    ]),
                  )),
                ],
              ]),
            ),
          ),
        ]),
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _modernSideSection(String title, List<String> items) {
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      pw.Text(title, style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold,
          color: const PdfColor(1, 1, 1, 0.7), letterSpacing: 1.2)),
      pw.SizedBox(height: 5),
      ...items.map((item) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 3),
        child: pw.Text(item, style: const pw.TextStyle(fontSize: 9, color: PdfColors.white)),
      )),
    ]);
  }

  static pw.Widget _modernMainSection(String title, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold,
            color: accent, letterSpacing: 1.0)),
        pw.Container(height: 1.5, color: accent, margin: const pw.EdgeInsets.only(top: 3, bottom: 6)),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 3 — Minimal (ultra-clean, green accents)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateMinimal(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    const accent = PdfColor.fromInt(0xFF059669); // CV Studio Emerald

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 48, vertical: 40),
      build: (ctx) => [
        pw.Text(cv.name.isEmpty ? 'Your Name' : cv.name,
            style: pw.TextStyle(fontSize: 30, fontWeight: pw.FontWeight.bold, letterSpacing: -0.5)),
        pw.SizedBox(height: 6),
        pw.Text([cv.email, cv.phone, cv.location, cv.links].where((e) => e.isNotEmpty).join(' · '),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
        pw.SizedBox(height: 24),

        _minimalSection('Summary', cv.summary, accent),
        _minimalListSection<Experience>('Experience', cv.experiences, accent, (e) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Text('${e.jobTitle} • ${e.company}',
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text(e.dateRange, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ]),
            if (e.description.isNotEmpty) pw.Padding(
              padding: const pw.EdgeInsets.only(top: 2),
              child: pw.Text(e.description, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8))),
          ],
        )),
        _minimalListSection<Education>('Education', cv.educations, accent, (e) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text('${e.degree} — ${e.institution}',
                style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text(e.dateRange, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          ],
        )),
        _minimalListSection<Project>('Projects', cv.projects, accent, (p) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(p.title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            if (p.techStack.isNotEmpty)
              pw.Text(p.techStack, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            if (p.description.isNotEmpty)
              pw.Text(p.description, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
          ],
        )),
        if (cv.skills.isNotEmpty) ...[
          _minimalHeader('Skills', accent),
          pw.Text(cv.skills, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
          pw.SizedBox(height: 12),
        ],
        _minimalListSection<Reference>('References', cv.references, accent, (r) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text(r.name, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
            pw.Text('${r.title}, ${r.organization}  |  ${r.contactInfo}',
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
          ],
        )),
        if (cv.researches.isNotEmpty) 
          _minimalListSection<Research>('Research', cv.researches, accent, (r) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(r.title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(r.role, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ],
          )),
        if (cv.activities.isNotEmpty)
          _minimalListSection<Activity>('Activities', cv.activities, accent, (a) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(a.role, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.Text(a.organization, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
            ],
          )),
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _minimalSection(String title, String content, PdfColor accent) {
    if (content.isEmpty) return pw.SizedBox();
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      _minimalHeader(title, accent),
      pw.Text(content, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
      pw.SizedBox(height: 12),
    ]);
  }

  static pw.Widget _minimalListSection<T>(String title, List<T> items, PdfColor accent,
      pw.Widget Function(T) builder) {
    if (items.isEmpty) return pw.SizedBox();
    return pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
      _minimalHeader(title, accent),
      ...items.map((item) => pw.Padding(
        padding: const pw.EdgeInsets.only(bottom: 8), child: builder(item))),
      pw.SizedBox(height: 6),
    ]);
  }

  static pw.Widget _minimalHeader(String title, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6),
      child: pw.Stack(children: [
        pw.Container(height: 1, color: PdfColors.grey300, margin: const pw.EdgeInsets.only(top: 8)),
        pw.Container(
          padding: const pw.EdgeInsets.only(right: 10),
          color: PdfColors.white,
          child: pw.Text(title.toUpperCase(),
              style: pw.TextStyle(fontSize: 9, fontWeight: pw.FontWeight.bold,
                  color: accent, letterSpacing: 1.5)),
        ),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 4 — Executive (serif-style, deep navy, premium)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateExecutive(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    const navy = PdfColor.fromInt(0xFF0F2044);
    const gold = PdfColor.fromInt(0xFF92400E);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 40, vertical: 36),
      build: (ctx) => [
        // Full-width name banner
        pw.Container(
          width: double.infinity,
          padding: const pw.EdgeInsets.symmetric(vertical: 18, horizontal: 24),
          color: navy,
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.center, children: [
            pw.Text(cv.name.isEmpty ? 'YOUR NAME' : cv.name.toUpperCase(),
                style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white, letterSpacing: 3)),
            pw.SizedBox(height: 6),
            pw.Text([cv.email, cv.phone, cv.location].where((e) => e.isNotEmpty).join('   |   '),
                style: pw.TextStyle(fontSize: 9, color: const PdfColor(1, 1, 1, 0.7))),
            if (cv.links.isNotEmpty)
              pw.Text(cv.links, style: pw.TextStyle(fontSize: 9, color: const PdfColor(0.729, 0.792, 0.851, 1))),
          ]),
        ),
        pw.SizedBox(height: 18),

        if (cv.summary.isNotEmpty) ...[
          _execTitle('EXECUTIVE SUMMARY', navy, gold),
          pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2.2)),
          pw.SizedBox(height: 14),
        ],
        if (cv.experiences.isNotEmpty) ...[
          _execTitle('PROFESSIONAL EXPERIENCE', navy, gold),
          ...cv.experiences.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 10),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(e.jobTitle, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: navy)),
                pw.Text(e.dateRange, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
              ]),
              pw.Text(e.company, style: pw.TextStyle(fontSize: 10, color: gold)),
              pw.SizedBox(height: 3),
              if (e.description.isNotEmpty) pw.Text(e.description,
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.educations.isNotEmpty) ...[
          _execTitle('EDUCATION', navy, gold),
          ...cv.educations.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(e.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: navy)),
                pw.Text(e.institution, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text(e.dateRange, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
                if (e.result.isNotEmpty) pw.Text(e.result, style: const pw.TextStyle(fontSize: 10)),
              ]),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
        if (cv.skills.isNotEmpty || cv.languages.isNotEmpty) ...[
          _execTitle('COMPETENCIES', navy, gold),
          if (cv.skills.isNotEmpty) pw.Text('Core Skills:  ${cv.skills}',
              style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
          if (cv.languages.isNotEmpty) pw.Text('Languages:  ${cv.languages}',
              style: const pw.TextStyle(fontSize: 10)),
          pw.SizedBox(height: 8),
        ],
        if (cv.projects.isNotEmpty) ...[
          _execTitle('KEY PROJECTS', navy, gold),
          ...cv.projects.map((p) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(p.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: navy)),
              if (p.techStack.isNotEmpty) pw.Text(p.techStack, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
              if (p.description.isNotEmpty) pw.Text(p.description, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
            ]),
          )),
          pw.SizedBox(height: 6),
        ],
                if (cv.researches.isNotEmpty) ...[
                  _execTitle('RESEARCH & PUBLICATIONS', navy, gold),
                  ...cv.researches.map((r) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(r.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: navy)),
                      pw.Text(r.role, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
                    ]),
                  )),
                ],
                if (cv.references.isNotEmpty) ...[
                  _execTitle('REFERENCES', navy, gold),
                  ...cv.references.map((r) => pw.Padding(
                    padding: const pw.EdgeInsets.only(bottom: 6),
                    child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                      pw.Text(r.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: navy)),
                      pw.Text('${r.title}, ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
                      pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey600)),
                    ]),
                  )),
                ],
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _execTitle(String title, PdfColor navy, PdfColor gold) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8, top: 4),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold,
            color: navy, letterSpacing: 1.5)),
        pw.Container(height: 2, color: gold, margin: const pw.EdgeInsets.only(top: 3, bottom: 6)),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 5 — Creative (rose/purple header band)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateCreative(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    const headerColor = PdfColor.fromInt(0xFF6B21A8);
    const accentColor = PdfColor.fromInt(0xFFBE123C);

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => [
        pw.Stack(children: [
          pw.Container(
            width: double.infinity,
            height: 110,
            color: headerColor,
            padding: const pw.EdgeInsets.fromLTRB(30, 20, 30, 16),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, mainAxisAlignment: pw.MainAxisAlignment.center, children: [
              pw.Text(cv.name.isEmpty ? 'Your Name' : cv.name,
                  style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold, color: PdfColors.white)),
              pw.SizedBox(height: 6),
              pw.Text([cv.email, cv.phone, cv.location, cv.links].where((e) => e.isNotEmpty).join('  |  '),
                  style: pw.TextStyle(fontSize: 9, color: const PdfColor(1, 1, 1, 0.7))),
            ]),
          ),
        ]),
        pw.SizedBox(height: 4),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(30, 16, 30, 30),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            if (cv.summary.isNotEmpty) ...[
              _creativeSection('About Me', accentColor),
              pw.Text(cv.summary, style: pw.TextStyle(fontSize: 10, lineSpacing: 2)),
              pw.SizedBox(height: 14),
            ],
            if (cv.experiences.isNotEmpty) ...[
              _creativeSection('Work Experience', accentColor),
              ...cv.experiences.map((e) => _creativeEntry(e.jobTitle, e.company, e.dateRange, e.description, headerColor)),
              pw.SizedBox(height: 8),
            ],
            if (cv.educations.isNotEmpty) ...[
              _creativeSection('Education', accentColor),
              ...cv.educations.map((e) => _creativeEntry(e.degree, e.institution, e.dateRange, 'GPA: ${e.result}', headerColor)),
              pw.SizedBox(height: 8),
            ],
            if (cv.projects.isNotEmpty) ...[
              _creativeSection('Projects', accentColor),
              ...cv.projects.map((p) => _creativeEntry(p.title, p.techStack, '', p.description, headerColor)),
              pw.SizedBox(height: 8),
            ],
            if (cv.skills.isNotEmpty) ...[
              _creativeSection('Skills', accentColor),
              pw.Wrap(spacing: 6, runSpacing: 4, children: cv.skills.split(',').map((s) =>
                pw.Container(
                  padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: pw.BoxDecoration(
                    color: headerColor,
                    borderRadius: const pw.BorderRadius.all(pw.Radius.circular(12)),
                  ),
                  child: pw.Text(s.trim(), style: const pw.TextStyle(fontSize: 9, color: PdfColors.white)),
                )
              ).toList()),
              pw.SizedBox(height: 14),
            ],
            if (cv.references.isNotEmpty) ...[
              _creativeSection('References', accentColor),
              ...cv.references.map((r) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(r.name, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: headerColor)),
                  pw.Text('${r.title}  |  ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
                ]),
              )),
            ],
          ]),
        ),
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _creativeSection(String title, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8),
      child: pw.Row(children: [
        pw.Container(width: 4, height: 16, color: accent,
            margin: const pw.EdgeInsets.only(right: 8)),
        pw.Text(title, style: pw.TextStyle(fontSize: 12, fontWeight: pw.FontWeight.bold, color: accent)),
      ]),
    );
  }

  static pw.Widget _creativeEntry(String title, String sub, String date, String desc, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8, left: 12),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
          pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: accent)),
          if (date.isNotEmpty) pw.Text(date, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
        ]),
        if (sub.isNotEmpty) pw.Text(sub, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey700)),
        if (desc.isNotEmpty) pw.Text(desc, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 6 — Academic (research-focused, dense, Chicago style)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateAcademic(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.symmetric(horizontal: 54, vertical: 44),
      build: (ctx) => [
        pw.Center(child: pw.Text(cv.name.isEmpty ? 'Your Name' : cv.name,
            style: pw.TextStyle(fontSize: 18, fontWeight: pw.FontWeight.bold))),
        pw.SizedBox(height: 4),
        pw.Center(child: pw.Text(
          [cv.email, cv.phone, cv.location].where((e) => e.isNotEmpty).join('   |   '),
          style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
        if (cv.links.isNotEmpty) pw.Center(child: pw.Text(cv.links,
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700))),
        pw.SizedBox(height: 6),
        pw.Divider(thickness: 0.5),
        pw.SizedBox(height: 10),

        if (cv.summary.isNotEmpty) ...[
          _academicTitle('ACADEMIC PROFILE'),
          pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2.5)),
          pw.SizedBox(height: 12),
        ],
        if (cv.researches.isNotEmpty) ...[
          _academicTitle('PUBLICATIONS & RESEARCH'),
          ...cv.researches.map((r) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(r.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text(r.role, style: pw.TextStyle(fontSize: 10, fontStyle: pw.FontStyle.italic)),
              if (r.description.isNotEmpty) pw.Text(r.description,
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
            ]),
          )),
          pw.SizedBox(height: 8),
        ],
        if (cv.educations.isNotEmpty) ...[
          _academicTitle('EDUCATION'),
          ...cv.educations.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                pw.Text(e.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text(e.institution, style: const pw.TextStyle(fontSize: 10)),
              ]),
              pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.end, children: [
                pw.Text(e.dateRange, style: const pw.TextStyle(fontSize: 10)),
                if (e.result.isNotEmpty) pw.Text('CGPA: ${e.result}', style: const pw.TextStyle(fontSize: 10)),
              ]),
            ]),
          )),
          pw.SizedBox(height: 8),
        ],
        if (cv.experiences.isNotEmpty) ...[
          _academicTitle('PROFESSIONAL EXPERIENCE'),
          ...cv.experiences.map((e) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 8),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
                pw.Text(e.dateRange, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic)),
              ]),
              pw.Text(e.company, style: const pw.TextStyle(fontSize: 10)),
              if (e.description.isNotEmpty) pw.Text(e.description,
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
            ]),
          )),
          pw.SizedBox(height: 8),
        ],
        if (cv.skills.isNotEmpty) ...[
          _academicTitle('TECHNICAL SKILLS'),
          pw.Text(cv.skills, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
          pw.SizedBox(height: 8),
        ],
        if (cv.certifications.isNotEmpty) ...[
          _academicTitle('CERTIFICATIONS'),
          ...cv.certifications.map((c) => pw.Text(
            '${c.year}  ${c.title}, ${c.issuer}',
            style: const pw.TextStyle(fontSize: 10, lineSpacing: 2))),
          pw.SizedBox(height: 8),
        ],
        if (cv.references.isNotEmpty) ...[
          _academicTitle('REFERENCES'),
          ...cv.references.map((r) => pw.Padding(
            padding: const pw.EdgeInsets.only(bottom: 6),
            child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
              pw.Text(r.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10)),
              pw.Text('${r.title}, ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
              pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 10)),
            ]),
          )),
        ],
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _academicTitle(String title) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 6, top: 4),
      child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Text(title, style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, letterSpacing: 0.8)),
        pw.Divider(thickness: 0.5, color: PdfColors.grey600),
        pw.SizedBox(height: 2),
      ]),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 7 — Tech (dark header, monospace stack labels)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateTech(CVModel cv) async {
    final pdf = pw.Document(theme: pw.ThemeData.withFont(
      base: pw.Font.helvetica(),
      bold: pw.Font.helveticaBold(),
      italic: pw.Font.helveticaOblique(),
    ));
    const darkBg = PdfColor.fromInt(0xFF0F172A); // Slate 900
    const codeGreen = PdfColor.fromInt(0xFF059669); // CV Studio Emerald

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: pw.EdgeInsets.zero,
      build: (ctx) => [
        pw.Container(
          width: double.infinity,
          color: darkBg,
          padding: const pw.EdgeInsets.fromLTRB(32, 24, 32, 20),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            pw.Text('> ${cv.name.isEmpty ? "Your Name" : cv.name}',
                style: pw.TextStyle(fontSize: 22, fontWeight: pw.FontWeight.bold, color: codeGreen)),
            pw.SizedBox(height: 4),
            pw.Text([cv.email, cv.phone, cv.location, cv.links].where((e) => e.isNotEmpty).join('  |  '),
                style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey400)),
          ]),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.fromLTRB(32, 20, 32, 32),
          child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
            if (cv.summary.isNotEmpty) ...[
              _techSection('// SUMMARY', codeGreen),
              pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2)),
              pw.SizedBox(height: 14),
            ],
            if (cv.skills.isNotEmpty) ...[
              _techSection('// TECH STACK', codeGreen),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                color: const PdfColor.fromInt(0xFFF3F4F6),
                child: pw.Text(cv.skills,
                    style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey800)),
              ),
              pw.SizedBox(height: 14),
            ],
            if (cv.experiences.isNotEmpty) ...[
              _techSection('// EXPERIENCE', codeGreen),
              ...cv.experiences.map((e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 10),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
                    pw.Text(e.jobTitle, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11, color: darkBg)),
                    pw.Text(e.dateRange, style: const pw.TextStyle(fontSize: 9, color: PdfColors.grey600)),
                  ]),
                  pw.Text('@ ${e.company}', style: pw.TextStyle(fontSize: 10, color: codeGreen)),
                  if (e.description.isNotEmpty) pw.Text(e.description,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
                ]),
              )),
              pw.SizedBox(height: 6),
            ],
            if (cv.projects.isNotEmpty) ...[
              _techSection('// PROJECTS', codeGreen),
              ...cv.projects.map((p) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(p.title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  if (p.techStack.isNotEmpty) pw.Container(
                    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: pw.BoxDecoration(
                      color: PdfColors.grey100,
                      borderRadius: const pw.BorderRadius.all(pw.Radius.circular(2)),
                      border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
                    ),
                    child: pw.Text(p.techStack, style: pw.TextStyle(fontSize: 8, fontWeight: pw.FontWeight.bold, color: darkBg))),
                  if (p.description.isNotEmpty) pw.Text(p.description,
                      style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
                ]),
              )),
              pw.SizedBox(height: 6),
            ],
            if (cv.educations.isNotEmpty) ...[
              _techSection('// EDUCATION', codeGreen),
              ...cv.educations.map((e) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(e.degree, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.Text('${e.institution}  |  ${e.dateRange}', style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                  if (e.result.isNotEmpty) pw.Text('CGPA: ${e.result}', style: const pw.TextStyle(fontSize: 10)),
                ]),
              )),
              pw.SizedBox(height: 6),
            ],
            if (cv.certifications.isNotEmpty) ...[
              _techSection('// CERTIFICATIONS', codeGreen),
              ...cv.certifications.map((c) => pw.Text('[ ${c.year} ] ${c.title} — ${c.issuer}',
                  style: const pw.TextStyle(fontSize: 10, lineSpacing: 2))),
              pw.SizedBox(height: 8),
            ],
            if (cv.references.isNotEmpty) ...[
              _techSection('// REFERENCES', codeGreen),
              ...cv.references.map((r) => pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 6),
                child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
                  pw.Text(r.name, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
                  pw.Text('${r.title}, ${r.organization}', style: const pw.TextStyle(fontSize: 10)),
                  pw.Text(r.contactInfo, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
                ]),
              )),
            ],
          ]),
        ),
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _techSection(String title, PdfColor green) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 8, top: 4),
      child: pw.Text(title, style: pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold, color: green)),
    );
  }

  // ────────────────────────────────────────────────────────────────
  // TEMPLATE 8 — Timeline (left vertical bar, dot markers)
  // ────────────────────────────────────────────────────────────────
  static Future<Uint8List> _generateTimeline(CVModel cv) async {
    final pdf = pw.Document();
    const accent = PdfColor.fromInt(0xFFBE123C); // rose accent for timeline

    pdf.addPage(pw.MultiPage(
      pageFormat: PdfPageFormat.a4,
      margin: const pw.EdgeInsets.all(36),
      build: (ctx) => [
        pw.Text(cv.name.isEmpty ? 'Your Name' : cv.name,
            style: pw.TextStyle(fontSize: 26, fontWeight: pw.FontWeight.bold, letterSpacing: -0.5)),
        pw.SizedBox(height: 4),
        pw.Text([cv.email, cv.phone, cv.location, cv.links].where((e) => e.isNotEmpty).join(' · '),
            style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
        pw.SizedBox(height: 10),
        if (cv.summary.isNotEmpty) ...[
          pw.Text(cv.summary, style: const pw.TextStyle(fontSize: 10, lineSpacing: 2, color: PdfColors.grey800)),
          pw.SizedBox(height: 16),
        ],
        pw.Divider(thickness: 1, color: accent),
        pw.SizedBox(height: 12),
        if (cv.experiences.isNotEmpty) ...[
          pw.Text('EXPERIENCE', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent, letterSpacing: 1.5)),
          pw.SizedBox(height: 6),
          ...cv.experiences.map((e) => _timelineEntry(e.jobTitle, e.company, e.dateRange, e.description, accent)),
          pw.SizedBox(height: 8),
        ],
        if (cv.educations.isNotEmpty) ...[
          pw.Text('EDUCATION', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent, letterSpacing: 1.5)),
          pw.SizedBox(height: 6),
          ...cv.educations.map((e) => _timelineEntry(e.degree, e.institution, e.dateRange, e.result.isNotEmpty ? 'GPA: ${e.result}' : '', accent)),
          pw.SizedBox(height: 8),
        ],
        if (cv.projects.isNotEmpty) ...[
          pw.Text('PROJECTS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent, letterSpacing: 1.5)),
          pw.SizedBox(height: 6),
          ...cv.projects.map((p) => _timelineEntry(p.title, p.techStack, '', p.description, accent)),
          pw.SizedBox(height: 8),
        ],
        if (cv.skills.isNotEmpty) ...[
          pw.Text('SKILLS', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent, letterSpacing: 1.5)),
          pw.SizedBox(height: 6),
          pw.Padding(
            padding: const pw.EdgeInsets.only(left: 18),
            child: pw.Text(cv.skills, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
          ),
          pw.SizedBox(height: 8),
        ],
        if (cv.references.isNotEmpty) ...[
          pw.Text('REFERENCES', style: pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold, color: accent, letterSpacing: 1.5)),
          pw.SizedBox(height: 6),
          ...cv.references.map((r) => _timelineEntry(r.name, '${r.title}, ${r.organization}', '', r.contactInfo, accent)),
        ],
      ],
    ));
    return pdf.save();
  }

  static pw.Widget _timelineEntry(String title, String sub, String date, String desc, PdfColor accent) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Row(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
        pw.Column(children: [
          pw.Container(width: 8, height: 8, decoration: pw.BoxDecoration(
            color: accent, shape: pw.BoxShape.circle)),
          pw.Container(width: 1.5, height: 40, color: const PdfColor.fromInt(0xFFD1D5DB)),
        ]),
        pw.SizedBox(width: 10),
        pw.Expanded(child: pw.Column(crossAxisAlignment: pw.CrossAxisAlignment.start, children: [
          pw.Row(mainAxisAlignment: pw.MainAxisAlignment.spaceBetween, children: [
            pw.Text(title, style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            if (date.isNotEmpty) pw.Text(date, style: pw.TextStyle(fontSize: 9, fontStyle: pw.FontStyle.italic, color: PdfColors.grey600)),
          ]),
          if (sub.isNotEmpty) pw.Text(sub, style: const pw.TextStyle(fontSize: 10, color: PdfColors.grey700)),
          if (desc.isNotEmpty) pw.Text(desc, style: const pw.TextStyle(fontSize: 10, lineSpacing: 1.8)),
        ])),
      ]),
    );
  }
}
