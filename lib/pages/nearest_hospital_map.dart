import 'package:flutter/material.dart';

class NearestHospitalMap extends StatelessWidget {
  const NearestHospitalMap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nearest Hospital')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.location_on, size: 80, color: Colors.red),
            SizedBox(height: 10),
            Text('Nearest Hospital Found', style: TextStyle(fontSize: 18)),
            Text('Distance: 1.2 km'),
          ],
        ),
      ),
    );
  }
}
