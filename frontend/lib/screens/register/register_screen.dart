import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() =>
      _RegisterScreenState();
}

class _RegisterScreenState
    extends State<RegisterScreen> {

  final nameController =
      TextEditingController();

  final emailController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Register',
        ),
      ),
      body: Padding(
        padding:
            const EdgeInsets.all(16),
        child: Column(
          children: [

            TextField(
              controller:
                  nameController,
              decoration:
                  const InputDecoration(
                labelText: 'Name',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  emailController,
              decoration:
                  const InputDecoration(
                labelText: 'Email',
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller:
                  passwordController,
              obscureText: true,
              decoration:
                  const InputDecoration(
                labelText: 'Password',
              ),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {

                setState(() {
                  isLoading = true;
                });

                final success =
                    await context
                        .read<AuthProvider>()
                        .register(
                          name:
                              nameController.text,
                          email:
                              emailController.text,
                          password:
                              passwordController.text,
                        );

                setState(() {
                  isLoading = false;
                });

                if (!mounted) return;

                if (success) {

                  Navigator.pop(context);

                } else {

                  ScaffoldMessenger.of(
                          context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Register gagal',
                      ),
                    ),
                  );
                }
              },
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text(
                      'REGISTER',
                    ),
            )
          ],
        ),
      ),
    );
  }
}