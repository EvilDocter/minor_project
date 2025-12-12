import 'dart:math';
import '../models/victim_profile.dart';
import 'db_service.dart';

class MockFingerprintService {
  static const demoTokens = ['finger_abc123', 'finger_xyz999', 'finger_test_1'];

  Future<String> scan({String? useToken}) async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (useToken != null) return useToken;
    final r = Random().nextInt(demoTokens.length);
    return demoTokens[r];
  }

  Future<VictimProfile?> match(String token) async {
    return await DBService.getVictimByFingerprint(token);
  }
}
