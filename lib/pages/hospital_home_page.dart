import 'package:flutter/material.dart';
import '../services/db_service.dart';
import '../models/hospital_case.dart';
import 'medical_id_page.dart';

class HospitalHomePage extends StatefulWidget {
  const HospitalHomePage({super.key});

  @override
  State<HospitalHomePage> createState() => _HospitalHomePageState();
}

class _HospitalHomePageState extends State<HospitalHomePage> {
  String _filter = 'All';

  Color _riskColor(String risk) {
    switch (risk) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  String _timeAgo(DateTime time) {
    final diff = DateTime.now().difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes} min ago';
    if (diff.inHours < 24) return '${diff.inHours} hr ago';
    return '${diff.inDays} days ago';
  }

  Widget _statTile(String label, int count, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 4),
            Text(label),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hospital Inbox'),
        actions: [
          DropdownButton<String>(
            value: _filter,
            underline: const SizedBox(),
            items: const [
              DropdownMenuItem(value: 'All', child: Text('All')),
              DropdownMenuItem(value: 'High', child: Text('High')),
              DropdownMenuItem(value: 'Medium', child: Text('Medium')),
              DropdownMenuItem(value: 'Low', child: Text('Low')),
            ],
            onChanged: (v) => setState(() => _filter = v!),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: FutureBuilder<List<HospitalCase>>(
        future: DBService.getHospitalCases(),
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final allCases = snap.data!;
          final high = allCases.where((c) => c.riskLevel == 'High').length;
          final medium = allCases.where((c) => c.riskLevel == 'Medium').length;
          final low = allCases.where((c) => c.riskLevel == 'Low').length;

          var cases = allCases;
          if (_filter != 'All') {
            cases = cases.where((c) => c.riskLevel == _filter).toList();
          }

          return Column(
            children: [
              // -------- STATS BAR --------
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    _statTile('Total', allCases.length, Colors.blue),
                    const SizedBox(width: 10),
                    _statTile('High', high, Colors.red),
                    const SizedBox(width: 10),
                    _statTile('Medium', medium, Colors.orange),
                    const SizedBox(width: 10),
                    _statTile('Low', low, Colors.green),
                  ],
                ),
              ),

              // -------- CASE LIST --------
              Expanded(
                child: cases.isEmpty
                    ? const Center(child: Text('No cases found'))
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: cases.length,
                        itemBuilder: (_, i) {
                          final c = cases[i];
                          final color = _riskColor(c.riskLevel);

                          return Card(
                            elevation: 3,
                            margin: const EdgeInsets.only(bottom: 14),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: color.withOpacity(0.15),
                                child: Icon(Icons.warning, color: color),
                              ),
                              title: Text(
                                c.user.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Risk: ${c.riskLevel}',
                                    style: TextStyle(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(_timeAgo(c.time)),
                                ],
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                              ),
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => MedicalIdPage(
                                      user: c.user,
                                      isParamedic: false,
                                      hospitalCaseId: c.id,
                                    ),
                                  ),
                                );
                                setState(() {});
                              },
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
