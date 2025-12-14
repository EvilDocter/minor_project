class UserRecord {
  final String id;
  final String name;
  final String email;
  final String password;

  final int age;
  final String sex;
  final String bloodGroup;

  final String allergies;
  final String medicalHistory;

  final String emergencyContactName;
  final String emergencyContactNumber;

  /// ✅ This fixes your paramedic error
  final String? medicalDocumentPath;

  UserRecord({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.age,
    required this.sex,
    required this.bloodGroup,
    required this.allergies,
    required this.medicalHistory,
    required this.emergencyContactName,
    required this.emergencyContactNumber,
    this.medicalDocumentPath,
  });

  // ---------- COPY WITH (for updates) ----------
  UserRecord copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    int? age,
    String? sex,
    String? bloodGroup,
    String? allergies,
    String? medicalHistory,
    String? emergencyContactName,
    String? emergencyContactNumber,
    String? medicalDocumentPath,
  }) {
    return UserRecord(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      allergies: allergies ?? this.allergies,
      medicalHistory: medicalHistory ?? this.medicalHistory,
      emergencyContactName: emergencyContactName ?? this.emergencyContactName,
      emergencyContactNumber:
          emergencyContactNumber ?? this.emergencyContactNumber,
      medicalDocumentPath: medicalDocumentPath ?? this.medicalDocumentPath,
    );
  }
}
