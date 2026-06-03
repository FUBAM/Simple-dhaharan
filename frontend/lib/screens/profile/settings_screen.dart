import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../login/login_screen.dart';
import 'account_settings_screen.dart'; // IMPORT FILE BARU

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Pengaturan'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsGroup(
            title: 'Akun',
            children: [
              _buildListTile(
                icon: Icons.manage_accounts_outlined, // Icon diubah sedikit
                title: 'Update Informasi Akun',
                onTap: () {
                  // MENGARAH KE HALAMAN ACCOUNT SETTINGS
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen()));
                },
              ),
              const Divider(height: 1),
              _buildListTile(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Dhaharan v1.0.0')),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          _buildSettingsGroup(
            title: 'Zona Bahaya',
            children: [
              _buildListTile(
                icon: Icons.person_off_outlined,
                title: 'Hapus Akun (Deactivate)',
                textColor: Colors.red,
                iconColor: Colors.red,
                onTap: () => _showDeactivateDialog(context),
              ),
            ],
          ),
          
          const SizedBox(height: 40),
          
          SizedBox(
            height: 54,
            child: ElevatedButton.icon(
              onPressed: () async {
                final auth = context.read<AuthProvider>();
                await auth.logout();
                if (!context.mounted) return;
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.logout_rounded),
              label: const Text('LOGOUT'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDeactivateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Akun'),
        content: const Text('Apakah kamu yakin ingin menonaktifkan akun ini secara permanen? Semua data resep dan profilmu akan terhapus.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal', style: TextStyle(color: Colors.grey))),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Endpoint Deactivate belum terhubung.'), backgroundColor: Colors.orange));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus Permanen'),
          )
        ],
      )
    );
  }

  Widget _buildSettingsGroup({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])),
        ),
        Container(
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.grey.shade200)),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap, Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Icon(icon, color: iconColor ?? Colors.grey[600]),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.black87, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      onTap: onTap,
    );
  }
}