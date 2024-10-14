import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/model/pembayaranmodel.dart';
import 'package:tugasakhir/model/piutangmodel.dart';

class PiutangController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference piutangCollection =
      FirebaseFirestore.instance.collection('piutang');
  final CollectionReference pembayaranCollection =
      FirebaseFirestore.instance.collection('pembayaran');
  final CollectionReference hutangCollection =
      FirebaseFirestore.instance.collection('hutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPiutangManual(PiutangModel piutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang = piutangmodel.toMap();
      piutang['userId'] = user.uid;
      final DocumentReference docRef = await piutangCollection.add(piutang);
      final String docID = docRef.id;

      final PiutangModel updatedPiutangModel = PiutangModel(
        piutangId: docID,
        namaPeminjam: piutangmodel.namaPeminjam,
        nominalDiPinjam: piutangmodel.nominalDiPinjam,
        tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
        tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
        deskripsi: piutangmodel.deskripsi,
        totalBayar: '',
        sisaHutang: '',
        status: '',
      );

      await docRef.update(updatedPiutangModel.toMap());
    }
  }

  Future<void> addPiutang(PiutangModel piutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang = piutangmodel.toMap();
      piutang['userId'] = user.uid;
      final DocumentReference docRef =
          piutangCollection.doc(piutangmodel.piutangId);
      await docRef.set(piutang);

      final PiutangModel updatedPiutangModel = PiutangModel(
        piutangId: piutangmodel.piutangId,
        namaPeminjam: piutangmodel.namaPeminjam,
        nominalDiPinjam: piutangmodel.nominalDiPinjam,
        tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
        tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
        deskripsi: piutangmodel.deskripsi,
        totalBayar: piutangmodel.totalBayar,
        sisaHutang: piutangmodel.sisaHutang,
        status: piutangmodel.status,
      );

      await docRef.update(updatedPiutangModel.toMap());
    }
  }

  Future<String> getNominalDiPinjam(String piutangId) async {
    try {
      final docSnapshot = await piutangCollection.doc(piutangId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('nominalDiPinjam')) {
          return data['nominalDiPinjam'].toString();
        } else {
          return '0';
        }
      } else {
        throw Exception('Document with piutangId $piutangId not found');
      }
    } catch (e) {
      print('Error getting nominalDiPinjam: $e');
      return '0';
    }
  }

  Future<String> getTotalNominalBayar(String piutangId) async {
    try {
      final bayarPiutang = await pembayaranCollection
          .where('piutangId', isEqualTo: piutangId)
          .get();
      double totalBayar = 0;
      bayarPiutang.docs.forEach((doc) {
        PembayaranModel bayarPiutangModel =
            PembayaranModel.fromMap(doc.data() as Map<String, dynamic>);
        totalBayar += double.parse(bayarPiutangModel.nominalBayar
                .replaceAll('.', '')
                .replaceAll(',', '')) ??
            0.0;
      });

      String formattedTotalBayar =
          NumberFormat.decimalPattern('id_ID').format(totalBayar);
      return formattedTotalBayar;
    } catch (e) {
      print('Error getting total nominal bayar: $e');
      return '0';
    }
  }

  Future<String> calculateTotalSisaPiutang(
      String piutangId, String nominalDiPinjam) async {
    try {
      String totalBayarStr = await getTotalNominalBayar(piutangId);
      double totalBayar = double.tryParse(
              totalBayarStr.replaceAll('.', '').replaceAll(',', '')) ??
          0.0;
      double nominalDiPinjamDouble =
          double.tryParse(nominalDiPinjam.replaceAll('.', '')) ?? 0.0;

      double sisaPiutang = nominalDiPinjamDouble - totalBayar;
      if (sisaPiutang < 0) {
        sisaPiutang = 0;
      }

      String formattedSisaPiutang =
          NumberFormat.decimalPattern('id_ID').format(sisaPiutang);
      return formattedSisaPiutang;
    } catch (e) {
      print('Error calculating sisa piutang: $e');
      return '0';
    }
  }

  Future<void> addBayarPiutang(PembayaranModel bayarPiutangModel) async {
    try {
      String nominalDiPinjam =
          await getNominalDiPinjam(bayarPiutangModel.piutangId!);
      String sisaPiutangStr = await calculateTotalSisaPiutang(
          bayarPiutangModel.piutangId ?? '', nominalDiPinjam ?? '0');
      double sisaPiutang = double.tryParse(
              sisaPiutangStr.replaceAll('.', '').replaceAll(',', '')) ??
          0.0;

      double nominalBayar = double.tryParse(bayarPiutangModel.nominalBayar
              .replaceAll('.', '')
              .replaceAll(',', '')) ??
          0.0;

      if (nominalBayar > sisaPiutang) {
        throw Exception('Nominal bayar tidak boleh melebihi sisa piutang');
      }

      final bayarPiutang = bayarPiutangModel.toMap();
      bayarPiutang['userId'] =
          _auth.currentUser!.uid; // Add user ID to the document
      final DocumentReference docRef =
          await pembayaranCollection.add(bayarPiutang);
      final String docID = docRef.id;

      final PembayaranModel updatedBayarPiutangModel = PembayaranModel(
        pembayaranId: docID,
        piutangId: bayarPiutangModel.piutangId,
        hutangId: bayarPiutangModel.piutangId,
        nominalBayar: bayarPiutangModel.nominalBayar,
        tanggalBayar: bayarPiutangModel.tanggalBayar,
      );

      await docRef.update(updatedBayarPiutangModel.toMap());
      // Recalculate totalBayar and sisaPiutang
      String totalBayarStr =
          await getTotalNominalBayar(bayarPiutangModel.piutangId!);
      String nominalPinjam2 =
          await getNominalDiPinjam(bayarPiutangModel.piutangId!);
      String updatedSisaPiutangStr = await calculateTotalSisaPiutang(
          bayarPiutangModel.piutangId!, nominalPinjam2);

      await piutangCollection.doc(bayarPiutangModel.piutangId).update({
        'totalBayar': totalBayarStr,
        'sisaHutang': updatedSisaPiutangStr,
      });
    } catch (e) {
      print('Error adding bayar piutang: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPiutangById(String piutangId) async {
    final doc = await piutangCollection.doc(piutangId).get();
    final User? user = _auth.currentUser;

    if (doc.exists) {
      final piutangData = doc.data() as Map<String, dynamic>;

      piutangData['userId'] = user?.uid;

      return piutangData;
    } else {
      throw Exception('Hutang not found');
    }
  }

  Future<String> getTotalSisaPiutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final piutang =
            await piutangCollection.where('userId', isEqualTo: user.uid).get();
        double totalSisaPiutang = 0;
        for (var doc in piutang.docs) {
          PiutangModel piutangModel =
              PiutangModel.fromMap(doc.data() as Map<String, dynamic>);
          String nominalDiPinjam = piutangModel.nominalDiPinjam ?? '0';

          String sisaPiutangStr = await calculateTotalSisaPiutang(
              piutangModel.piutangId ?? '', nominalDiPinjam);

          double sisaPiutang = double.tryParse(
                  sisaPiutangStr.replaceAll('.', '').replaceAll(',', '')) ??
              0.0;
          totalSisaPiutang += sisaPiutang;
        }
        return NumberFormat.decimalPattern('id_ID').format(totalSisaPiutang);
      } catch (e) {
        print('Error while getting total sisa piutang: $e');
        return '0';
      }
    }
    return '0';
  }

  Future<void> removePiutang(String piutangId) async {
    try {
      await piutangCollection.doc(piutangId).delete();
    } catch (e) {
      print('Error removing piutang: $e');
      rethrow;
    }
  }

  Stream<List<DocumentSnapshot>> piutangWithoutStatusStream() {
    final User? user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('piutang')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: '')
          .orderBy('tanggalDiPinjam', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<DocumentSnapshot>> piutangHistoryStream() {
    final User? user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('piutang')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'selesai')
          .orderBy('tanggalDiPinjam', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } else {
      return Stream.value([]);
    }
  }

  Future<void> selesaikanPiutang(String piutangId) async {
    try {
      DocumentReference piutangRef =
          _firestore.collection('piutang').doc(piutangId);
      DocumentSnapshot piutangSnapshot = await piutangRef.get();

      if (!piutangSnapshot.exists) {
        throw Exception('Data piutang tidak ditemukan');
      }

      await piutangRef.update({
        'status': 'selesai',
        'tanggalSelesai': DateTime.now().toString(),
      });

      print('Piutang berhasil diselesaikan');
    } catch (e) {
      print('Gagal menyelesaikan piutang: $e');
    }
  }

  void dispose() {
    streamController.close();
  }
}
