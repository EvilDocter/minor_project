import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/user_record.dart';
import '../services/db_service.dart';

class MedicalIdPage extends StatelessWidget {
  final UserRecord user;
  final bool isParamedic;
  final String? hospitalCaseId;

  const MedicalIdPage({
    super.key,
    required this.user,
    required this.isParamedic,
    this.hospitalCaseId,
  });

  Future<void> _openFile(String path) async {
    final uri = Uri.parse(path);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  void _showRiskDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Select Case Risk'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: ['High', 'Medium', 'Low']
              .map(
                (risk) => ListTile(
                  leading: Icon(
                    Icons.warning,
                    color: risk == 'High'
                        ? Colors.red
                        : risk == 'Medium'
                            ? Colors.orange
                            : Colors.green,
                  ),
                  title: Text(risk),
                  onTap: () async {
                    await DBService.sendCaseToHospital(user, risk);
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Case sent to hospital ($risk risk)'),
                      ),
                    );
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Medical ID')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: ListView(
              children: [
                // -------- HEADER --------
                Center(
                  child: Column(
                    children: [
                      const Icon(Icons.badge, size: 70),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Medical Identification Card',
                        style: TextStyle(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 32),

                _info('Age', user.age.toString()),
                _info('Sex', user.sex),
                _info('Blood Group', user.bloodGroup),
                _info('Allergies', user.allergies),
                _info('Medical History', user.medicalHistory),
                _info(
                  'Emergency Contact',
                  '${user.emergencyContactName} (${user.emergencyContactNumber})',
                ),

                const SizedBox(height: 20),

                // -------- MEDICAL DOCUMENT --------
                Text(
                  'Medical Document',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                if (user.medicalDocumentPath != null)
                  ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    tileColor: Colors.grey.shade100,
                    leading: const Icon(Icons.description),
                    title: const Text('View Medical File'),
                    subtitle: Text(user.medicalDocumentPath!),
                    onTap: () => _openFile(user.medicalDocumentPath!),
                  )
                else
                  const Text('No document uploaded'),

                const SizedBox(height: 28),

                // -------- PARAMEDIC ACTION --------
                if (isParamedic)
                  ElevatedButton.icon(
                    icon: const Icon(Icons.local_hospital),
                    label: const Text('Notify Hospital'),
                    onPressed: () => _showRiskDialog(context),
                  ),

                // -------- HOSPITAL ACTION --------
                if (!isParamedic && hospitalCaseId != null)
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                    ),
                    icon: const Icon(Icons.check),
                    label: const Text('Mark Case as Resolved'),
                    onPressed: () async {
                      await DBService.resolveCase(hospitalCaseId!);
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Case resolved'),
                          ),
                        );
                      }
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _info(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
