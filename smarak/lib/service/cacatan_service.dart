import 'package:cloud_firestore/cloud_firestore.dart';

class NoteService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// TAMBAH CATATAN
  Future<void> addNote(Map<String, dynamic> data) async {
    await _firestore.collection('notes').add(data);
  }

  /// AMBIL HISTORY
  Stream<QuerySnapshot> getNotes() {
    return _firestore
        .collection('notes')
        .orderBy('date', descending: true)
        .snapshots();
  }

  /// HAPUS CATATAN
  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
  