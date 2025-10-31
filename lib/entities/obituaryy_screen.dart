class Obituary {
  final String fullName;
  final DateTime birthDate;
  final DateTime passingDate;
  final String? photoUrl;
  final String? shortTribute;
  final String? fullObituary;
  final String? section;
  final List<String>? galleryUrls;
  final List<Condolence>? condolences;

  const Obituary({
    required this.fullName,
    required this.birthDate,
    required this.passingDate,
    this.photoUrl,
    this.shortTribute,
    this.fullObituary,
    this.section,
    this.galleryUrls,
    this.condolences,
  });

  /// ✅ Factory: Create an Obituary from JSON
  factory Obituary.fromJson(Map<String, dynamic> json) {
    return Obituary(
      fullName: json['full_name'] ?? '',
      birthDate: DateTime.tryParse(json['birth_date'] ?? '') ?? DateTime.now(),
      passingDate:
          DateTime.tryParse(json['passing_date'] ?? '') ?? DateTime.now(),
      photoUrl: json['photo_url'],
      shortTribute: json['short_tribute'],
      fullObituary: json['full_obituary'],
      section: json['section'],
      galleryUrls: (json['gallery_urls'] as List?)
          ?.map((item) => item.toString())
          .toList(),
      condolences: (json['condolences'] as List?)
          ?.map((item) => Condolence.fromJson(item))
          .toList(),
    );
  }

  /// ✅ Convert to JSON (for saving or API requests)
  Map<String, dynamic> toJson() {
    return {
      'full_name': fullName,
      'birth_date': birthDate.toIso8601String(),
      'passing_date': passingDate.toIso8601String(),
      'photo_url': photoUrl,
      'short_tribute': shortTribute,
      'full_obituary': fullObituary,
      'section': section,
      'gallery_urls': galleryUrls,
      'condolences': condolences?.map((e) => e.toJson()).toList(),
    };
  }
}

/// 🕊️ Condolence sub-entity
class Condolence {
  final String name;
  final String message;
  final DateTime? date;

  const Condolence({
    required this.name,
    required this.message,
    this.date,
  });

  factory Condolence.fromJson(Map<String, dynamic> json) {
    return Condolence(
      name: json['name'] ?? '',
      message: json['message'] ?? '',
      date: DateTime.tryParse(json['date'] ?? ''),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'message': message,
      'date': date?.toIso8601String(),
    };
  }
}
