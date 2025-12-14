import '../models/user_record.dart';
import '../models/hospital_case.dart';
import 'package:uuid/uuid.dart';

class DBService {
  static final List<UserRecord> _users = [];
  static final List<HospitalCase> _hospitalInbox = [];

  static const _uuid = Uuid();

  // ---------- CREATE USER ----------
  static Future<bool> createUser(UserRecord user) async {
    final exists = _users.any((u) => u.email == user.email);
    if (exists) return false;

    _users.add(user);
    return true;
  }

  // ---------- UPDATE USER ----------
  static Future<void> updateUser(UserRecord updatedUser) async {
    final index = _users.indexWhere((u) => u.id == updatedUser.id);
    if (index != -1) {
      _users[index] = updatedUser;
    }
  }

  // ---------- LOGIN ----------
  static Future<UserRecord?> login(
    String email,
    String password,
  ) async {
    try {
      return _users.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (_) {
      return null;
    }
  }

  // ---------- ALL USERS (PARAMEDIC) ----------
  static Future<List<UserRecord>> getAllUsers() async {
    return List.from(_users);
  }

  // ---------- UPLOAD MEDICAL FILE ----------
  static Future<void> uploadMedicalFile(
    String userId,
    String filePath,
  ) async {
    final index = _users.indexWhere((u) => u.id == userId);
    if (index != -1) {
      _users[index] = _users[index].copyWith(medicalDocumentPath: filePath);
    }
  }

  // ---------- SEND CASE TO HOSPITAL ----------
  static Future<void> sendCaseToHospital(
    UserRecord user,
    String riskLevel,
  ) async {
    _hospitalInbox.add(
      HospitalCase(
        id: _uuid.v4(), // ✅ safer unique ID
        user: user,
        riskLevel: riskLevel,
        time: DateTime.now(),
      ),
    );
  }

  // ---------- HOSPITAL FETCH ----------
  static Future<List<HospitalCase>> getHospitalCases() async {
    return List.from(_hospitalInbox);
  }

  // ---------- RESOLVE CASE ----------
  static Future<void> resolveCase(String caseId) async {
    _hospitalInbox.removeWhere((c) => c.id == caseId);
  }
}
