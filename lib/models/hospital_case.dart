import 'user_record.dart';

class HospitalCase {
  final String id;
  final UserRecord user;
  final String riskLevel;
  final DateTime time;

  HospitalCase({
    required this.id,
    required this.user,
    required this.riskLevel,
    required this.time,
  });
}
