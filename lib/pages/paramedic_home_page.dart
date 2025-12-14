import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/user_record.dart';
import 'medical_id_page.dart';

class ParamedicHomePage extends StatefulWidget {
  const ParamedicHomePage({super.key});

  @override
  State<ParamedicHomePage> createState() => _ParamedicHomePageState();
}

class _ParamedicHomePageState extends State<ParamedicHomePage> {
  final List<UserRecord> _recentlyScanned = [];

  void _startMockScan() async {
    final users = await DBService.getAllUsers();
    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(22)),
      ),
      builder: (_) {
        if (users.isEmpty) {
          return const Padding(
            padding: EdgeInsets.all(24),
            child: Center(child: Text('No users available')),
          );
        }

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];

            return ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.red.shade100,
                child: const Icon(Icons.badge, color: Colors.red),
              ),
              title: Text(
                user.name,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              subtitle: Text('Blood Group: ${user.bloodGroup}'),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                Navigator.pop(context);

                setState(() {
                  _recentlyScanned.removeWhere((u) => u.id == user.id);
                  _recentlyScanned.insert(0, user);
                  if (_recentlyScanned.length > 5) {
                    _recentlyScanned.removeLast();
                  }
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => MedicalIdPage(
                      user: user,
                      isParamedic: true,
                    ),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Paramedic Dashboard'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ---- SCAN CARD ----
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    const Icon(
                      Icons.fingerprint,
                      size: 80,
                      color: Colors.red,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Mock Fingerprint Scan',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.search),
                        label: const Text('Start Scan'),
                        onPressed: _startMockScan,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ---- RECENTLY SCANNED ----
            if (_recentlyScanned.isNotEmpty) ...[
              const Text(
                'Recently Scanned',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: _recentlyScanned.length,
                  itemBuilder: (_, index) {
                    final user = _recentlyScanned[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      child: ListTile(
                        leading: const Icon(Icons.history),
                        title: Text(user.name),
                        subtitle: Text('Blood Group: ${user.bloodGroup}'),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MedicalIdPage(
                                user: user,
                                isParamedic: true,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
