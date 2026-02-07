import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../alat_model.dart';
import '../service/firebase.dart';

import 'history_page.dart';
import 'approval_page.dart';
import 'sos_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';
import 'transfer_page_fixed.dart' show TransferPage;

class HomePage extends StatefulWidget {
  final Function(bool)? onThemeChange;
  final bool isDarkMode;

  const HomePage({
    super.key,
    this.onThemeChange,
    this.isDarkMode = false, 
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late bool isDarkMode;

  final PegawaiService _pegawaiService = PegawaiService();

  final List<AlatModel> alatList = [
    AlatModel("BOR TANGAN", "assets/alat/alat2.png"),
    AlatModel("GERINDA POTONG", "assets/alat/alat1.png"),
    AlatModel("MESIN AMPLAS", "assets/alat/alat3.png"),
  ];

  @override
  void initState() {
    super.initState();
    isDarkMode = widget.isDarkMode;
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFFFF9800);

    return Scaffold(
      backgroundColor:
          isDarkMode ? const Color(0xFF1A1A1A) : const Color(0xFFF7F7F7),
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text('SMARAK', ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => _showMessage('Tidak ada notifikasi'),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _showMessage('Tambah alat'),
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProfileCard(),
            const SizedBox(height: 18),
            _buildSummaryRow(),
            const SizedBox(height: 18),
            _buildAlatSection(),
            const SizedBox(height: 18),
            _buildMenuGrid(),
          ],
        ),
      ),
    );
  }

  // ================= PROFILE CARD =================
  Widget _buildProfileCard() {
  return StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    stream: _pegawaiService.getProfileByUID(),
    builder: (context, snapshot) {
      if (snapshot.connectionState == ConnectionState.waiting) {
        return const Center(child: CircularProgressIndicator());
      }

      if (!snapshot.hasData || !snapshot.data!.exists) {
        return const Text('Data pegawai tidak ditemukan');
      }

      final data = snapshot.data!.data()!;

      final String nama = data['Nama'] ?? '-';
      final String jabatan = data['Jabatan'] ?? '-';
      final String nip = data['NIP'] ?? '-';

      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
            ),
          ],
        ),
        child: Row(
          children: [
            const CircleAvatar(
              radius: 28,
              backgroundColor: Colors.orange,
              child: Icon(Icons.engineering, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    nama, // 🔥 NICKNAME PASTI SESUAI USER
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Jabatan: $jabatan',
                    style: const TextStyle(color: Colors.black54),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  'NIP: $nip',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 6),
                const Icon(Icons.more_vert, size: 18),
              ],
            )
          ],
        ),
      );
    },
  );
}


  // ================= SUMMARY =================
  Widget _buildSummaryRow() {
    return Row(
      children: [
        Expanded(child: _summaryCard('Total Alat', '3', Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard('Online', '8', Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard('Offline', '4', Colors.red)),
      ],
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                width: 8,
                height: 8,
                decoration:
                    BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                    fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ],
          )
        ],
      ),
    );
  }

  // ================= ALAT =================
  Widget _buildAlatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daftar Alat',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: PageView.builder(
            itemCount: alatList.length,
            controller: PageController(viewportFraction: 0.8),
            itemBuilder: (context, index) {
              final alat = alatList[index];
              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10)
                  ],
                ),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(alat.image)),
                    const SizedBox(height: 8),
                    Text(
                      alat.nama,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ================= MENU =================
  Widget _buildMenuGrid() {
    final items = [
      _menuItem(Icons.history, 'Riwayat Alat', const HistoryPage()),
      _menuItem(Icons.note_add, 'Catatan Alat', const TransferPage()),
      _menuItem(Icons.check_circle, 'Persediaan', const AlatPage()),
      _menuItem(Icons.warning, 'SOS', const SosPage(), isSOS: true),
      _menuItem(
        Icons.settings,
        'Setting',
        ProfilePage(
          onDarkModeChange: (value) {
            setState(() => isDarkMode = value);
            widget.onThemeChange?.call(value);
          },
          isDarkMode: isDarkMode,
        ),
      ),
      _menuItem(Icons.build, 'About Tool', const SettingsPage()),
    ];

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: items,
    );
  }

  Widget _menuItem(
    IconData icon,
    String title,
    Widget page, {
    bool isSOS = false,
  }) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8)
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isSOS
                    ? Colors.red.withOpacity(0.12)
                    : Colors.orange.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon,
                  color: isSOS ? Colors.red : Colors.orange),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
