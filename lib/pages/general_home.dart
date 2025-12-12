import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/victim_profile.dart';
import 'victim_detail_page.dart';

class GeneralHome extends StatefulWidget {
  const GeneralHome({super.key});
  @override
  State<GeneralHome> createState() => _GeneralHomeState();
}

class _GeneralHomeState extends State<GeneralHome> {
  final _formKey = GlobalKey<FormState>();
  final _victimId = TextEditingController();
  final _name = TextEditingController();
  final _phone = TextEditingController();
  final _notes = TextEditingController();
  final _allergies = TextEditingController();
  final _meds = TextEditingController();
  final _token = TextEditingController();

  void _save() async {
    if (!_formKey.currentState!.validate()) return;
    final v = VictimProfile(
      victimId: _victimId.text.trim(),
      name: _name.text.trim(),
      phone: _phone.text.trim(),
      medicalNotes: _notes.text.trim(),
      allergies: _allergies.text.trim(),
      medications: _meds.text.trim(),
      mockFingerprintToken: _token.text.trim(),
    );
    await DBService.insertVictim(v);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Profile saved')));
    _clear();
  }

  void _clear() {
    _victimId.clear();
    _name.clear();
    _phone.clear();
    _notes.clear();
    _allergies.clear();
    _meds.clear();
    _token.clear();
  }

  void _viewFirst() async {
    final list = await DBService.getAllVictims();
    if (list.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No profiles')));
      return;
    }
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => VictimDetailPage(victim: list.first)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('General - Create Profile')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _victimId,
                decoration: const InputDecoration(labelText: 'Victim ID'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _name,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              TextFormField(
                controller: _phone,
                decoration: const InputDecoration(labelText: 'Phone'),
              ),
              TextFormField(
                controller: _notes,
                decoration: const InputDecoration(labelText: 'Medical Notes'),
              ),
              TextFormField(
                controller: _allergies,
                decoration: const InputDecoration(labelText: 'Allergies'),
              ),
              TextFormField(
                controller: _meds,
                decoration: const InputDecoration(labelText: 'Medications'),
              ),
              TextFormField(
                controller: _token,
                decoration: const InputDecoration(
                  labelText: 'Mock Fingerprint Token',
                ),
                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Profile'),
              ),
              const SizedBox(height: 8),
              OutlinedButton(
                onPressed: _viewFirst,
                child: const Text('View a Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
