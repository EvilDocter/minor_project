import 'package:flutter/material.dart';
import '../services/fingerprint_service.dart';
import '../models/victim_profile.dart';
import 'victim_detail_page.dart';
import 'map_page.dart';

class ParamedicHome extends StatefulWidget {
  const ParamedicHome({super.key});
  @override
  State<ParamedicHome> createState() => _ParamedicHomeState();
}

class _ParamedicHomeState extends State<ParamedicHome> {
  final _service = MockFingerprintService();
  String _status = '';

  void _mockScan() async {
    setState(() => _status = 'Scanning (mock)...');
    final token = await _service.scan();
    setState(() => _status = 'Mock fingerprint scanned: $token');
    final matched = await _service.match(token);
    if (matched == null) {
      setState(() => _status = 'No match found for token: $token');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No match')));
    } else {
      setState(() => _status = 'Matched victim: ${matched.victimId}');
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VictimDetailPage(victim: matched)),
      );
    }
  }

  void _manualPick() async {
    final token = await showDialog<String>(
      context: context,
      builder: (ctx) {
        return SimpleDialog(
          title: const Text('Choose token to simulate'),
          children:
              MockFingerprintService.demoTokens
                  .map(
                    (t) => SimpleDialogOption(
                      child: Text(t),
                      onPressed: () => Navigator.pop(ctx, t),
                    ),
                  )
                  .toList()
                ..add(
                  SimpleDialogOption(
                    child: const Text('invalid_token'),
                    onPressed: () => Navigator.pop(ctx, 'invalid_token'),
                  ),
                ),
        );
      },
    );
    if (token == null) return;
    setState(() => _status = 'Chosen token: $token');
    final matched = await _service.match(token);
    if (matched == null) {
      setState(() => _status = 'No match found for token: $token');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No match')));
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => VictimDetailPage(victim: matched)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Paramedic Tools')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _mockScan,
              icon: const Icon(Icons.fingerprint),
              label: const Text('Identify Victim (Mock Scan)'),
            ),
            const SizedBox(height: 8),
            ElevatedButton.icon(
              onPressed: _manualPick,
              icon: const Icon(Icons.list),
              label: const Text('Pick token manually'),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MapPage()),
              ),
              icon: const Icon(Icons.map),
              label: const Text('Nearby Hospitals Map'),
            ),
            const SizedBox(height: 12),
            Text(_status),
          ],
        ),
      ),
    );
  }
}
