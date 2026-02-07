// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';

// class HistoryService extends ChangeNotifier {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   List<Map<String, dynamic>> history = [];

//   StreamSubscription? _subscription;

//   HistoryService() {
//     _listenHistory();
//   }

// void _listenHistory() {
//   _subscription = _firestore
//       .collection('pengembalian')
//       .snapshots()
//       .listen((snapshot) {
//     debugPrint('🔥 HISTORY COUNT: ${snapshot.docs.length}');

//     history = snapshot.docs.map((doc) {
//       final data = doc.data();
//       debugPrint('📄 DOC: $data');

//       return {
//         'alatName': data['nama_alat'],
//         'duration': data['counter']?.toString(),
//         'date': data['timestamp']?.toString(),
//         'time': data['timestamp']?.toString(),
//         'imagePath': _mapImage(data['nama_alat']),
//       };
//     }).toList();

//     notifyListeners();
//   });
// }


//   String _mapImage(String? namaAlat) {
//     if (namaAlat == null) return 'assets/alat/alat1.png';

//     final name = namaAlat.toLowerCase();

//     if (name.contains('gerinda')) return 'assets/alat/gerinda.png';
//     if (name.contains('amplas')) return 'assets/alat/amplas.png';
//     if (name.contains('bor')) return 'assets/alat/bor.png';

//     return 'assets/alat/alat1.png';
//   }

//   @override
//   void dispose() {
//     _subscription?.cancel();
//     super.dispose();
//   }
// }
