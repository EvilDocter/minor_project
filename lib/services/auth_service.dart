import 'package:flutter/material.dart';
import '../models/user.dart';
import 'db_service.dart';

class AuthService extends ChangeNotifier {
  UserModel? _user;
  UserModel? get user => _user;

  Future<bool> login(String username, String password, String role) async {
    final users = await DBService.getAllUsers();
    try {
      final found = users.firstWhere((u) => u.username == username && u.password == password && u.role == role);
      if (found.enabled == 0) return false;
      _user = found;
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> signup(String username, String password, String role) async {
    try {
      final newUser = UserModel(username: username, password: password, role: role);
      await DBService.insertUser(newUser);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    _user = null;
    notifyListeners();
  }
}
