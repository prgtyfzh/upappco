import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

import '../model/piutangmodel.dart';

class PiutangController {
  final piutangCollection = FirebaseFirestore.instance.collection('piutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  List<DocumentSnapshot> currentData = [];

  Future<void> addPiutang(PiutangModel piutangmodel) async {
    final piutang = piutangmodel.toMap();
    final DocumentReference docRef = await piutangCollection.add(piutang);
    final String docID = docRef.id;
    final PiutangModel piutangModel = PiutangModel(
      piutangId: docID,
      namaPeminjam: piutangmodel.namaPeminjam,
      noteleponPeminjam: piutangmodel.noteleponPeminjam,
      nominalDiPinjam: piutangmodel.nominalDiPinjam,
      tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
      tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
      deskripsi: piutangmodel.deskripsi,
    );

    await docRef.update(piutangModel.toMap());
  }

  Future<void> updatePiutang(PiutangModel piutangmodel) async {
    final PiutangModel piutangModel = PiutangModel(
      piutangId: piutangmodel.piutangId,
      namaPeminjam: piutangmodel.namaPeminjam,
      noteleponPeminjam: piutangmodel.noteleponPeminjam,
      nominalDiPinjam: piutangmodel.nominalDiPinjam,
      tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
      tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
      deskripsi: piutangmodel.deskripsi,
    );

    await piutangCollection
        .doc(piutangmodel.piutangId)
        .update(piutangModel.toMap());
  }

  Future<void> removePiutang(String piutangId) async {
    await piutangCollection.doc(piutangId).delete();
  }

  Future getPiutang() async {
    final piutang = await piutangCollection.get();
    streamController.sink.add(piutang.docs);
    return piutang.docs;
  }
}
