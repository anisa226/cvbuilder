import 'package:supabase_flutter/supabase_flutter.dart';
import 'cv_model.dart';

class ResumeRecord {
  final String id;
  final String title;
  final String templateId;
  final int completeness;
  final CVModel cvData;
  final DateTime updatedAt;

  const ResumeRecord({
    required this.id,
    required this.title,
    required this.templateId,
    required this.completeness,
    required this.cvData,
    required this.updatedAt,
  });

  factory ResumeRecord.fromJson(Map<String, dynamic> j) {
    // Supabase returns JSONB columns as Map<String, dynamic> already
    final cvData = CVModel.fromJson(j);
    return ResumeRecord(
      id: j['id'] as String,
      title: j['title'] as String? ?? 'Untitled Resume',
      templateId: j['template_id'] as String? ?? 'classic',
      completeness: j['completeness'] as int? ?? 0,
      cvData: cvData,
      updatedAt: DateTime.parse(j['updated_at'] as String),
    );
  }
}

class ResumeService {
  final SupabaseClient _client;
  ResumeService(this._client);

  String get _uid => _client.auth.currentUser!.id;

  // ── Create a new blank resume ─────────────────────────────────
  Future<String> createResume({String title = 'My Resume'}) async {
    final response = await _client.from('resumes').insert({
      'user_id': _uid,
      'title': title,
      'template_id': 'classic',
      'completeness': 0,
      'profile': {},
      'experiences': [],
      'educations': [],
      'researches': [],
      'projects': [],
      'certifications': [],
      'activities': [],
      'references_list': [],
    }).select('id').single();

    return response['id'] as String;
  }

  // ── Save / update a resume ────────────────────────────────────
  Future<void> saveResume(String resumeId, CVModel cv, {String? title, String? templateId}) async {
    final json = cv.toJson();
    await _client.from('resumes').update({
      'title':       title ?? (cv.name.isNotEmpty ? cv.name : 'My Resume'),
      'template_id': templateId ?? 'classic',
      'completeness': cv.completeness(),
      'profile':      json['profile'],
      'experiences':  json['experiences'],
      'educations':   json['educations'],
      'researches':   json['researches'],
      'projects':     json['projects'],
      'certifications': json['certifications'],
      'activities':   json['activities'],
      'references_list': json['references'],
      'updated_at':   DateTime.now().toIso8601String(),
    }).eq('id', resumeId).eq('user_id', _uid);
  }

  // ── Update only template ──────────────────────────────────────
  Future<void> updateTemplate(String resumeId, String templateId) async {
    await _client.from('resumes')
        .update({'template_id': templateId})
        .eq('id', resumeId)
        .eq('user_id', _uid);
  }

  // ── Fetch all resumes for current user ────────────────────────
  Future<List<ResumeRecord>> fetchResumes() async {
    final rows = await _client
        .from('resumes')
        .select()
        .eq('user_id', _uid)
        .order('updated_at', ascending: false);

    return rows.map((r) => ResumeRecord.fromJson(r)).toList();
  }

  // ── Fetch single resume ───────────────────────────────────────
  Future<ResumeRecord?> fetchResume(String resumeId) async {
    final row = await _client
        .from('resumes')
        .select()
        .eq('id', resumeId)
        .eq('user_id', _uid)
        .maybeSingle();

    if (row == null) return null;
    return ResumeRecord.fromJson(row);
  }

  // ── Delete resume ─────────────────────────────────────────────
  Future<void> deleteResume(String resumeId) async {
    await _client.from('resumes')
        .delete()
        .eq('id', resumeId)
        .eq('user_id', _uid);
  }

  // ── Rename resume ─────────────────────────────────────────────
  Future<void> renameResume(String resumeId, String title) async {
    await _client.from('resumes')
        .update({'title': title})
        .eq('id', resumeId)
        .eq('user_id', _uid);
  }
}
