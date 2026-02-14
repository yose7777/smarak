import 'package:cloud_firestore/cloud_firestore.dart';

class PeminjamanService {

  final _firestore = FirebaseFirestore.instance;

  Future<void> pinjamAlat({
    required String alatId,
    required String namaPegawai,
    required String jabatan,
    required String nip,
  }) async {

    final docRef = _firestore.collection('peminjaman').doc(alatId);

    /// UPDATE STATUS ALAT
    await docRef.update({
      'peminjam_terakhir': namaPegawai,
      'jabatan': jabatan,
      'nip': nip,
      'status': false,
      'timestamp': FieldValue.serverTimestamp(),
      'counter': FieldValue.increment(1),
    });

    /// SIMPAN HISTORY
    await docRef.collection('history').add({
      'nama': namaPegawai,
      'jabatan': jabatan,
      'nip': nip,
      'tanggal': DateTime.now().toString(),
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}
