import 'dart:convert';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class MapPage extends StatefulWidget {
  const MapPage({super.key});
  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  LatLng? _current;
  bool _loading = true;
  String? _error;
  List<Map<String, dynamic>> _hospitals = [];
  final MapController _mapController = MapController();

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  Future<void> _loadLocation() async {
    try {
      LocationPermission permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        setState(() {
          _error = "Location permission denied";
          _loading = false;
        });
        return;
      }

      final pos = await Geolocator.getCurrentPosition();
      _current = LatLng(pos.latitude, pos.longitude);

      await _fetchHospitals(_current!.latitude, _current!.longitude);

      setState(() => _loading = false);
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  /// Ask Overpass. If too slow, try again. If still slow, show pretend hospitals.
  Future<void> _fetchHospitals(double lat, double lon) async {
    final endpoints = [
      'https://overpass-api.de/api/interpreter',
      'https://overpass.kumi.systems/api/interpreter',
      'https://overpass.openstreetmap.fr/api/interpreter',
    ];

    const queryPart = '''
      [out:json][timeout:10];
      (
        node["amenity"="hospital"](around:1500,@@LAT@@,@@LON@@);
      );
      out center;
    ''';

    bool success = false;
    List<Map<String, dynamic>> results = [];

    for (final ep in endpoints) {
      if (success) break;

      final query = queryPart
          .replaceAll("@@LAT@@", lat.toString())
          .replaceAll("@@LON@@", lon.toString());

      try {
        final resp = await http.post(Uri.parse(ep),
            body: {"data": query}).timeout(const Duration(seconds: 10));

        if (resp.statusCode == 200) {
          final data = jsonDecode(resp.body);
          final elements = data["elements"] as List<dynamic>;
          for (var e in elements) {
            double? elat;
            double? elon;

            if (e["type"] == "node") {
              elat = e["lat"]?.toDouble();
              elon = e["lon"]?.toDouble();
            } else if (e["center"] != null) {
              elat = e["center"]["lat"]?.toDouble();
              elon = e["center"]["lon"]?.toDouble();
            }

            if (elat != null && elon != null) {
              results.add({
                "name": e["tags"]?["name"] ?? "Hospital",
                "lat": elat,
                "lon": elon,
              });
            }
          }

          success = true;
        }
      } catch (_) {
        // ignore, try next server
      }
    }

    // if still no hospitals, use pretend ones
    if (!success) {
      results = [
        {"name": "Fallback Hospital 1", "lat": lat + 0.003, "lon": lon + 0.003},
        {"name": "Fallback Hospital 2", "lat": lat - 0.004, "lon": lon + 0.002},
      ];
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Using fallback hospitals")),
      );
    }

    setState(() => _hospitals = results);
  }

  @override
  Widget build(BuildContext context) {
    final center = _current ?? LatLng(28.6, 77.2); // New Delhi fallback

    return Scaffold(
      appBar: AppBar(title: const Text("Nearby Hospitals")),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text("Error: $_error"))
              : FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: center,
                    initialZoom: 14,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: const ['a', 'b', 'c'],
                    ),
                    MarkerLayer(
                      markers: [
                        // User
                        Marker(
                          point: center,
                          width: 40,
                          height: 40,
                          child: const Icon(Icons.person_pin_circle,
                              color: Colors.blue, size: 40),
                        ),
                        // Hospitals
                        ..._hospitals.map(
                          (h) => Marker(
                            width: 40,
                            height: 40,
                            point: LatLng(h["lat"], h["lon"]),
                            child: const Icon(Icons.local_hospital,
                                color: Colors.red, size: 32),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
    );
  }
}
