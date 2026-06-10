import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../login/login_screen.dart';
import 'account_settings_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _showFloatingSnackBar(BuildContext context, String message, Color color, IconData icon) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: const Text('Pengaturan', style: TextStyle(color: Colors.black87, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSettingsGroup(
            title: 'Akun',
            children: [
              _buildListTile(
                icon: Icons.manage_accounts_outlined,
                title: 'Update Informasi Akun',
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AccountSettingsScreen()));
                },
              ),
              const Divider(height: 1, indent: 50, endIndent: 16),
              _buildListTile(
                icon: Icons.info_outline,
                title: 'Tentang Aplikasi',
                onTap: () {
                  _showFloatingSnackBar(context, 'ResepKu v1.0.0 - Aplikasi Berbagi Resep', Colors.blue.shade600, Icons.info_outline_rounded);
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
              label: const Text('LOGOUT', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade50,
                foregroundColor: Colors.red,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
        title: const Text('Hapus Akun', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const Text('Apakah kamu yakin ingin menonaktifkan akun ini secara permanen? Semua data resep dan profilmu akan terhapus dan tidak bisa dikembalikan.'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        actionsPadding: const EdgeInsets.only(right: 16, bottom: 16),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx), 
            child: const Text('Batal', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold))
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              _showFloatingSnackBar(context, 'Endpoint Deactivate belum terhubung.', Colors.orange.shade600, Icons.warning_amber_rounded);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))
            ),
            child: const Text('Hapus Permanen', style: TextStyle(fontWeight: FontWeight.bold)),
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
          decoration: BoxDecoration(
            color: Colors.white, 
            borderRadius: BorderRadius.circular(16), 
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildListTile({required IconData icon, required String title, required VoidCallback onTap, Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: (iconColor ?? Colors.orange).withOpacity(0.1), shape: BoxShape.circle),
        child: Icon(icon, color: iconColor ?? Colors.orange, size: 20),
      ),
      title: Text(title, style: TextStyle(color: textColor ?? Colors.black87, fontWeight: FontWeight.w600)),
      trailing: const Icon(Icons.chevron_right_rounded, color: Colors.grey),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      onTap: onTap,
    );
  }
}