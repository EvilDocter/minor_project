import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_record.dart';
import 'package:minor_project/services/auth_service.dart';

class UserSignupPage extends StatefulWidget {
  const UserSignupPage({super.key});

  @override
  State<UserSignupPage> createState() => _UserSignupPageState();
}

class _UserSignupPageState extends State<UserSignupPage> {
  final _formKey = GlobalKey<FormState>();

  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final passCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  final allergiesCtrl = TextEditingController();
  final historyCtrl = TextEditingController();
  final emergencyNameCtrl = TextEditingController();
  final emergencyNumberCtrl = TextEditingController();

  String sex = 'Male';
  String bloodGroup = 'A+';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field('Full Name', nameCtrl),
              _field('Email', emailCtrl),
              _field('Password', passCtrl, obscure: true),
              _field('Age', ageCtrl, number: true),
              const SizedBox(height: 12),
              _dropdown(
                'Sex',
                sex,
                ['Male', 'Female', 'Other'],
                (v) => setState(() => sex = v!),
              ),
              const SizedBox(height: 12),
              _dropdown(
                'Blood Group',
                bloodGroup,
                ['A+', 'A-', 'B+', 'B-', 'AB+', 'AB-', 'O+', 'O-'],
                (v) => setState(() => bloodGroup = v!),
              ),
              _field('Allergies', allergiesCtrl),
              _field('Medical History', historyCtrl),
              _field('Emergency Contact Name', emergencyNameCtrl),
              _field('Emergency Contact Number', emergencyNumberCtrl,
                  number: true),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: loading
                    ? null
                    : () async {
                        if (!_formKey.currentState!.validate()) return;

                        setState(() => loading = true);

                        final user = UserRecord(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          name: nameCtrl.text.trim(),
                          email: emailCtrl.text.trim(),
                          password: passCtrl.text.trim(),
                          age: int.parse(ageCtrl.text),
                          sex: sex,
                          bloodGroup: bloodGroup,
                          allergies: allergiesCtrl.text.trim(),
                          medicalHistory: historyCtrl.text.trim(),
                          emergencyContactName: emergencyNameCtrl.text.trim(),
                          emergencyContactNumber:
                              emergencyNumberCtrl.text.trim(),
                        );

                        final ok = await auth.signupUser(user);

                        setState(() => loading = false);

                        if (!mounted) return;

                        if (!ok) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('User already exists'),
                            ),
                          );
                          return;
                        }

                        Navigator.pop(context); // back to login
                      },
                child: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Create Account'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController c, {
    bool obscure = false,
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _dropdown(
    String label,
    String value,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: value,
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
