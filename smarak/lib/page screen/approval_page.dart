import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AlatPage extends StatelessWidget {
  const AlatPage({super.key});

  /// ================= TAMBAH ALAT DIALOG =================
  void tambahAlatDialog(BuildContext context) {
    final TextEditingController namaController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Tambah Alat"),
          content: TextField(
            controller: namaController,
            decoration: const InputDecoration(
              labelText: "Nama Alat",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (namaController.text.isNotEmpty) {
                  await FirebaseFirestore.instance.collection('status').add({
                    'nama_alat': namaController.text,
                    'status': true,
                    'created_at': FieldValue.serverTimestamp(),
                  });

                  Navigator.pop(context);
                }
              },
              child: const Text("Simpan"),
            ),
          ],
        );
      },
    );
  }

  /// ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Header =====
              const Text(
                "Alat & Peralatan",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFFF4B000),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Kelola dan pantau semua peralatan Anda",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 28),

              /// ===== Column Header =====
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Text(
                      "Nama Alat",
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Status",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        "Riwayat",
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// ===== LIST DATA =====
              Expanded(
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('status')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                          child: CircularProgressIndicator());
                    }

                    if (!snapshot.hasData ||
                        snapshot.data!.docs.isEmpty) {
                      return const Center(
                          child: Text("Data alat kosong"));
                    }

                    return ListView(
                      children: snapshot.data!.docs.map((doc) {
                        final data =
                            doc.data() as Map<String, dynamic>;

                        return alatRow(
                          nama: data['nama_alat'],
                          tersedia: data['status'],
                        );
                      }).toList(),
                    );
                  },
                ),
              ),

              const SizedBox(height: 20),

              /// ===== BUTTON TAMBAH =====
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    tambahAlatDialog(context);
                  },
                  icon: const Icon(Icons.add_rounded),
                  label: const Text("Tambah Alat Baru"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFF4B000),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ================= ROW ALAT =================
  static Widget alatRow({
    required String nama,
    required bool tersedia,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.08),
            blurRadius: 8,
          )
        ],
      ),
      child: Row(
        children: [
          /// ===== Nama Alat =====
          Expanded(
            flex: 2,
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4B000).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(
                    Icons.construction,
                    color: Color(0xFFF4B000),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        nama,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        tersedia ? "Tersedia" : "Dipinjam",
                        style: TextStyle(
                          fontSize: 12,
                          color: tersedia
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ===== Status =====
          Expanded(
            child: Center(
              child: Icon(
                tersedia ? Icons.check : Icons.close,
                color: tersedia ? Colors.green : Colors.red,
              ),
            ),
          ),

          /// ===== Riwayat Icon =====
          const Expanded(
            child: Align(
              alignment: Alignment.centerRight,
              child: Icon(
                Icons.history,
                color: Color(0xFFF4B000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
