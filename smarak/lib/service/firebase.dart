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

  /// BUAT DATA OTOMATIS DARI EMAIL
 Future<void> createProfileFromEmailIfNotExist() async {
  final user = _auth.currentUser!;
  final uid = user.uid;

  final docRef = _firestore.collection('pegawai').doc(uid);
  final snapshot = await docRef.get();

  final email = user.email ?? 'user';
  final nickname = email.split('@').first;

  if (!snapshot.exists) {
    // BUAT BARU
    await docRef.set({
      'Nama': nickname,
      'Jabatan': 'Pegawai',
      'NIP': '${DateTime.now().millisecondsSinceEpoch}',
      'email': email,
      'createdAt': FieldValue.serverTimestamp(),
    });
  } else {
    // 🔥 UPDATE JIKA MASIH DEFAULT
    final data = snapshot.data()!;
    if (data['Nama'] == 'User Baru' || data['Nama'] == '-') {
      await docRef.update({
        'Nama': nickname,
      });
    }
  }
}

}
