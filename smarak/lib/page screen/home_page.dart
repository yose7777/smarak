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
    final bgColor =
        isDarkMode ? const Color.fromARGB(255, 174, 50, 50) : const Color(0xFFF5F6FA);

    return Scaffold(
      backgroundColor: bgColor,

      /// ================= APP BAR =================
      appBar: AppBar(
        elevation: 0,
        title: const Text("SMART RACK"),
        centerTitle: true,
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
            onPressed: () => _showMessage("Tidak ada notifikasi"),
          )
        ],
      ),

      /// ================= FLOAT BUTTON =================
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFFF9800),
        onPressed: () => _showMessage("Tambah alat"),
        icon: const Icon(Icons.add),
        label: const Text("Tambah"),
      ),

      /// ================= BODY =================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildProfileCard(),
            const SizedBox(height: 18),
            _buildSummaryRow(),
            const SizedBox(height: 22),
            _buildAlatSection(),
            const SizedBox(height: 22),
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
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }

        final data = snapshot.data!.data() ?? {};

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _cardDecoration(),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF9800), Color(0xFFFFC107)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.engineering, color: Colors.white),
              ),
              const SizedBox(width: 14),

              /// DATA USER
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      data['Nama'] ?? "-",
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "Jabatan: ${data['Jabatan'] ?? '-'}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),

              Text(
                "NIP\n${data['NIP'] ?? '-'}",
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
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
        Expanded(child: _summaryCard("Total Alat", "3", Colors.blue)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Online", "8", Colors.green)),
        const SizedBox(width: 12),
        Expanded(child: _summaryCard("Offline", "4", Colors.red)),
      ],
    );
  }

  Widget _summaryCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: [
          Text(title,
              style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
              color: color,
            ),
          )
        ],
      ),
    );
  }

  // ================= ALAT SECTION =================
  Widget _buildAlatSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Daftar Alat",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(height: 12),
        SizedBox(
          height: 180,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.8),
            itemCount: alatList.length,
            itemBuilder: (_, i) {
              final alat = alatList[i];

              return Container(
                margin: const EdgeInsets.only(right: 12),
                padding: const EdgeInsets.all(14),
                decoration: _cardDecoration(),
                child: Column(
                  children: [
                    Expanded(child: Image.asset(alat.image)),
                    const SizedBox(height: 8),
                    Text(
                      alat.nama,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              );
            },
          ),
        )
      ],
    );
  }

  // ================= MENU =================
  Widget _buildMenuGrid() {
    final items = [
      _menuItem(Icons.history, "Riwayat", const HistoryPage()),
      _menuItem(Icons.note_alt_outlined, "Catatan Alat ", const TransferPage()),
      _menuItem(Icons.inventory, "Persediaan", const AlatPage()),
      _menuItem(Icons.warning, "SOS", const SosPage(), isSOS: true),
      _menuItem(
        Icons.person,
        "Profile",
        ProfilePage(
          isDarkMode: isDarkMode,
          onDarkModeChange: (val) {
            setState(() => isDarkMode = val);
            widget.onThemeChange?.call(val);
          },
        ),
      ),
      _menuItem(Icons.build_rounded, "About Tools", const SettingsPage()),
    ];

    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 14,
      crossAxisSpacing: 14,
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
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) => page));
      },
      child: Container(
        decoration: _cardDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSOS
                    ? Colors.red.withOpacity(0.15)
                    : Colors.orange.withOpacity(0.15),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSOS ? Colors.red : Colors.orange,
              ),
            ),
            const SizedBox(height: 8),
            Text(title,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))
          ],
        ),
      ),
    );
  }

  // ================= CARD STYLE =================
  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 25,
          offset: const Offset(0, 8),
        ),
        BoxShadow(
          color: Colors.black.withOpacity(0.02),
          blurRadius: 50,
          offset: const Offset(0, 18),
        ),
      ],
    );
  }

  void _showMessage(String text) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(text)));
  }
}
