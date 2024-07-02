import 'package:cloud_firestore/cloud_firestore.dart';

class RiwayatController {
  final CollectionReference _riwayatCollection =
      FirebaseFirestore.instance.collection('riwayat');

  Future<void> addHutangToRiwayat(Map<String, dynamic> hutangData) async {
    await _riwayatCollection.add(hutangData);
  }
}
