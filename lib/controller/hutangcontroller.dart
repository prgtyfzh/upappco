// import 'dart:async';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:intl/intl.dart';
// import 'package:tugasakhir/model/bayarhutangmodel.dart';
// import 'package:tugasakhir/model/hutangmodel.dart';

// class HutangController {
//   final hutangCollection = FirebaseFirestore.instance.collection('hutang');
//   final bayarHutangCollection =
//       FirebaseFirestore.instance.collection('bayarHutang');
//   final StreamController<List<DocumentSnapshot>> streamController =
//       StreamController<List<DocumentSnapshot>>.broadcast();

//       final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   Stream<List<DocumentSnapshot>> get stream => streamController.stream;

//   Future<void> addHutang(HutangModel hutangmodel) async {
//     final hutang = hutangmodel.toMap();

//     final DocumentReference docRef = await hutangCollection.add(hutang);
//     final String docID = docRef.id;

//     final HutangModel updatedHutangModel = HutangModel(
//       hutangId: docID,
//       namaPemberiPinjam: hutangmodel.namaPemberiPinjam,
//       noteleponPemberiPinjam: hutangmodel.noteleponPemberiPinjam,
//       nominalPinjam: hutangmodel.nominalPinjam,
//       tanggalPinjam: hutangmodel.tanggalPinjam,
//       tanggalJatuhTempo: hutangmodel.tanggalJatuhTempo,
//       deskripsi: hutangmodel.deskripsi,
//     );

//     await docRef.update(updatedHutangModel.toMap());
//   }

//   // Future<void> addBayarHutang(BayarHutangModel bayarHutangModel) async {
//   //   final bayarHutang = bayarHutangModel.toMap();

//   //   final DocumentReference docRef =
//   //       await bayarHutangCollection.add(bayarHutang);
//   //   final String docID = docRef.id;

//   //   final BayarHutangModel updatedBayarHutangModel = BayarHutangModel(
//   //     bayarHutangId: docID,
//   //     hutangId: bayarHutangModel.hutangId,
//   //     nominalBayar: bayarHutangModel.nominalBayar,
//   //     tanggalBayar: bayarHutangModel.tanggalBayar,
//   //   );

//   //   await docRef.update(updatedBayarHutangModel.toMap());
//   // }

//   Future<String> getNominalPinjam(String hutangId) async {
//     try {
//       final docSnapshot = await hutangCollection.doc(hutangId).get();
//       if (docSnapshot.exists) {
//         return docSnapshot.data()?['nominalPinjam'] ??
//             '0'; // Assuming nominalPinjam is stored as a string
//       } else {
//         throw Exception('Document with hutangId $hutangId not found');
//       }
//     } catch (e) {
//       print('Error getting nominalPinjam: $e');
//       return '0'; // Return a default value or handle error accordingly
//     }
//   }

//   // Future<void> addBayarHutang(BayarHutangModel bayarHutangModel) async {
//   //   try {
//   //     // Ambil nilai nominal pinjam untuk hutang tertentu
//   //     String nominalPinjam = await getNominalPinjam(bayarHutangModel.hutangId);

//   //     // Hitung total sisa hutang saat ini
//   //     String sisaHutangStr = await calculateTotalSisaHutang(
//   //         bayarHutangModel.hutangId, nominalPinjam);
//   //     double sisaHutang =
//   //         double.parse(sisaHutangStr.replaceAll('.', '').replaceAll(',', '')) ??
//   //             0.0;

//   //     // Ambil nilai nominal bayar dari model
//   //     double nominalBayar = double.parse(bayarHutangModel.nominalBayar
//   //             .replaceAll('.', '')
//   //             .replaceAll(',', '')) ??
//   //         0.0;

//   //     // Validasi nominalBayar tidak boleh melebihi nominalPinjam dan sisaHutang
//   //     if (nominalBayar > sisaHutang) {
//   //       throw Exception('Nominal bayar tidak boleh melebihi sisa hutang');
//   //     }

//   //     final bayarHutang = bayarHutangModel.toMap();

//   //     final DocumentReference docRef =
//   //         await bayarHutangCollection.add(bayarHutang);
//   //     final String docID = docRef.id;

//   //     final BayarHutangModel updatedBayarHutangModel = BayarHutangModel(
//   //       bayarHutangId: docID,
//   //       hutangId: bayarHutangModel.hutangId,
//   //       nominalBayar: bayarHutangModel.nominalBayar,
//   //       tanggalBayar: bayarHutangModel.tanggalBayar,
//   //     );

