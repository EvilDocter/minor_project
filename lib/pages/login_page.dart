import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'signup_page.dart';
import 'paramedic_home.dart';
import 'general_home.dart';
import 'admin_page.dart';
import '../services/db_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _role = 'general';
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String? _error;
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('FirstResponderID')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    title: const Text('General'),
                    value: 'general',
                    groupValue: _role,
                    onChanged: (v) {
                      setState(() => _role = v as String);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Paramedic'),
                    value: 'paramedic',
                    groupValue: _role,
                    onChanged: (v) {
                      setState(() => _role = v as String);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    title: const Text('Admin'),
                    value: 'admin',
                    groupValue: _role,
                    onChanged: (v) {
                      setState(() => _role = v as String);
                    },
                  ),
                ),
              ],
            ),
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: _busy
                  ? null
                  : () async {
                      setState(() {
                        _busy = true;
                        _error = null;
                      });
                      final ok = await auth.login(
                        _userCtrl.text.trim(),
                        _passCtrl.text.trim(),
                        _role,
                      );
                      setState(() {
                        _busy = false;
                      });
                      if (!ok) {
                        setState(() {
                          _error = 'Login failed';
                        });
                        return;
                      }
                      if (_role == 'paramedic') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ParamedicHome(),
                          ),
                        );
                      } else if (_role == 'general') {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const GeneralHome(),
                          ),
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminPage()),
                        );
                      }
                    },
              child: _busy
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text('Login'),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignupPage()),
                );
              },
              child: const Text('Sign up'),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.all(8),
                child: Text(_error!, style: const TextStyle(color: Colors.red)),
              ),
          ],
        ),
      ),
    );
  }
}
