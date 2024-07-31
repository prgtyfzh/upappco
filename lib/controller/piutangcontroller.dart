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
        totalBayar: '',
        sisaHutang: '',
      );

      await docRef.update(updatedPiutangModel.toMap());
    }
  }

  Future<void> addPiutang(PiutangModel piutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final piutang = piutangmodel.toMap();
      piutang['userId'] = user.uid; // Add user ID to the document
      final DocumentReference docRef =
          piutangCollection.doc(piutangmodel.piutangId);
      await docRef.set(piutang);

      final PiutangModel updatedPiutangModel = PiutangModel(
        piutangId: piutangmodel.piutangId,
        namaPeminjam: piutangmodel.namaPeminjam,
        noteleponPeminjam: piutangmodel.noteleponPeminjam,
        nominalDiPinjam: piutangmodel.nominalDiPinjam,
        tanggalDiPinjam: piutangmodel.tanggalDiPinjam,
        tanggalJatuhTempo: piutangmodel.tanggalJatuhTempo,
        deskripsi: piutangmodel.deskripsi,
        totalBayar: piutangmodel.totalBayar,
        sisaHutang: piutangmodel.sisaHutang,
      );

      await docRef.update(updatedPiutangModel.toMap());
    }
  }

  // void listenToHutangChanges(String hutangId) {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     // Memonitor perubahan pada dokumen Hutang dengan ID tertentu
  //     FirebaseFirestore.instance
  //         .collection('hutang')
  //         .doc(hutangId)
  //         .snapshots()
  //         .listen((snapshot) {
  //       if (snapshot.exists) {
  //         // Ambil data Hutang yang berubah
  //         final hutangData = snapshot.data();

  //         // Perbarui Piutang yang sesuai dengan Hutang ini
  //         piutangCollection
  //             .where('piutangId',
  //                 isEqualTo:
  //                     hutangData?['hutangId']) // Tambahkan pengecekan null (?)
  //             .get()
  //             .then((querySnapshot) {
  //           if (querySnapshot.docs.isNotEmpty) {
  //             querySnapshot.docs.forEach((doc) {
  //               final updatedPiutang = PiutangModel(
  //                 piutangId: doc['piutangId'],
  //                 namaPeminjam: hutangData?['namaPemberiPinjam'],
  //                 noteleponPeminjam: hutangData?['noteleponPemberiPinjam'],
  //                 nominalDiPinjam: hutangData?['nominalPinjam'],
  //                 tanggalDiPinjam: hutangData?['tanggalPinjam'],
  //                 tanggalJatuhTempo: hutangData?['tanggalJatuhTempo'],
  //                 deskripsi: hutangData?['deskripsi'],
  //                 totalBayar: hutangData?['totalBayar'],
  //                 sisaHutang: hutangData?['sisaHutang'],
  //               );

  //               // Update data Piutang di Firestore
  //               doc.reference.update(updatedPiutang.toMap());
  //             });
  //           }
  //         });
  //       }
  //     });
  //   }
  // }

  // Future<List<BayarHutangModel>> getBayarHutangByHutangId(
  //     String piutangId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('pembayaran')
  //         .where('hutangId', isEqualTo: piutangId)
  //         .get();

  //     List<BayarHutangModel> bayarHutangList = querySnapshot.docs.map((doc) {
  //       return BayarHutangModel(
  //         bayarHutangId: doc.id,
  //         hutangId: doc['piutangId'],
  //         nominalBayar: doc['nominalBayar'],
  //         tanggalBayar: doc['tanggalBayar'],
  //       );
  //     }).toList();

  //     return bayarHutangList;
  //   } catch (e) {
  //     print('Error fetching BayarHutang data: $e');
  //     throw Exception('Failed to get BayarHutang data');
  //   }
  // }

  Future<List<PembayaranModel>> getBayarHutangByPiutangId(
      String piutangId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pembayaran')
          .where('piutangId', isEqualTo: piutangId)
          .get();

      List<PembayaranModel> bayarHutangList = querySnapshot.docs.map((doc) {
        return PembayaranModel(
          pembayaranId: doc.id,
          piutangId: doc['piutangId'],
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

  // Future<List<DocumentSnapshot>> getPiutang() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final piutang =
  //         await piutangCollection.where('userId', isEqualTo: user.uid).get();
  //     streamController.sink.add(piutang.docs);
  //     return piutang.docs;
  //   }
  //   return [];
  // }

  // Future<List<DocumentSnapshot>> getPiutangSortedByDate() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final piutang =
  //         await piutangCollection.where('userId', isEqualTo: user.uid).get();
  //     List<DocumentSnapshot> piutangDocs = piutang.docs;
  //     streamController.sink.add(piutangDocs);
  //     return piutangDocs;
  //   }
  //   return [];
  // }

  Future<List<DocumentSnapshot>> getPiutangSortedByDate(
      {bool sortedByDate = false}) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      Query query = piutangCollection.where('userId', isEqualTo: user.uid);

      if (sortedByDate) {
        query = query.orderBy(
            'tanggalDiPinjam'); // Assuming 'tanggal' is the field name for date.
      }

      final piutang = await query.get();
      List<DocumentSnapshot> piutangDocs = piutang.docs;
      streamController.sink.add(piutangDocs);
      return piutangDocs;
    }
    return [];
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

  Future<PiutangModel> getPiutangById(String piutangId) async {
    final doc = await piutangCollection.doc(piutangId).get();
    if (doc.exists) {
      return PiutangModel.fromMap(doc.data() as Map<String, dynamic>);
    } else {
      throw Exception('Piutang not found');
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

  // Future<void> movePiutangToHistory(String piutangId) async {
  //   try {
  //     final DocumentSnapshot snapshot =
  //         await piutangCollection.doc(piutangId).get();
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         data['userId'] =
  //             _auth.currentUser!.uid; // Add user ID to the document
  //         await _firestore.collection('history').doc(piutangId).set(data);
  //         await piutangCollection.doc(piutangId).delete();
  //       }
  //     } else {
  //       throw Exception('Hutang with id $piutangId does not exist');
  //     }
  //   } catch (e) {
  //     print('Error moving hutang to history: $e');
  //     rethrow;
  //   }
  // }

  Future<void> removePiutang(String piutangId) async {
    await piutangCollection.doc(piutangId).delete();
  }

  Stream<List<DocumentSnapshot>> piutangHistoryStream() {
    return _firestore
        .collection('history')
        .orderBy('tanggalDiPinjam')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  Future<void> movePiutangToHistory(String piutangId) async {
    try {
      DocumentSnapshot piutangSnapshot =
          await _firestore.collection('piutang').doc(piutangId).get();
      if (piutangSnapshot.exists) {
        Map<String, dynamic> piutangData =
            piutangSnapshot.data() as Map<String, dynamic>;

        // Move data to history collection
        await _firestore.collection('history').doc(piutangId).set(piutangData);

        // Delete from hutang collection
        await _firestore.collection('piutang').doc(piutangId).delete();
      }
    } catch (e) {
      print('Error moving hutang to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistorySortedByDate() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('history')
          .orderBy('tanggalDiPinjam')
          .get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching history sorted by date: $e');
      return [];
    }
  }

  // Future<List<DocumentSnapshot>> getPiutangHistorySortedByDate() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final piutang =
  //         await piutangCollection.where('userId', isEqualTo: user.uid).get();
  //     List<DocumentSnapshot> piutangDocs = piutang.docs;
  //     streamController.sink.add(piutangDocs);
  //     return piutangDocs;
  //   }
  //   return [];
  // }

  // Future<String> getTotalPiutang() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     try {
  //       final piutang =
  //           await piutangCollection.where('userId', isEqualTo: user.uid).get();
  //       double total = 0;
  //       piutang.docs.forEach((doc) {
  //         PiutangModel piutangModel =
  //             PiutangModel.fromMap(doc.data() as Map<String, dynamic>);
  //         double nominalDiPinjam =
  //             double.tryParse(piutangModel.nominalDiPinjam!) ?? 0;
  //         total += nominalDiPinjam;
  //       });
  //       return total.toStringAsFixed(3);
  //     } catch (e) {
  //       print('Error while getting total piutang: $e');
  //       return '0';
  //     }
  //   }
  //   return '0';
  // }

  // Future<void> updatePiutangWithPayments(
  //     String piutangId, double totalBayar, double sisaPiutang) async {
  //   try {
  //     await piutangCollection.doc(piutangId).update({
  //       'totalBayar': FieldValue.increment(totalBayar),
  //       'sisaPiutang': FieldValue.increment(-sisaPiutang),
  //     });
  //   } catch (e) {
  //     throw Exception('Failed to update Piutang with payments: $e');
  //   }
  // }

  void dispose() {
    streamController.close();
  }
}
