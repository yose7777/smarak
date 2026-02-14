import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('peminjaman')
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final alatDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: alatDocs.length,
            itemBuilder: (context, index) {

              final data = alatDocs[index].data() as Map<String, dynamic>;

              final namaAlat = data['nama_alat'] ?? '-';
              final peminjam = data['peminjam_terakhir'] ?? '-';
              final jabatan = data['jabatan'] ?? '-';
              final nip = data['nip'] ?? '-';
              final status = data['status'] ?? true;

              return Card(
                margin: const EdgeInsets.all(12),
                child: ListTile(
                  leading: Icon(
                    status ? Icons.check_circle : Icons.warning,
                    color: status ? Colors.green : Colors.red,
                  ),
                  title: Text(namaAlat),

                  /// ⭐ PEMINJAM TERAKHIR
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status
                            ? "Status : Tersedia"
                            : "Dipinjam",
                        style: TextStyle(
                          color: status ? Colors.green : Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text("Peminjam Terakhir : $peminjam"),
                      Text("Jabatan : $jabatan"),
                      Text("NIP : $nip"),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
