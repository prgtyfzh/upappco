import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/model/hutangmodel.dart';

class HutangController {
  final hutangCollection = FirebaseFirestore.instance.collection('hutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;
  List<DocumentSnapshot> currentData = [];

  Future<void> addHutang(HutangModel hutangmodel) async {
    final hutang = hutangmodel.toMap();
    final DocumentReference docRef = await hutangCollection.add(hutang);
    final String docID = docRef.id;
    final HutangModel hutangModel = HutangModel(
      hutangId: docID,
      namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
      noteleponPemberiPinjam: hutangmodel.noteleponPemberiPinjam,
      nominalPinjam: hutangmodel.nominalPinjam,
      tanggalPinjam: hutangmodel.tanggalPinjam,
      tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
      deskripsi: hutangmodel.deskripsi,
      // gambar: hutangmodel.gambar,
    );

    await docRef.update(hutangModel.toMap());
  }

  Future<void> updateHutang(HutangModel hutangmodel) async {
    final HutangModel hutangModel = HutangModel(
      hutangId: hutangmodel.hutangId,
      namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
      noteleponPemberiPinjam: hutangmodel.noteleponPemberiPinjam,
      nominalPinjam: hutangmodel.nominalPinjam,
      tanggalPinjam: hutangmodel.tanggalPinjam,
      tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
      deskripsi: hutangmodel.deskripsi,
      // gambar: hutangmodel.gambar,
    );

    await hutangCollection
        .doc(hutangmodel.hutangId)
        .update(hutangModel.toMap());
  }

  Future<void> removeHutang(String hutangId) async {
    await hutangCollection.doc(hutangId).delete();
  }

  Future getHutang() async {
    final hutang = await hutangCollection.get();
    streamController.sink.add(hutang.docs);
    return hutang.docs;
  }
}