//   //     await docRef.update(updatedBayarHutangModel.toMap());
//   //   } catch (e) {
//   //     print('Error adding bayar hutang: $e');
//   //     rethrow; // Melempar kembali exception untuk penanganan di level yang lebih tinggi
//   //   }
//   // }

//   Future<void> updateHutang(HutangModel hutangmodel) async {
//     await hutangCollection
//         .doc(hutangmodel.hutangId)
//         .update(hutangmodel.toMap());
//   }

//   // Future<void> removeHutang(String hutangId) async {
//   //   await hutangCollection.doc(hutangId).delete();
//   // }

//   Future<List<DocumentSnapshot>> getHutang() async {
//     final hutang = await hutangCollection.get();
//     streamController.sink.add(hutang.docs);
//     return hutang.docs;
//   }

//   Future<List<DocumentSnapshot>> getHutangSortedByDate() async {
//     final hutang = await hutangCollection.get();
//     List<DocumentSnapshot> hutangDocs = hutang.docs;

//     hutangDocs.sort((a, b) {
//       DateTime dateA = DateFormat('dd-MM-yyyy').parse(a['tanggalPinjam']);
//       DateTime dateB = DateFormat('dd-MM-yyyy').parse(b['tanggalPinjam']);
//       return dateB.compareTo(dateA); // Sort in descending order (latest first)
//     });

//     streamController.sink.add(hutangDocs);
//     return hutangDocs;
//   }

//   Future<String> getTotalHutang() async {
//     try {
//       final hutang = await hutangCollection.get();
//       double total = 0;
//       hutang.docs.forEach((doc) {
//         HutangModel hutangModel =
//             HutangModel.fromMap(doc.data() as Map<String, dynamic>);
//         double nominalPinjam = double.tryParse(hutangModel.nominalPinjam) ?? 0;
//         total += nominalPinjam;
//       });
//       return total.toStringAsFixed(3);
//     } catch (e) {
//       print('Error while getting total pendapatan: $e');
//       return '0';
//     }
//   }

//   // Future<String> calculateTotalSisaHutang(
//   //     String hutangId, String nominalPinjam) async {
//   //   try {
//   //     String totalBayarStr = await getTotalNominalBayar(hutangId);
//   //     double totalBayar =
//   //         double.parse(totalBayarStr.replaceAll('.', '').replaceAll(',', '')) ??
//   //             0.0;
//   //     double nominalPinjamDouble =
//   //         double.parse(nominalPinjam.replaceAll('.', '')) ?? 0.0;

//   //     double sisaHutang = nominalPinjamDouble - totalBayar;

//   //     if (sisaHutang < 0) {
//   //       sisaHutang = 0; // Jika sisa hutang negatif, dianggap sebagai nol
//   //     }

//   //     // Format sisaHutang sebagai number biasa dengan pemisah ribuan
//   //     String formattedSisaHutang =
//   //         NumberFormat.decimalPattern('id_ID').format(sisaHutang);

//   //     return formattedSisaHutang;
//   //   } catch (e) {
//   //     print("Error calculating sisa hutang: $e");
//   //     return '0';
//   //   }
//   // }

//   Future<String> getTotalNominalBayar(String hutangId) async {
//     try {
//       final bayarHutang = await bayarHutangCollection
//           .where('hutangId', isEqualTo: hutangId)
//           .get();

//       double totalBayar = 0;
//       bayarHutang.docs.forEach((doc) {
//         BayarHutangModel bayarHutangModel =
//             BayarHutangModel.fromMap(doc.data() as Map<String, dynamic>);
//         totalBayar += double.parse(bayarHutangModel.nominalBayar
//                 .replaceAll('.', '')
//                 .replaceAll(',', '')) ??
//             0.0;
//       });

//       // Format totalBayar sebagai string dengan pemisah ribuan
//       String formattedTotalBayar =
//           NumberFormat.decimalPattern('id_ID').format(totalBayar);

//       return formattedTotalBayar;
//     } catch (e) {
//       print('Error getting total nominal bayar: $e');
//       return '0';
//     }
//   }

//   Future<String> calculateTotalSisaHutang(
//       String hutangId, String nominalPinjam) async {
//     try {
//       String totalBayarStr = await getTotalNominalBayar(hutangId);
//       double totalBayar = double.tryParse(
//               totalBayarStr.replaceAll('.', '').replaceAll(',', '')) ??
//           0.0;
//       double nominalPinjamDouble =
//           double.tryParse(nominalPinjam.replaceAll('.', '')) ?? 0.0;

