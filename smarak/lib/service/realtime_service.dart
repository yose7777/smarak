import 'package:firebase_database/firebase_database.dart';

class RealtimeService {
  final _ref = FirebaseDatabase.instance.ref('sensor');

  Stream<DatabaseEvent> get stream => _ref.onValue;

  Future<void> updateStatus(String status) async {
    await _ref.update({
      'status': status,
      'updatedAt': DateTime.now().toString(),
    });
  }
}
