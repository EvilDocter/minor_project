import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});
  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _userCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  String _role = 'general';
  String? _msg;

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthService>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text('Sign up')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _userCtrl,
              decoration: const InputDecoration(labelText: 'Username'),
            ),
            TextField(
              controller: _passCtrl,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            DropdownButtonFormField<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'general', child: Text('General User')),
                DropdownMenuItem(value: 'paramedic', child: Text('Paramedic')),
              ],
              onChanged: (v) => setState(() => _role = v ?? 'general'),
              decoration: const InputDecoration(labelText: 'Role'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () async {
                final ok = await auth.signup(
                  _userCtrl.text.trim(),
                  _passCtrl.text.trim(),
                  _role,
                );
                setState(
                  () => _msg = ok
                      ? 'Signup success. Return to login.'
                      : 'Signup failed (maybe username exists).',
                );
              },
              child: const Text('Create account'),
            ),
            if (_msg != null)
              Padding(padding: const EdgeInsets.all(8), child: Text(_msg!)),
          ],
        ),
      ),
    );
  }
}