//       double sisaHutang = nominalPinjamDouble - totalBayar;

//       if (sisaHutang < 0) {
//         sisaHutang = 0;
//       }

//       String formattedSisaHutang =
//           NumberFormat.decimalPattern('id_ID').format(sisaHutang);

//       return formattedSisaHutang;
//     } catch (e) {
//       print("Error calculating sisa hutang: $e");
//       return '0';
//     }
//   }

//   Future<void> addBayarHutang(BayarHutangModel bayarHutangModel) async {
//     try {
//       // Ambil nilai nominal pinjam untuk hutang tertentu
//       String nominalPinjam = await getNominalPinjam(bayarHutangModel.hutangId);

//       // Hitung total sisa hutang saat ini
//       String sisaHutangStr = await calculateTotalSisaHutang(
//           bayarHutangModel.hutangId ?? '', nominalPinjam ?? '0');
//       double sisaHutang = double.tryParse(
//               sisaHutangStr.replaceAll('.', '').replaceAll(',', '')) ??
//           0.0;

//       // Ambil nilai nominal bayar dari model
//       double nominalBayar = double.tryParse(bayarHutangModel.nominalBayar
//               .replaceAll('.', '')
//               .replaceAll(',', '')) ??
//           0.0;

//       // Validasi nominalBayar tidak boleh melebihi nominalPinjam dan sisaHutang
//       if (nominalBayar > sisaHutang) {
//         throw Exception('Nominal bayar tidak boleh melebihi sisa hutang');
//       }

//       final bayarHutang = bayarHutangModel.toMap();

//       final DocumentReference docRef =
//           await bayarHutangCollection.add(bayarHutang);
//       final String docID = docRef.id;

//       final BayarHutangModel updatedBayarHutangModel = BayarHutangModel(
//         bayarHutangId: docID,
//         hutangId: bayarHutangModel.hutangId,
//         nominalBayar: bayarHutangModel.nominalBayar,
//         tanggalBayar: bayarHutangModel.tanggalBayar,
//       );

//       await docRef.update(updatedBayarHutangModel.toMap());
//     } catch (e) {
//       print('Error adding bayar hutang: $e');
//       rethrow;
//     }
//   }

//   Future<HutangModel> getHutangById(String hutangId) async {
//     final doc = await hutangCollection.doc(hutangId).get();
//     if (doc.exists) {
//       return HutangModel.fromMap(doc.data()!);
//     } else {
//       throw Exception('Hutang not found');
//     }
//   }

//   Future<String> getTotalSisaHutang() async {
//     try {
//       final hutang = await hutangCollection.get();
//       double totalSisaHutang = 0;
//       for (var doc in hutang.docs) {
//         HutangModel hutangModel =
//             HutangModel.fromMap(doc.data() as Map<String, dynamic>);
//         String nominalPinjam = hutangModel.nominalPinjam;
//         String sisaHutangStr = await calculateTotalSisaHutang(
//             hutangModel.hutangId ?? '', nominalPinjam ?? '0');

//         double sisaHutang = double.tryParse(
//                 sisaHutangStr.replaceAll('.', '').replaceAll(',', '')) ??
//             0.0;
//         totalSisaHutang += sisaHutang;
//       }
//       return NumberFormat.decimalPattern('id_ID').format(totalSisaHutang);
//     } catch (e) {
//       print('Error calculating total sisa hutang: $e');
//       return '0';
//     }
//   }

//   Future<void> removeHutang(String hutangId) async {
//     // Implement logic to remove a debt
//     await _firestore.collection('hutang').doc(hutangId).delete();
//   }

//   void moveCompletedDebtsToHistory() {
//     // Query Firestore for debts where sisaHutang == 0
//     // Move these debts to a 'riwayat' collection or mark them as completed
//     _firestore
//         .collection('hutang')
//         .where('sisaHutang', isEqualTo: '0')
//         .get()
//         .then((querySnapshot) {
//       querySnapshot.docs.forEach((doc) async {
//         await _firestore.collection('riwayat').doc(doc.id).set(doc.data());
//         await _firestore.collection('hutang').doc(doc.id).delete();
//       });
//     });
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
import 'package:tugasakhir/model/hutangmodel.dart';

