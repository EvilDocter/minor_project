import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/user.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<UserModel> _users = [];

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final u = await DBService.getAllUsers();
    setState(() => _users = u);
  }

  void _delete(int id) async {
    await DBService.deleteUser(id);
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Admin - Users')),
      body: ListView.builder(
        itemCount: _users.length,
        itemBuilder: (_, i) {
          final user = _users[i];
          return ListTile(
            title: Text('${user.username} (${user.role})'),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _delete(user.id!),
            ),
          );
        },
      ),
    );
  }
}
