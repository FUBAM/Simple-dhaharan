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
      _showSnackBar('Password saat ini wajib diisi untuk verifikasi!', Colors.red.shade600, Icons.error_rounded);
      return;
    }

    setState(() => _isLoading = true);
    
    final success = await context.read<AuthProvider>().updateAccount({
      "email": _emailController.text,
      "phone": _phoneController.text,
      "new_password": _newPasswordController.text.isNotEmpty ? _newPasswordController.text : null,
      "current_password": _currentPasswordController.text,
    });

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (success) {
      _showSnackBar('Informasi Akun berhasil diperbarui!', Colors.green.shade600, Icons.check_circle_rounded);
      Navigator.pop(context);
    } else {
      _showSnackBar('Gagal memperbarui. Pastikan password saat ini benar.', Colors.red.shade600, Icons.error_rounded);
    }
  }

  // Helper untuk menampilkan SnackBar modern
  void _showSnackBar(String message, Color color, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(message, style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white))),
          ],
        ),
        backgroundColor: color,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
        elevation: 6,
      ),
    );
  }

  // Helper untuk styling TextField agar konsisten
  InputDecoration _inputStyle(String label, IconData icon, {Widget? suffixIcon}) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.grey),
      suffixIcon: suffixIcon,
      filled: true,
      fillColor: Colors.grey.shade50,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orange, width: 2)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Informasi Akun', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data Akun', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            TextField(
              controller: _emailController,
              decoration: _inputStyle('Email', Icons.email_outlined),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              decoration: _inputStyle('Nomor HP', Icons.phone_outlined),
            ),
            const SizedBox(height: 32),

            const Text('Ubah Password (Opsional)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              obscureText: _obscureNew,
              decoration: _inputStyle(
                'Password Baru', 
                Icons.lock_outline,
                suffixIcon: IconButton(icon: Icon(_obscureNew ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _obscureNew = !_obscureNew)),
              ),
            ),
            const SizedBox(height: 32),

            // Bagian Wajib (Verifikasi)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.orange.shade50, 
                borderRadius: BorderRadius.circular(16), 
                border: Border.all(color: Colors.orange.shade200)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.security, color: Colors.orange, size: 20),
                      SizedBox(width: 8),
                      Text('Verifikasi Perubahan', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 16)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Masukkan password Anda saat ini untuk menyimpan perubahan data akun.', style: TextStyle(fontSize: 13, color: Colors.grey.shade700, height: 1.4)),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _currentPasswordController,
                    obscureText: _obscureCurrent,
                    decoration: InputDecoration(
                      labelText: 'Password Saat Ini',
                      filled: true, 
                      fillColor: Colors.white,
                      prefixIcon: const Icon(Icons.lock_person_outlined, color: Colors.grey),
                      suffixIcon: IconButton(icon: Icon(_obscureCurrent ? Icons.visibility_off : Icons.visibility, color: Colors.grey), onPressed: () => setState(() => _obscureCurrent = !_obscureCurrent)),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.orange, width: 2)),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  foregroundColor: Colors.white,
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                ),
                child: _isLoading 
                    ? const CircularProgressIndicator(color: Colors.white) 
                    : const Text('SIMPAN INFORMASI AKUN', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}