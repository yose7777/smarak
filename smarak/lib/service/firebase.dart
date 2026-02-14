import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PegawaiService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// STREAM PROFILE USER LOGIN
  Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileByUID() {
    final uid = _auth.currentUser!.uid;
    return _firestore.collection('pegawai').doc(uid).snapshots();
  }

  /// BUAT PROFILE OTOMATIS
  Future<void> createProfileFromEmailIfNotExist() async {
    final user = _auth.currentUser!;
    final uid = user.uid;

    final docRef = _firestore.collection('pegawai').doc(uid);
    final snapshot = await docRef.get();

    final email = user.email ?? 'user';
    final nickname = email.split('@').first;

    if (!snapshot.exists) {
      await docRef.set({
        'Nama': nickname,
        'Jabatan': 'Pegawai',
        'NIP': '${DateTime.now().millisecondsSinceEpoch}',
        'email': email,
        'role': 'pegawai',
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

  /// 🔥 GET ROLE USER
  Future<String> getUserRole() async {
    final uid = _auth.currentUser!.uid;

    final doc = await _firestore
        .collection('pegawai')
        .doc(uid)
        .get();

    if (!doc.exists) return "pegawai";

    return doc.data()?['role'] ?? "pegawai";
  }
}
