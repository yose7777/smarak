import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  final Function(bool)? onDarkModeChange;
  final bool isDarkMode;

  const ProfilePage({
    super.key,
    this.onDarkModeChange,
    this.isDarkMode = false,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool notificationsEnabled = true;
  late bool darkModeEnabled;
  bool autoRefreshEnabled = true;
  String refreshInterval = '5 menit';

  @override
  void initState() {
    super.initState();
    darkModeEnabled = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: Colors.orange,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFFFFF), Color(0xFFFFF8E1)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Section: Notifikasi
            _buildSectionTitle('Notifikasi'),
            _buildSettingTile(
              icon: Icons.notifications,
              title: 'Aktifkan Notifikasi',
              subtitle: 'Terima notifikasi status alat',
              trailing: Switch(
                value: notificationsEnabled,
                onChanged: (value) {
                  setState(() => notificationsEnabled = value);
                },
                activeColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),

            // Section: Tampilan
            _buildSectionTitle('Tampilan'),
            _buildSettingTile(
              icon: Icons.dark_mode,
              title: 'Mode Gelap',
              subtitle: 'Gunakan tema gelap untuk aplikasi',
              trailing: Switch(
                value: darkModeEnabled,
                onChanged: (value) {
                  setState(() => darkModeEnabled = value);
                  widget.onDarkModeChange?.call(value);
                },
                activeColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 24),

            // Section: Sinkronisasi Data
            _buildSectionTitle('Sinkronisasi Data'),
            _buildSettingTile(
              icon: Icons.sync,
              title: 'Refresh Otomatis',
              subtitle: 'Perbarui data alat secara otomatis',
              trailing: Switch(
                value: autoRefreshEnabled,
                onChanged: (value) {
                  setState(() => autoRefreshEnabled = value);
                },
                activeColor: Colors.orange,
              ),
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.schedule,
              title: 'Interval Refresh',
              subtitle: refreshInterval,
              onTap: _showRefreshIntervalDialog,
            ),
            const SizedBox(height: 24),

            // Section: Koneksi
            _buildSectionTitle('Koneksi'),
            _buildSettingTile(
              icon: Icons.cloud_sync,
              title: 'Status Koneksi',
              subtitle: 'Terhubung ke Firebase',
              trailing: Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Section: Tentang
            _buildSectionTitle('Tentang'),
            _buildSettingTile(
              icon: Icons.info,
              title: 'Versi Aplikasi',
              subtitle: 'v1.0.0',
            ),
            const SizedBox(height: 12),
            _buildSettingTile(
              icon: Icons.privacy_tip,
              title: 'Kebijakan Privasi',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Kebijakan Privasi')),
                );
              },
            ),
            const SizedBox(height: 24),

            // Logout Button
            ElevatedButton.icon(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: const Icon(Icons.logout),
              label: const Text('Logout'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.orange,
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.orange),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: const TextStyle(color: Colors.black54),
              )
            : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showRefreshIntervalDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Interval Refresh'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: ['1 menit', '5 menit', '10 menit', '30 menit'].map((interval) {
              return RadioListTile(
                title: Text(interval),
                value: interval,
                groupValue: refreshInterval,
                activeColor: Colors.orange,
                onChanged: (value) {
                  setState(() => refreshInterval = value ?? '5 menit');
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Apakah Anda yakin ingin keluar dari aplikasi?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout berhasil')),
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}