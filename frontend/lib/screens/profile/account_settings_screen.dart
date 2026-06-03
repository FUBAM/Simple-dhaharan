import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  
  bool _obscureCurrent = true;
  bool _obscureNew = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().user;
    if (user != null) {
      _emailController.text = user.email;
      _phoneController.text = user.phone ?? '';
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _newPasswordController.dispose();
    _currentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitAccountUpdate() async {
    if (_currentPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password saat ini wajib diisi!'), backgroundColor: Colors.red));
      return;
    }

    setState(() => _isLoading = true);
    
    // Asumsi kita membuat fungsi updateAccount di AuthProvider
    final success = await context.read<AuthProvider>().updateAccount({
      "email": _emailController.text,
      "phone": _phoneController.text,
      "new_password": _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
      "current_password": _currentPasswordController.text,
    });

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Informasi Akun berhasil diperbarui!'), backgroundColor: Colors.green));
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Gagal memperbarui. Pastikan password saat ini benar.'), backgroundColor: Colors.red));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: const Text('Informasi Akun')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data Akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(labelText: 'Nomor HP', prefixIcon: Icon(Icons.phone_outlined)),
            ),
            const SizedBox(height: 32),

            const Text('Ubah Password (Opsional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: InputDecoration(
                labelText: 'Password Baru', 
                prefixIcon: const Icon(Icons.lock_outline),
                suffixIcon: IconButton(icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureNew = !_obscureNew)),
              ),
            ),
            const SizedBox(height: 32),

            // Bagian Wajib (Verifikasi)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(color: Colors.orange.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.orange.shade200)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Verifikasi Perubahan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                  const SizedBox(height: 8),
                  const Text('Masukkan password Anda saat ini untuk menyimpan perubahan data akun.', style: TextStyle(fontSize: 12, color: Colors.black87)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    decoration: InputDecoration(
                      labelText: 'Password Saat Ini',
                      filled: true, fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.security, color: Colors.orange),
                      suffixIcon: IconButton(icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility), onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 40),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _submitAccountUpdate,
                child: _isLoading ? const CircularProgressIndicator(color: Colors.white) : const Text('SIMPAN INFORMASI AKUN', style: TextStyle(fontSize: 16)),
              ),
            )
          ],
        ),
      ),
    );
  }
}