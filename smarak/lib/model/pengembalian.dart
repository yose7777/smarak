import 'package:cloud_firestore/cloud_firestore.dart';

class PengembalianModel {
  final String id;
  final int counter;
  final String jabatan;
  final String namaAlat;
  final String nip;
  final String peminjamTerakhir;
  final bool status;
  final String timestamp;

  PengembalianModel({
    required this.id,
    required this.counter,
    required this.jabatan,
    required this.namaAlat,
    required this.nip,
    required this.peminjamTerakhir,
    required this.status,
    required this.timestamp,
  });

  factory PengembalianModel.fromFirestore(
    DocumentSnapshot doc,
  ) {
    final data = doc.data() as Map<String, dynamic>;

    return PengembalianModel(
      id: doc.id,
      counter: data['counter'] ?? 0,
      jabatan: data['jabatan'] ?? '-',
      namaAlat: data['nama_alat'] ?? '-',
      nip: data['nip'] ?? '-',
      peminjamTerakhir: data['peminjam_terakhir'] ?? '-',
      status: data['status'] ?? false,
      timestamp: data['timestamp'] ?? '-',
    );
  }
}
