class VictimProfile {
  final int? id;
  final String victimId;
  final String name;
  final String phone;
  final String medicalNotes;
  final String allergies;
  final String medications;
  final String mockFingerprintToken;

  VictimProfile({
    this.id,
    required this.victimId,
    required this.name,
    required this.phone,
    required this.medicalNotes,
    required this.allergies,
    required this.medications,
    required this.mockFingerprintToken,
  });

  Map<String, dynamic> toMap() => {
        'id': id,
        'victim_id': victimId,
        'name': name,
        'phone': phone,
        'medical_notes': medicalNotes,
        'allergies': allergies,
        'medications': medications,
        'mock_fingerprint_token': mockFingerprintToken,
      };

  static VictimProfile fromMap(Map<String, dynamic> m) => VictimProfile(
        id: m['id'] as int?,
        victimId: m['victim_id'] as String,
        name: m['name'] as String,
        phone: m['phone'] as String,
        medicalNotes: m['medical_notes'] as String,
        allergies: m['allergies'] as String,
        medications: m['medications'] as String,
        mockFingerprintToken: m['mock_fingerprint_token'] as String,
      );
}