class HutangController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final CollectionReference hutangCollection =
      FirebaseFirestore.instance.collection('hutang');
  final CollectionReference bayarHutangCollection =
      FirebaseFirestore.instance.collection('bayarHutang');
  final StreamController<List<DocumentSnapshot>> streamController =
      StreamController<List<DocumentSnapshot>>.broadcast();

  Stream<List<DocumentSnapshot>> get stream => streamController.stream;

  Future<void> addHutang(HutangModel hutangmodel) async {
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
      );

      await docRef.update(updatedHutangModel.toMap());
    }
  }

  Future<List<BayarHutangModel>> getBayarHutangByHutangId(
      String hutangId) async {
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bayarHutang')
          .where('hutangId', isEqualTo: hutangId)
          .get();

      List<BayarHutangModel> bayarHutangList = querySnapshot.docs.map((doc) {
        return BayarHutangModel(
          bayarHutangId: doc.id,
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

  Future<void> updateHutang(HutangModel hutangmodel) async {
    await hutangCollection
        .doc(hutangmodel.hutangId)
        .update(hutangmodel.toMap());
  }

  Future<List<DocumentSnapshot>> getHutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang =
          await hutangCollection.where('userId', isEqualTo: user.uid).get();
      streamController.sink.add(hutang.docs);
      return hutang.docs;
    }
    return [];
  }

  Future<List<DocumentSnapshot>> getHutangSortedByDate() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang =
          await hutangCollection.where('userId', isEqualTo: user.uid).get();
      List<DocumentSnapshot> hutangDocs = hutang.docs;
      streamController.sink.add(hutangDocs);
      return hutangDocs;
    }
    return [];
  }

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

  Future<List<DocumentSnapshot>> getHutangHistorySortedByDate() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      final hutang =
          await hutangCollection.where('userId', isEqualTo: user.uid).get();
      List<DocumentSnapshot> hutangDocs = hutang.docs;
      streamController.sink.add(hutangDocs);
      return hutangDocs;
    }
    return [];
  }

  Stream<List<DocumentSnapshot>> hutangHistoryStream() {
    return streamController.stream;
  }

  Future<String> getTotalHutang() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      try {
        final hutang =
            await hutangCollection.where('userId', isEqualTo: user.uid).get();
        double total = 0;
        hutang.docs.forEach((doc) {
          HutangModel hutangModel =
              HutangModel.fromMap(doc.data() as Map<String, dynamic>);
          double nominalPinjam =
              double.tryParse(hutangModel.nominalPinjam) ?? 0;
          total += nominalPinjam;
        });
        return total.toStringAsFixed(3);
      } catch (e) {
        print('Error while getting total hutang: $e');
        return '0';
      }
    }
    return '0';
  }

  Future<String> getTotalNominalBayar(String hutangId) async {
    try {
      final bayarHutang = await bayarHutangCollection
          .where('hutangId', isEqualTo: hutangId)
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

  Future<void> addBayarHutang(BayarHutangModel bayarHutangModel) async {
    try {
      String nominalPinjam = await getNominalPinjam(bayarHutangModel.hutangId);
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
          await bayarHutangCollection.add(bayarHutang);
      final String docID = docRef.id;

      final BayarHutangModel updatedBayarHutangModel = BayarHutangModel(
        bayarHutangId: docID,
        hutangId: bayarHutangModel.hutangId,
        nominalBayar: bayarHutangModel.nominalBayar,
        tanggalBayar: bayarHutangModel.tanggalBayar,
      );

      await docRef.update(updatedBayarHutangModel.toMap());
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
          String nominalPinjam = hutangModel.nominalPinjam;
          String sisaHutangStr = await calculateTotalSisaHutang(
              hutangModel.hutangId ?? '', nominalPinjam ?? '0');

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

  Future<void> moveHutangToHistory(String hutangId) async {
    try {
      final DocumentSnapshot snapshot =
          await hutangCollection.doc(hutangId).get();
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        if (data != null) {
          data['userId'] =
              _auth.currentUser!.uid; // Add user ID to the document
          await _firestore.collection('history').doc(hutangId).set(data);
          await hutangCollection.doc(hutangId).delete();
        }
      } else {
        throw Exception('Hutang with id $hutangId does not exist');
      }
    } catch (e) {
      print('Error moving hutang to history: $e');
      rethrow;
    }
  }

  void dispose() {
    streamController.close();
  }
}
