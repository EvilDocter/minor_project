import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/auth_service.dart';
import 'paramedic_home_page.dart';

class ParamedicLoginPage extends StatefulWidget {
  const ParamedicLoginPage({super.key});

  @override
  State<ParamedicLoginPage> createState() => _ParamedicLoginPageState();
}

class _ParamedicLoginPageState extends State<ParamedicLoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  String? error;

  @override
  Widget build(BuildContext context) {
    final auth = context.read<AuthService>();

    return Scaffold(
      appBar: AppBar(title: const Text('Paramedic Login')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            if (error != null)
              Text(error!, style: const TextStyle(color: Colors.red)),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {
                  final ok = auth.loginParamedic(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );

                  if (!ok) {
                    setState(() {
                      error = 'Invalid paramedic credentials';
                    });
                    return;
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ParamedicHomePage(),
                    ),
                  );
                },
                child: const Text('Login as Paramedic'),
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Demo credentials:\nparamedic@frs.com / 123456',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
