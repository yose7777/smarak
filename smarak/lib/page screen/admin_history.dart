import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminHistoryPage extends StatelessWidget {
  final String alatId;
  final String alatNama;

  const AdminHistoryPage({
    super.key,
    required this.alatId,
    required this.alatNama,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("History $alatNama"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('peminjaman')
            .doc(alatId)
            .collection('history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyDocs = snapshot.data!.docs;

          return ListView.builder(
            itemCount: historyDocs.length,
            itemBuilder: (context, index) {

              final data = historyDocs[index];

              return ListTile(
                leading: const Icon(Icons.history),
                title: Text(data['nama']),
                subtitle: Text(data['jabatan']),
                trailing: Text(data['tanggal']),
              );
            },
          );
        },
      ),
    );
  }
}
