// import 'dart:async';

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// import '../model/piutangmodel.dart';

// class PiutangController {
//   final piutangCollection = FirebaseFirestore.instance.collection('piutang');
//   final StreamController<List<DocumentSnapshot>> streamController =
//       StreamController<List<DocumentSnapshot>>.broadcast();

//   Stream<List<DocumentSnapshot>> get stream => streamController.stream;
//   List<DocumentSnapshot> currentData = [];
//   List<PiutangModel> piutangList = [];

//   Future<void> addPiutang(PiutangModel piutangmodel) async {
//     final piutang = piutangmodel.toMap();
//     final DocumentReference docRef = await piutangCollection.add(piutang);
//     final String docID = docRef.id;
//     final PiutangModel piutangModel = PiutangModel(
//       piutangId: docID,
//       namaPeminjam: piutangmodel.namaPeminjam,
//       noteleponPeminjam: piutangmodel.noteleponPeminjam,
//       nominalDiPinjam: piutangmodel.nominalDiPinjam,
//       tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
//       tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
//       deskripsi: piutangmodel.deskripsi,
//     );

//     await docRef.update(piutangModel.toMap());
//   }

//   Future<void> updatePiutang(PiutangModel piutangmodel) async {
//     final PiutangModel piutangModel = PiutangModel(
//       piutangId: piutangmodel.piutangId,
//       namaPeminjam: piutangmodel.namaPeminjam,
//       noteleponPeminjam: piutangmodel.noteleponPeminjam,
//       nominalDiPinjam: piutangmodel.nominalDiPinjam,
//       tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
//       tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
//       deskripsi: piutangmodel.deskripsi,
//     );

//     await piutangCollection
//         .doc(piutangmodel.piutangId)
//         .update(piutangModel.toMap());
//   }

//   Future<void> removePiutang(String piutangId) async {
//     await piutangCollection.doc(piutangId).delete();
//   }

//   Future getPiutang() async {
//     final piutang = await piutangCollection.get();
//     streamController.sink.add(piutang.docs);
//     return piutang.docs;
//   }

//   final StreamController<Barcode> _barcodeController =
//       StreamController<Barcode>.broadcast();

//   Stream<Barcode> get barcodeStream => _barcodeController.stream;

//   QRViewController? controller;

//   void startScanner() {
//     _barcodeController.stream.listen((barcode) {
//       // Handle barcode data here
//     });
//   }

//   void onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) {
//       _barcodeController.add(scanData);
//     });
//   }

//   // Method untuk menambah data piutang ke dalam piutangList
//   void addPiutangQR(PiutangModel piutang) {
//     if (!isPiutangExists(piutang)) {
//       piutangList.add(piutang);
//     }
//   }

//   // Method untuk mengecek apakah data piutang sudah ada
//   bool isPiutangExists(PiutangModel piutang) {
//     for (var existingPiutang in piutangList) {
//       if (existingPiutang.namaPeminjam == piutang.namaPeminjam &&
//           existingPiutang.noteleponPeminjam == piutang.noteleponPeminjam &&
//           existingPiutang.nominalDiPinjam == piutang.nominalDiPinjam &&
//           existingPiutang.tanggalDiPinjam == piutang.tanggalDiPinjam &&
//           existingPiutang.tanggalJatuhTempo == piutang.tanggalJatuhTempo &&
//           existingPiutang.deskripsi == piutang.deskripsi) {
//         return true;
//       }
//     }
//     return false;
//   }

//   void dispose() {
//     streamController.close();
//   }
// }

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/model/bayarhutangmodel.dart';

import 'package:tugasakhir/model/piutangmodel.dart';

