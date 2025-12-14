import 'package:flutter/material.dart';
import '../models/user_record.dart';
import 'medical_id_page.dart';

class ParamedicUserDetailPage extends StatelessWidget {
  final UserRecord user;

  const ParamedicUserDetailPage({
    super.key,
    required this.user,
  });

  @override
  Widget build(BuildContext context) {
    return MedicalIdPage(
      user: user,
      isParamedic: true,
    );
  }
}
