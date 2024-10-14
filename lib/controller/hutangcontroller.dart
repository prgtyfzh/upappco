import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/model/pembayaranmodel.dart';
import 'package:tugasakhir/model/hutangmodel.dart';

class HutangController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference hutangCollection =
      FirebaseFirestore.instance.collection('hutang');
  final CollectionReference pembayaranCollection =
      FirebaseFirestore.instance.collection('pembayaran');
  final CollectionReference piutangCollection =
      FirebaseFirestore.instance.collection('piutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addHutangManual(HutangModel hutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang = hutangmodel.toMap();
      hutang['userId'] = user.uid;
      final DocumentReference docRef = await hutangCollection.add(hutang);
      final String docID = docRef.id;

      final HutangModel updatedHutangModel = HutangModel(
        hutangId: docID,
        namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
        nominalPinjam: hutangmodel.nominalPinjam,
        tanggalPinjam: hutangmodel.tanggalPinjam,
        tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
        deskripsi: hutangmodel.deskripsi,
        totalBayar: '',
        sisaHutang: '',
        status: '',
      );

      await docRef.update(updatedHutangModel.toMap());
    }
  }

  Future<void> addHutang(HutangModel hutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang = hutangmodel.toMap();
      hutang['userId'] = user.uid;
      final DocumentReference docRef =
          hutangCollection.doc(hutangmodel.hutangId);
      await docRef.set(hutang);

      final HutangModel updatedHutangModel = HutangModel(
        hutangId: hutangmodel.hutangId,
        namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
        nominalPinjam: hutangmodel.nominalPinjam,
        tanggalPinjam: hutangmodel.tanggalPinjam,
        tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
        deskripsi: hutangmodel.deskripsi,
        totalBayar: hutangmodel.totalBayar,
        sisaHutang: hutangmodel.sisaHutang,
        status: hutangmodel.status,
      );

      await docRef.update(updatedHutangModel.toMap());
    }
  }

  Future<String> getNominalPinjam(String hutangId) async {
    try {
      final docSnapshot = await hutangCollection.doc(hutangId).get();
      if (docSnapshot.exists) {
        final data = docSnapshot.data() as Map<String, dynamic>?;
        if (data != null && data.containsKey('nominalPinjam')) {
          return data['nominalPinjam'].toString();
        } else {
          return '0';
        }
      } else {
        throw Exception('Document with hutangId $hutangId not found');
      }
    } catch (e) {
      print('Error getting nominalPinjam: $e');
      return '0';
    }
  }

  Future<String> getTotalNominalBayar(String hutangId) async {
    try {
      final bayarHutang = await pembayaranCollection
          .where('hutangId', isEqualTo: hutangId)
          .get();
      double totalBayar = 0;
      bayarHutang.docs.forEach((doc) {
        PembayaranModel bayarHutangModel =
            PembayaranModel.fromMap(doc.data() as Map<String, dynamic>);
        totalBayar += double.tryParse(bayarHutangModel.nominalBayar
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

  Future<String> calculateTotalSisaHutang(
      String hutangId, String nominalPinjam) async {
    try {
      String totalBayarStr = await getTotalNominalBayar(hutangId);
      double totalBayar = double.tryParse(
              totalBayarStr.replaceAll('.', '').replaceAll(',', '')) ??
          0.0;
      double nominalPinjamDouble =
          double.tryParse(nominalPinjam.replaceAll('.', '')) ?? 0.0;

      double sisaHutang = nominalPinjamDouble - totalBayar;
      if (sisaHutang < 0) {
        sisaHutang = 0;
      }

      String formattedSisaHutang =
          NumberFormat.decimalPattern('id_ID').format(sisaHutang);
      return formattedSisaHutang;
    } catch (e) {
      print('Error calculating sisa hutang: $e');
      return '0';
    }
  }

  Future<void> addBayarHutang(PembayaranModel bayarHutangModel) async {
    try {
      String nominalPinjam = await getNominalPinjam(bayarHutangModel.hutangId!);
      String sisaHutangStr = await calculateTotalSisaHutang(
          bayarHutangModel.hutangId ?? '', nominalPinjam ?? '0');
      double sisaHutang = double.tryParse(
              sisaHutangStr.replaceAll('.', '').replaceAll(',', '')) ??
          0.0;

      double nominalBayar = double.tryParse(bayarHutangModel.nominalBayar
              .replaceAll('.', '')
              .replaceAll(',', '')) ??
          0.0;

      if (nominalBayar > sisaHutang) {
        throw Exception('Nominal bayar tidak boleh melebihi sisa hutang');
      }

      final bayarHutang = bayarHutangModel.toMap();
      bayarHutang['userId'] =
          _auth.currentUser!.uid; // Add user ID to the document
      final DocumentReference docRef =
          await pembayaranCollection.add(bayarHutang);
      final String docID = docRef.id;

      final PembayaranModel updatedPembayaranModel = PembayaranModel(
        pembayaranId: docID,
        hutangId: bayarHutangModel.hutangId,
        piutangId: bayarHutangModel.hutangId,
        nominalBayar: bayarHutangModel.nominalBayar,
        tanggalBayar: bayarHutangModel.tanggalBayar,
      );

      await docRef.update(updatedPembayaranModel.toMap());

      // Recalculate totalBayar and sisaHutang
      String totalBayarStr =
          await getTotalNominalBayar(bayarHutangModel.hutangId!);
      String nominalPinjam2 =
          await getNominalPinjam(bayarHutangModel.hutangId!);
      String updatedSisaHutangStr = await calculateTotalSisaHutang(
          bayarHutangModel.hutangId!, nominalPinjam2);

      await hutangCollection.doc(bayarHutangModel.hutangId).update({
        'totalBayar': totalBayarStr,
        'sisaHutang': updatedSisaHutangStr,
      });
    } catch (e) {
      print('Error adding bayar hutang: $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getHutangById(String hutangId) async {
    final doc = await hutangCollection.doc(hutangId).get();
    final User? user = _auth.currentUser;

    if (doc.exists) {
      final hutangData = doc.data() as Map<String, dynamic>;

      hutangData['userId'] = user?.uid;

      return hutangData;
    } else {
      throw Exception('Hutang not found');
    }
  }

  Future<String> getTotalSisaHutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final hutang =
            await hutangCollection.where('userId', isEqualTo: user.uid).get();
        double totalSisaHutang = 0;
        for (var doc in hutang.docs) {
          HutangModel hutangModel =
              HutangModel.fromMap(doc.data() as Map<String, dynamic>);
          String nominalPinjam = hutangModel.nominalPinjam ?? '0';

          String sisaHutangStr = await calculateTotalSisaHutang(
              hutangModel.hutangId ?? '', nominalPinjam);

          double sisaHutang = double.tryParse(
                  sisaHutangStr.replaceAll('.', '').replaceAll(',', '')) ??
              0.0;
          totalSisaHutang += sisaHutang;
        }
        return NumberFormat.decimalPattern('id_ID').format(totalSisaHutang);
      } catch (e) {
        print('Error calculating total sisa hutang: $e');
        return '0';
      }
    }
    return '0';
  }

  Future<void> removeHutang(String hutangId) async {
    try {
      await hutangCollection.doc(hutangId).delete();
    } catch (e) {
      print('Error removing hutang: $e');
      rethrow;
    }
  }

  Stream<List<DocumentSnapshot>> hutangWithoutStatusStream() {
    final User? user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('hutang')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: '')
          .orderBy('tanggalPinjam', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } else {
      return Stream.value([]);
    }
  }

  Stream<List<DocumentSnapshot>> hutangHistoryStream() {
    final User? user = _auth.currentUser;

    if (user != null) {
      return _firestore
          .collection('hutang')
          .where('userId', isEqualTo: user.uid)
          .where('status', isEqualTo: 'selesai')
          .orderBy('tanggalPinjam', descending: true)
          .snapshots()
          .map((querySnapshot) => querySnapshot.docs);
    } else {
      return Stream.value([]);
    }
  }

  Future<void> selesaikanHutang(String hutangId) async {
    try {
      DocumentReference hutangRef =
          _firestore.collection('hutang').doc(hutangId);
      DocumentSnapshot hutangSnapshot = await hutangRef.get();

      if (!hutangSnapshot.exists) {
        throw Exception('Data hutang tidak ditemukan');
      }

      await hutangRef.update({
        'status': 'selesai',
        'tanggalSelesai': DateTime.now().toString(),
      });

      print('Hutang berhasil diselesaikan');
    } catch (e) {
      print('Gagal menyelesaikan hutang: $e');
    }
  }

  void dispose() {
    streamController.close();
  }
}