class PiutangController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference piutangCollection =
      FirebaseFirestore.instance.collection('piutang');
  final CollectionReference bayarHutangCollection =
      FirebaseFirestore.instance.collection('bayarHutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addPiutang(PiutangModel piutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang = piutangmodel.toMap();
      piutang['userId'] = user.uid; // Add user ID to the document
      final DocumentReference docRef = await piutangCollection.add(piutang);
      final String docID = docRef.id;

      final PiutangModel updatedPiutangModel = PiutangModel(
        piutangId: docID,
        namaPeminjam: piutangmodel.namaPeminjam,
        noteleponPeminjam: piutangmodel.noteleponPeminjam,
        nominalDiPinjam: piutangmodel.nominalDiPinjam,
        tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
        tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
        deskripsi: piutangmodel.deskripsi,
      );

      await docRef.update(updatedPiutangModel.toMap());
    }
  }

  Future<List<BayarHutangModel>> getBayarHutangByHutangId(
      String piutangId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bayarHutang')
          .where('hutangId', isEqualTo: piutangId)
          .get();

      List<BayarHutangModel> bayarHutangList = querySnapshot.docs.map((doc) {
        return BayarHutangModel(
          bayarHutangId: doc.id,
          hutangId: doc['piutangId'],
          nominalBayar: doc['nominalBayar'],
          tanggalBayar: doc['tanggalBayar'],
        );
      }).toList();

      return bayarHutangList;
    } catch (e) {
      print('Error fetching BayarHutang data: $e');
      throw Exception('Failed to get BayarHutang data');
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

  Future<List<DocumentSnapshot>> getPiutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang =
          await piutangCollection.where('userId', isEqualTo: user.uid).get();
      streamController.sink.add(piutang.docs);
      return piutang.docs;
    }
    return [];
  }

  Future<List<DocumentSnapshot>> getPiutangSortedByDate() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang =
          await piutangCollection.where('userId', isEqualTo: user.uid).get();
      List<DocumentSnapshot> piutangDocs = piutang.docs;
      streamController.sink.add(piutangDocs);
      return piutangDocs;
    }
    return [];
  }

  Future<List<DocumentSnapshot>> getPiutangHistorySortedByDate() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang =
          await piutangCollection.where('userId', isEqualTo: user.uid).get();
      List<DocumentSnapshot> piutangDocs = piutang.docs;
      streamController.sink.add(piutangDocs);
      return piutangDocs;
    }
    return [];
  }

  Stream<List<DocumentSnapshot>> piutangHistoryStream() {
    return streamController.stream;
  }

  Future<String> getTotalPiutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final piutang =
            await piutangCollection.where('userId', isEqualTo: user.uid).get();
        double total = 0;
        piutang.docs.forEach((doc) {
          PiutangModel piutangModel =
              PiutangModel.fromMap(doc.data() as Map<String, dynamic>);
          double nominalDiPinjam =
              double.tryParse(piutangModel.nominalDiPinjam) ?? 0;
          total += nominalDiPinjam;
        });
        return total.toStringAsFixed(3);
      } catch (e) {
        print('Error while getting total piutang: $e');
        return '0';
      }
    }
    return '0';
  }

  Future<String> getTotalNominalBayar(String piutangId) async {
    try {
      final bayarHutang = await bayarHutangCollection
          .where('piutangId', isEqualTo: piutangId)
          .get();
      double totalBayar = 0;
      bayarHutang.docs.forEach((doc) {
        BayarHutangModel bayarHutangModel =
            BayarHutangModel.fromMap(doc.data() as Map<String, dynamic>);
        totalBayar += double.parse(bayarHutangModel.nominalBayar
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
      String piutangId, String nominalPinjam) async {
    try {
      String totalBayarStr = await getTotalNominalBayar(
          piutangId); // Assuming piutangId is a non-nullable String
      double totalBayar = double.tryParse(
              totalBayarStr.replaceAll('.', '').replaceAll(',', '')) ??
          0.0;
      double nominalPinjamDouble =
          double.tryParse(nominalPinjam.replaceAll('.', '')) ?? 0.0;

      double sisaPiutang = nominalPinjamDouble - totalBayar;
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

  Future<PiutangModel> getPiutangById(String piutangId) async {
    final doc = await piutangCollection.doc(piutangId).get();
    if (doc.exists) {
      return PiutangModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Piutang not found');
    }
  }

  Future<void> removePiutang(String piutangId) async {
    await piutangCollection.doc(piutangId).delete();
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
          String nominalDiPinjam = piutangModel.nominalDiPinjam ??
              '0'; // Handle potential null value
          double nominalDiPinjamDouble =
              double.tryParse(nominalDiPinjam.replaceAll('.', '')) ?? 0.0;

          String totalNominalBayar = await getTotalNominalBayar(
              piutangModel.piutangId ?? ''); // Ensure piutangId is non-null
          double totalNominalBayarDouble =
              double.tryParse(totalNominalBayar.replaceAll('.', '')) ?? 0.0;

          totalSisaPiutang += nominalDiPinjamDouble - totalNominalBayarDouble;
        }
        return totalSisaPiutang.toStringAsFixed(3);
      } catch (e) {
        print('Error while getting total sisa piutang: $e');
        return '0';
      }
    }
    return '0';
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

  void dispose() {
    streamController.close();
  }
}
