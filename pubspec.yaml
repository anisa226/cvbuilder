// ── CV Data Model — with Supabase JSON serialization ──────────────────────────

class Experience {
  final String jobTitle;
  final String company;
  final String dateRange;
  final String description;

  Experience(this.jobTitle, this.company, this.dateRange, this.description);

  Map<String, dynamic> toJson() => {
        'jobTitle': jobTitle,
        'company': company,
        'dateRange': dateRange,
        'description': description,
      };

  factory Experience.fromJson(Map<String, dynamic> j) => Experience(
        j['jobTitle'] as String? ?? '',
        j['company'] as String? ?? '',
        j['dateRange'] as String? ?? '',
        j['description'] as String? ?? '',
      );
}

class Education {
  final String degree;
  final String institution;
  final String dateRange;
  final String result;

  Education(this.degree, this.institution, this.dateRange, this.result);

  Map<String, dynamic> toJson() => {
        'degree': degree,
        'institution': institution,
        'dateRange': dateRange,
        'result': result,
      };

  factory Education.fromJson(Map<String, dynamic> j) => Education(
        j['degree'] as String? ?? '',
        j['institution'] as String? ?? '',
        j['dateRange'] as String? ?? '',
        j['result'] as String? ?? '',
      );
}

class Research {
  final String title;
  final String role;
  final String description;

  Research(this.title, this.role, this.description);

  Map<String, dynamic> toJson() =>
      {'title': title, 'role': role, 'description': description};

  factory Research.fromJson(Map<String, dynamic> j) => Research(
        j['title'] as String? ?? '',
        j['role'] as String? ?? '',
        j['description'] as String? ?? '',
      );
}

class Project {
  final String title;
  final String techStack;
  final String description;

  Project(this.title, this.techStack, this.description);

  Map<String, dynamic> toJson() =>
      {'title': title, 'techStack': techStack, 'description': description};

  factory Project.fromJson(Map<String, dynamic> j) => Project(
        j['title'] as String? ?? '',
        j['techStack'] as String? ?? '',
        j['description'] as String? ?? '',
      );
}

class Certification {
  final String title;
  final String issuer;
  final String year;

  Certification(this.title, this.issuer, this.year);

  Map<String, dynamic> toJson() =>
      {'title': title, 'issuer': issuer, 'year': year};

  factory Certification.fromJson(Map<String, dynamic> j) => Certification(
        j['title'] as String? ?? '',
        j['issuer'] as String? ?? '',
        j['year'] as String? ?? '',
      );
}

class Activity {
  final String role;
  final String organization;
  final String description;

  Activity(this.role, this.organization, this.description);

  Map<String, dynamic> toJson() =>
      {'role': role, 'organization': organization, 'description': description};

  factory Activity.fromJson(Map<String, dynamic> j) => Activity(
        j['role'] as String? ?? '',
        j['organization'] as String? ?? '',
        j['description'] as String? ?? '',
      );
}

class Reference {
  final String name;
  final String title;
  final String organization;
  final String contactInfo;

  Reference(this.name, this.title, this.organization, this.contactInfo);

  Map<String, dynamic> toJson() => {
        'name': name,
        'title': title,
        'organization': organization,
        'contactInfo': contactInfo,
      };

  factory Reference.fromJson(Map<String, dynamic> j) => Reference(
        j['name'] as String? ?? '',
        j['title'] as String? ?? '',
        j['organization'] as String? ?? '',
        j['contactInfo'] as String? ?? '',
      );
}

// ── Main CV Model ─────────────────────────────────────────────────────────────

class CVModel {
  final String name;
  final String email;
  final String phone;
  final String location;
  final String links;
  final String summary;
  final String skills;
  final String languages;

  final List<Experience> experiences;
  final List<Education> educations;
  final List<Research> researches;
  final List<Project> projects;
  final List<Certification> certifications;
  final List<Activity> activities;
  final List<Reference> references;

  const CVModel({
    required this.name,
    required this.email,
    required this.phone,
    required this.location,
    required this.links,
    required this.summary,
    required this.skills,
    required this.languages,
    required this.experiences,
    required this.educations,
    required this.researches,
    required this.projects,
    required this.certifications,
    required this.activities,
    required this.references,
  });

  // ── Empty factory ─────────────────────────────────────────────
  factory CVModel.empty() => const CVModel(
        name: '', email: '', phone: '', location: '',
        links: '', summary: '', skills: '', languages: '',
        experiences: [], educations: [], researches: [],
        projects: [], certifications: [], activities: [], references: [],
      );

  // ── Serialization ─────────────────────────────────────────────
  Map<String, dynamic> toJson() => {
        'profile': {
          'name': name,
          'email': email,
          'phone': phone,
          'location': location,
          'links': links,
          'summary': summary,
          'skills': skills,
          'languages': languages,
        },
        'experiences':    experiences.map((e) => e.toJson()).toList(),
        'educations':     educations.map((e) => e.toJson()).toList(),
        'researches':     researches.map((e) => e.toJson()).toList(),
        'projects':       projects.map((e) => e.toJson()).toList(),
        'certifications': certifications.map((e) => e.toJson()).toList(),
        'activities':     activities.map((e) => e.toJson()).toList(),
        'references':     references.map((e) => e.toJson()).toList(),
      };

  factory CVModel.fromJson(Map<String, dynamic> j) {
    final profile = (j['profile'] as Map<String, dynamic>?) ?? {};

    List<T> parseList<T>(String key, T Function(Map<String, dynamic>) fn) {
      final raw = j[key];
      if (raw == null) return [];
      return (raw as List).map((e) => fn(e as Map<String, dynamic>)).toList();
    }

    return CVModel(
      name:      profile['name'] as String? ?? '',
      email:     profile['email'] as String? ?? '',
      phone:     profile['phone'] as String? ?? '',
      location:  profile['location'] as String? ?? '',
      links:     profile['links'] as String? ?? '',
      summary:   profile['summary'] as String? ?? '',
      skills:    profile['skills'] as String? ?? '',
      languages: profile['languages'] as String? ?? '',
      experiences:    parseList('experiences', Experience.fromJson),
      educations:     parseList('educations', Education.fromJson),
      researches:     parseList('researches', Research.fromJson),
      projects:       parseList('projects', Project.fromJson),
      certifications: parseList('certifications', Certification.fromJson),
      activities:     parseList('activities', Activity.fromJson),
      references:     parseList('references_list', Reference.fromJson),
    );
  }

  // ── Completeness score 0-100 ──────────────────────────────────
  int completeness() {
    int s = 0;
    if (name.isNotEmpty)     s += 15;
    if (email.isNotEmpty)    s += 10;
    if (summary.isNotEmpty)  s += 15;
    if (skills.isNotEmpty)   s += 10;
    if (experiences.isNotEmpty) s += 20;
    if (educations.isNotEmpty)  s += 15;
    if (projects.isNotEmpty)    s += 10;
    if (references.isNotEmpty)  s += 5;
    return s.clamp(0, 100);
  }
}
