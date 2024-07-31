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
      hutang['userId'] = user.uid; // Add user ID to the document
      final DocumentReference docRef = await hutangCollection.add(hutang);
      final String docID = docRef.id;

      final HutangModel updatedHutangModel = HutangModel(
        hutangId: docID,
        namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
        noteleponPemberiPinjam: hutangmodel.noteleponPemberiPinjam,
        nominalPinjam: hutangmodel.nominalPinjam,
        tanggalPinjam: hutangmodel.tanggalPinjam,
        tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
        deskripsi: hutangmodel.deskripsi,
        totalBayar: '',
        sisaHutang: '',
      );

      await docRef.update(updatedHutangModel.toMap());
    }
  }

  Future<void> addHutang(HutangModel hutangmodel) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang = hutangmodel.toMap();
      hutang['userId'] = user.uid; // Add user ID to the document
      final DocumentReference docRef =
          hutangCollection.doc(hutangmodel.hutangId);
      await docRef.set(hutang);

      final HutangModel updatedHutangModel = HutangModel(
        hutangId: hutangmodel.hutangId,
        namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
        noteleponPemberiPinjam: hutangmodel.noteleponPemberiPinjam,
        nominalPinjam: hutangmodel.nominalPinjam,
        tanggalPinjam: hutangmodel.tanggalPinjam,
        tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
        deskripsi: hutangmodel.deskripsi,
        totalBayar: hutangmodel.totalBayar,
        sisaHutang: hutangmodel.sisaHutang,
      );

      await docRef.update(updatedHutangModel.toMap());
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

  Future<List<PembayaranModel>> getBayarHutangByHutangId(
      String hutangId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('pembayaran')
          .where('hutangId', isEqualTo: hutangId)
          .get();

      List<PembayaranModel> bayarHutangList = querySnapshot.docs.map((doc) {
        return PembayaranModel(
          pembayaranId: doc.id,
          hutangId: doc['hutangId'],
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

  // Future<List<DocumentSnapshot>> getHutang() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final hutang =
  //         await hutangCollection.where('userId', isEqualTo: user.uid).get();
  //     streamController.sink.add(hutang.docs);
  //     return hutang.docs;
  //   }
  //   return [];
  // }

  // Future<List<DocumentSnapshot>> getHutangSortedByDate() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final hutang =
  //         await hutangCollection.where('userId', isEqualTo: user.uid).get();
  //     List<DocumentSnapshot> hutangDocs = hutang.docs;
  //     streamController.sink.add(hutangDocs);
  //     return hutangDocs;
  //   }
  //   return [];
  // }

  Future<List<DocumentSnapshot>> getHutangSortedByDate(
      {bool sortedByDate = false}) async {
    final User? user = _auth.currentUser;
    if (user != null) {
      Query query = hutangCollection.where('userId', isEqualTo: user.uid);

      if (sortedByDate) {
        query = query.orderBy(
            'tanggalPinjam'); // Assuming 'tanggal' is the field name for date.
      }

      final hutang = await query.get();
      List<DocumentSnapshot> hutangDocs = hutang.docs;
      streamController.sink.add(hutangDocs);
      return hutangDocs;
    }
    return [];
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

  Future<HutangModel> getHutangById(String hutangId) async {
    final doc = await hutangCollection.doc(hutangId).get();
    if (doc.exists) {
      return HutangModel.fromMap(doc.data() as Map<String, dynamic>);
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

  // Future<void> moveHutangToHistory(String hutangId) async {
  //   try {
  //     final DocumentSnapshot snapshot =
  //         await hutangCollection.doc(hutangId).get();
  //     if (snapshot.exists) {
  //       final data = snapshot.data() as Map<String, dynamic>?;
  //       if (data != null) {
  //         data['userId'] =
  //             _auth.currentUser!.uid; // Add user ID to the document
  //         await _firestore.collection('history').doc(hutangId).set(data);
  //         await hutangCollection.doc(hutangId).delete();
  //       }
  //     } else {
  //       throw Exception('Hutang with id $hutangId does not exist');
  //     }
  //   } catch (e) {
  //     print('Error moving hutang to history: $e');
  //     rethrow;
  //   }
  // }

  Future<void> removeHutang(String hutangId) async {
    try {
      await hutangCollection.doc(hutangId).delete();
    } catch (e) {
      print('Error removing hutang: $e');
      rethrow;
    }
  }

  Stream<List<DocumentSnapshot>> hutangHistoryStream() {
    return _firestore
        .collection('history')
        .orderBy('tanggalPinjam')
        .snapshots()
        .map((querySnapshot) => querySnapshot.docs);
  }

  Future<void> moveHutangToHistory(String hutangId) async {
    try {
      DocumentSnapshot hutangSnapshot =
          await _firestore.collection('hutang').doc(hutangId).get();
      if (hutangSnapshot.exists) {
        Map<String, dynamic> hutangData =
            hutangSnapshot.data() as Map<String, dynamic>;

        // Move data to history collection
        await _firestore.collection('history').doc(hutangId).set(hutangData);

        // Delete from hutang collection
        await _firestore.collection('hutang').doc(hutangId).delete();
      }
    } catch (e) {
      print('Error moving hutang to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistorySortedByDate() async {
    try {
      QuerySnapshot querySnapshot =
          await _firestore.collection('history').orderBy('tanggalPinjam').get();
      return querySnapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print('Error fetching history sorted by date: $e');
      return [];
    }
  }

  // Future<String> getTotalHutang() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     try {
  //       final hutang =
  //           await hutangCollection.where('userId', isEqualTo: user.uid).get();
  //       double total = 0;
  //       hutang.docs.forEach((doc) {
  //         HutangModel hutangModel =
  //             HutangModel.fromMap(doc.data() as Map<String, dynamic>);
  //         double nominalPinjam =
  //             double.tryParse(hutangModel.nominalPinjam!) ?? 0;
  //         total += nominalPinjam;
  //       });
  //       return total.toStringAsFixed(3);
  //     } catch (e) {
  //       print('Error while getting total hutang: $e');
  //       return '0';
  //     }
  //   }
  //   return '0';
  // }

  // Future<void> updateHutangWithPayments(
  //     String hutangId, double totalBayar, double sisaHutang) async {
  //   try {
  //     await hutangCollection.doc(hutangId).update({
  //       'totalBayar': FieldValue.increment(totalBayar),
  //       'sisaHutang': FieldValue.increment(-sisaHutang),
  //     });
  //   } catch (e) {
  //     throw Exception('Failed to update Hutang with payments: $e');
  //   }
  // }

  // // Method to get nominal pinjam by hutangId
  // Future<String?> getNominalPinjam(String hutangId) async {
  //   try {
  //     DocumentSnapshot doc =
  //         await _firestore.collection('hutang').doc(hutangId).get();
  //     if (doc.exists) {
  //       return doc.data()?['nominalPinjam'].toString();
  //     }
  //     return null;
  //   } catch (e) {
  //     print('Error getting nominal pinjam: $e');
  //     return null;
  //   }
  // }

  // Stream<List<DocumentSnapshot<Object?>>> getHutangHistorySortedByDate() {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     return _firestore
  //         .collection('history')
  //         .where('userId', isEqualTo: user.uid)
  //         .where('status', isEqualTo: 'selesai')
  //         .orderBy('tanggalJatuhTempo', descending: true)
  //         .snapshots()
  //         .map((snapshot) => snapshot.docs.toList());
  //   }
  //   return Stream.value([]);
  // }

  // Future<List<DocumentSnapshot>> getHutangHistorySortedByDate() async {
  //   final User? user = _auth.currentUser;
  //   if (user != null) {
  //     final hutang =
  //         await hutangCollection.where('userId', isEqualTo: user.uid).get();
  //     List<DocumentSnapshot> hutangDocs = hutang.docs;
  //     streamController.sink.add(hutangDocs);
  //     return hutangDocs;
  //   }
  //   return [];
  // }

  Future<String> getSisaHutang(String hutangId, String nominalPinjam) async {
    return await calculateTotalSisaHutang(hutangId, nominalPinjam);
  }

  Future<String> getTotalBayar(String hutangId) async {
    return await getTotalNominalBayar(hutangId);
  }

  double calculateProgress(String nominalPinjam, String totalBayar) {
    double nominalPinjamValue =
        double.parse(nominalPinjam.replaceAll('.', '').replaceAll(',', ''));
    double totalBayarValue =
        double.parse(totalBayar.replaceAll('.', '').replaceAll(',', ''));
    double progress = totalBayarValue / nominalPinjamValue;
    return progress > 1.0 ? 1.0 : progress;
  }

  void dispose() {
    streamController.close();
  }
}
