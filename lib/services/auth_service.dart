import 'package:flutter/foundation.dart';
import '../models/user_record.dart';
import 'db_service.dart';

enum AuthRole { none, user, paramedic, hospital }

class AuthService extends ChangeNotifier {
  UserRecord? _currentUser;
  AuthRole _role = AuthRole.none;

  UserRecord? get currentUser => _currentUser;
  AuthRole get role => _role;

  bool get isUser => _role == AuthRole.user;
  bool get isParamedic => _role == AuthRole.paramedic;
  bool get isHospital => _role == AuthRole.hospital;

  // ---------- USER SIGNUP ----------
  Future<bool> signupUser(UserRecord user) async {
    final ok = await DBService.createUser(user);
    if (!ok) return false;

    _currentUser = user;
    _role = AuthRole.user;
    notifyListeners();
    return true;
  }

  // ---------- USER LOGIN ----------
  Future<bool> loginUser(String email, String password) async {
    final user = await DBService.login(email, password);
    if (user == null) return false;

    _currentUser = user;
    _role = AuthRole.user;
    notifyListeners();
    return true;
  }

  // ---------- PARAMEDIC LOGIN ----------
  bool loginParamedic(String email, String password) {
    if (email == 'paramedic@frs.com' && password == '123456') {
      _currentUser = null;
      _role = AuthRole.paramedic;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ---------- HOSPITAL LOGIN ----------
  bool loginHospital(String email, String password) {
    if (email == 'hospital@frs.com' && password == '123456') {
      _currentUser = null;
      _role = AuthRole.hospital;
      notifyListeners();
      return true;
    }
    return false;
  }

  // ---------- UPDATE USER ----------
  Future<void> updateCurrentUser(UserRecord updatedUser) async {
    await DBService.updateUser(updatedUser);
    _currentUser = updatedUser;
    notifyListeners();
  }

  // ---------- LOGOUT ----------
  void logout() {
    _currentUser = null;
    _role = AuthRole.none;
    notifyListeners();
  }
}
