import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';

class UserProfilePage extends StatefulWidget {
  const UserProfilePage({super.key});

  @override
  State<UserProfilePage> createState() => _UserProfilePageState();
}

class _UserProfilePageState extends State<UserProfilePage> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController nameController;
  late TextEditingController ageController;
  late TextEditingController allergiesController;
  late TextEditingController medicalHistoryController;
  late TextEditingController emergencyNameController;
  late TextEditingController emergencyNumberController;

  String bloodGroup = 'A+';
  String sex = 'Male';

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthService>().currentUser!;

    nameController = TextEditingController(text: user.name);
    ageController = TextEditingController(text: user.age.toString());
    allergiesController = TextEditingController(text: user.allergies);
    medicalHistoryController = TextEditingController(text: user.medicalHistory);
    emergencyNameController =
        TextEditingController(text: user.emergencyContactName);
    emergencyNumberController =
        TextEditingController(text: user.emergencyContactNumber);

    bloodGroup = user.bloodGroup;
    sex = user.sex;
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();
    final user = auth.currentUser!;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              _field('Name', nameController),
              _field('Age', ageController, isNumber: true),
              const SizedBox(height: 12),
              _dropdown(
                label: 'Sex',
                value: sex,
                items: const ['Male', 'Female', 'Other'],
                onChanged: (v) => setState(() => sex = v!),
              ),
              const SizedBox(height: 12),
              _dropdown(
                label: 'Blood Group',
                value: bloodGroup,
                items: const [
                  'A+',
                  'A-',
                  'B+',
                  'B-',
                  'AB+',
                  'AB-',
                  'O+',
                  'O-',
                ],
                onChanged: (v) => setState(() => bloodGroup = v!),
              ),
              _field('Allergies', allergiesController),
              _field('Medical History', medicalHistoryController),
              _field('Emergency Contact Name', emergencyNameController),
              _field(
                'Emergency Contact Number',
                emergencyNumberController,
                isNumber: true,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () async {
                  if (!_formKey.currentState!.validate()) return;

                  final updatedUser = user.copyWith(
                    name: nameController.text.trim(),
                    age: int.parse(ageController.text),
                    sex: sex,
                    bloodGroup: bloodGroup,
                    allergies: allergiesController.text.trim(),
                    medicalHistory: medicalHistoryController.text.trim(),
                    emergencyContactName: emergencyNameController.text.trim(),
                    emergencyContactNumber:
                        emergencyNumberController.text.trim(),
                  );

                  // ✅ CORRECT METHOD
                  await auth.updateCurrentUser(updatedUser);

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Profile updated successfully'),
                    ),
                  );

                  Navigator.pop(context);
                },
                child: const Text('Save Changes'),
              ),
              const SizedBox(height: 20),
              ListTile(
                leading: const Icon(Icons.insert_drive_file),
                title: const Text('Medical Document'),
                subtitle: Text(
                  user.medicalDocumentPath ?? 'Not uploaded',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _field(
    String label,
    TextEditingController controller, {
    bool isNumber = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) => v == null || v.isEmpty ? 'Required' : null,
        decoration: const InputDecoration(
          border: OutlineInputBorder(),
        ).copyWith(labelText: label),
      ),
    );
  }

  Widget _dropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items
          .map(
            (e) => DropdownMenuItem(
              value: e,
              child: Text(e),
            ),
          )
          .toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
