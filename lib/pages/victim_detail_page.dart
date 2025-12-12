import 'package:flutter/material.dart';
import '../models/victim_profile.dart';
import 'package:url_launcher/url_launcher.dart';

class VictimDetailPage extends StatelessWidget {
  final VictimProfile victim;
  const VictimDetailPage({super.key, required this.victim});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(victim.name)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Victim ID: ${victim.victimId}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Phone: ${victim.phone}'),
            const SizedBox(height: 8),
            Text('Medical Notes: ${victim.medicalNotes}'),
            const SizedBox(height: 8),
            Text('Allergies: ${victim.allergies}'),
            const SizedBox(height: 8),
            Text('Medications: ${victim.medications}'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () async {
                final url = Uri.parse('tel:${victim.phone}');
                if (await canLaunchUrl(url)) await launchUrl(url);
              },
              icon: const Icon(Icons.call),
              label: const Text('Call'),
            ),
          ],
        ),
      ),
    );
  }
}
