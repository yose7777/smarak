// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class PegawaiService {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   /// STREAM PROFILE USER LOGIN
//   Stream<DocumentSnapshot<Map<String, dynamic>>> getProfileByUID() {
//     final uid = _auth.currentUser!.uid;

//     return _firestore
//         .collection('pegawai')
//         .doc(uid)
//         .snapshots();
//   }

//   /// BUAT DATA JIKA BELUM ADA
//   Future<void> createProfileIfNotExist() async {
//     final uid = _auth.currentUser!.uid;
//     final doc = _firestore.collection('pegawai').doc(uid);

//     final snapshot = await doc.get();
//     if (!snapshot.exists) {
//       await doc.set({
//         'Nama': 'User Baru',
//         'Jabatan': '-',
//         'NIP': '-',
//         'createdAt': FieldValue.serverTimestamp(),
//       });
//     }
//   }
// }
