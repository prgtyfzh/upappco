import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/piutangmodel.dart';
import 'package:tugasakhir/view/piutang.dart';

class QRCodeScanPiutang extends StatefulWidget {
  @override
  _QRCodeScanPiutangState createState() => _QRCodeScanPiutangState();
}

class _QRCodeScanPiutangState extends State<QRCodeScanPiutang> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final PiutangController _piutangController = PiutangController();

  @override
  void reassemble() {
    super.reassemble();
    if (controller != null) {
      controller!.pauseCamera();
      controller!.resumeCamera();
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code Hutang'),
      ),
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          if (result != null) _buildResultDialog(result!.code!),
        ],
      ),
    );
  }

  Widget _buildResultDialog(String qrCodeData) {
    try {
      final Map<String, dynamic> data = jsonDecode(qrCodeData);
      print('Decoded QR data: $data');

      if (data.containsKey('hutang')) {
        return _buildPiutangDialog(data);
      } else {
        throw FormatException('Data QR code tidak sesuai dengan Hutang');
      }
    } catch (e) {
      print('Error decoding or handling QR data: $e');
      WidgetsBinding.instance!.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid QR code data')),
        );
      });
      return Container();
    }
  }

  Widget _buildPiutangDialog(Map<String, dynamic> data) {
    return AlertDialog(
      title: const Text('Data dari QR Code Hutang'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Nama Pemberi Pinjam: ${data['hutang']['namaPemberiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Nomor Telepon: ${data['hutang']['noteleponPemberiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Nominal Pinjam: ${data['hutang']['nominalPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Pinjam: ${data['hutang']['tanggalPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Jatuh Tempo: ${data['hutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
            Text(
                'Deskripsi: ${data['hutang']['deskripsi'] ?? 'Data tidak tersedia'}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            _handleConvertAndSavePiutangData(data);
          },
          child: const Text('Konversi dan Simpan Data'),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              result = null;
            });
            controller!.resumeCamera();
          },
          child: const Text('Tutup'),
        ),
      ],
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        result = scanData;
        controller.pauseCamera();
      });
    });
  }

  void _handleConvertAndSavePiutangData(Map<String, dynamic> data) {
    try {
      final PiutangModel piutangModel = PiutangModel(
        piutangId: data['hutang']['hutangId'] ?? '',
        namaPeminjam: data['hutang']['namaPemberiPinjam'] ?? '',
        noteleponPeminjam: data['hutang']['noteleponPemberiPinjam'] ?? '',
        nominalDiPinjam: data['hutang']['nominalPinjam'] ?? 0.0,
        tanggalDiPinjam: data['hutang']['tanggalPinjam'] ?? '',
        tanggalJatuhTempo: data['hutang']['tanggalJatuhTempo'] ?? '',
        deskripsi: data['hutang']['deskripsi'] ?? '',
      );

      _piutangController.addPiutang(piutangModel).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Piutang berhasil disimpan')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Piutang()),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data Piutang')),
        );
      });
    } catch (e) {
      print('Error saving Piutang data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';

// class QRCodeScanPiutang extends StatefulWidget {
//   @override
//   _QRCodeScanPiutangState createState() => _QRCodeScanPiutangState();
// }

// class _QRCodeScanPiutangState extends State<QRCodeScanPiutang> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;

//   @override
//   void initState() {
//     super.initState();
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code Piutang'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//           ),
//           if (result != null) _buildResultDialog(result!.code!),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultDialog(String qrCodeData) {
//     try {
//       final Map<String, dynamic> data = jsonDecode(qrCodeData);
//       print('Decoded QR data: $data');

//       if (data.containsKey('hutang')) {
//         return _buildHutangDialog(data);
//       } else {
//         throw FormatException('Data QR code tidak sesuai dengan Hutang');
//       }
//     } catch (e) {
//       print('Error decoding or handling QR data: $e');
//       WidgetsBinding.instance!.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid QR code data')),
//         );
//       });
//       return Container();
//     }
//   }

//   Widget _buildHutangDialog(Map<String, dynamic> data) {
//     return AlertDialog(
//       title: const Text('Data dari QR Code Hutang'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//                 'Nama Pemberi Pinjam: ${data['hutang']['namaPemberiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Nomor Telepon: ${data['hutang']['noteleponPemberiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Nominal Pinjam: ${data['pinjam']['nominalPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Total Bayar: ${data['bayarHutang']['totalBayar'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Sisa Hutang: ${data['bayarHutang']['sisaHutang'] ?? 'Data tidak tersedia'}'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             _handleConvertAndSaveHutangData(data);
//           },
//           child: const Text('Konversi dan Simpan Data'),
//         ),
//         TextButton(
//           onPressed: () {
//             setState(() {
//               result = null;
//             });
//             controller!.resumeCamera();
//           },
//           child: const Text('Tutup'),
//         ),
//       ],
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         controller.pauseCamera();
//       });
//     });
//   }

//   void _handleConvertAndSaveHutangData(Map<String, dynamic> data) {
//     // Simpan data hutang ke Firestore
//     _firestore.collection('hutang').add({
//       'namaPemberiPinjam': data['hutang']['namaPemberiPinjam'] ?? '',
//       'noteleponPemberiPinjam': data['hutang']['noteleponPemberiPinjam'] ?? '',
//       'nominalPinjam': data['pinjam']['nominalPinjam'] ?? 0.0,
//       'tanggalPinjam': data['hutang']['tanggalPinjam'] ?? '',
//       'tanggalJatuhTempo': data['hutang']['tanggalJatuhTempo'] ?? '',
//       'deskripsi': data['hutang']['deskripsi'] ?? '',
//     }).then((_) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Data Hutang berhasil disimpan')),
//       );

//       // Implementasi listener untuk perubahan data Hutang di Firestore User A
//       _listenForHutangChanges(data['hutang']['hutangId']);
//     }).catchError((e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Gagal menyimpan data Hutang')),
//       );
//     });
//   }

//   void _listenForHutangChanges(String hutangId) {
//     // Implementasi listener untuk perubahan data Hutang di Firestore User A
//     _firestore
//         .collection('hutang')
//         .doc(hutangId)
//         .snapshots()
//         .listen((snapshot) {
//       if (snapshot.exists) {
//         final updatedData = snapshot.data() as Map<String, dynamic>;
//         // Update data hutang di Firestore User B sesuai perubahan dari Hutang di User A
//         _firestore.collection('hutang').doc(snapshot.id).update({
//           'namaPemberiPinjam': updatedData['namaPemberiPinjam'] ?? '',
//           'noteleponPemberiPinjam': updatedData['noteleponPemberiPinjam'] ?? '',
//           'nominalPinjam': updatedData['nominalPinjam'] ?? 0.0,
//           'tanggalPinjam': updatedData['tanggalPinjam'] ?? '',
//           'tanggalJatuhTempo': updatedData['tanggalJatuhTempo'] ?? '',
//           'deskripsi': updatedData['deskripsi'] ?? '',
//         }).then((_) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Data Hutang berhasil diperbarui')),
//           );
//         }).catchError((e) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Gagal memperbarui data Hutang')),
//           );
//         });
//       }
//     });
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';
// import 'package:tugasakhir/model/hutangmodel.dart';
// import 'package:tugasakhir/view/hutang.dart';

// class QRCodeScanPiutang extends StatefulWidget {
//   @override
//   _QRCodeScanPiutangState createState() => _QRCodeScanPiutangState();
// }

// class _QRCodeScanPiutangState extends State<QRCodeScanPiutang> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   final HutangController _hutangController = HutangController();

//   @override
//   void reassemble() {
//     super.reassemble();
//     if (controller != null) {
//       controller!.pauseCamera();
//       controller!.resumeCamera();
//     }
//   }

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code Hutang'),
//       ),
//       body: Stack(
//         alignment: Alignment.center,
//         children: <Widget>[
//           QRView(
//             key: qrKey,
//             onQRViewCreated: _onQRViewCreated,
//           ),
//           if (result != null) _buildResultDialog(result!.code!),
//         ],
//       ),
//     );
//   }

//   Widget _buildResultDialog(String qrCodeData) {
//     try {
//       final Map<String, dynamic> data = jsonDecode(qrCodeData);
//       print('Decoded QR data: $data');

//       if (data.containsKey('hutang')) {
//         return _buildHutangDialog(data);
//       } else {
//         throw FormatException('Data QR code tidak sesuai dengan Hutang');
//       }
//     } catch (e) {
//       print('Error decoding or handling QR data: $e');
//       WidgetsBinding.instance!.addPostFrameCallback((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Invalid QR code data')),
//         );
//       });
//       return Container();
//     }
//   }

//   Widget _buildHutangDialog(Map<String, dynamic> data) {
//     return AlertDialog(
//       title: const Text('Data dari QR Code Hutang'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//                 'Nama Pemberi Pinjam: ${data['hutang']['namaPemberiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Nomor Telepon: ${data['hutang']['noteleponPemberiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Nominal Pinjam: ${data['hutang']['nominalPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Tanggal Pinjam: ${data['hutang']['tanggalPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Tanggal Jatuh Tempo: ${data['hutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Deskripsi: ${data['hutang']['deskripsi'] ?? 'Data tidak tersedia'}'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             _handleSaveHutangData(data);
//           },
//           child: const Text('Simpan Data'),
//         ),
//         TextButton(
//           onPressed: () {
//             setState(() {
//               result = null;
//             });
//             controller!.resumeCamera();
//           },
//           child: const Text('Tutup'),
//         ),
//       ],
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     setState(() {
//       this.controller = controller;
//     });
//     controller.scannedDataStream.listen((scanData) {
//       setState(() {
//         result = scanData;
//         controller.pauseCamera();
//       });
//     });
//   }

//   void _handleSaveHutangData(Map<String, dynamic> data) {
//     try {
//       final HutangModel hutangModel = HutangModel(
//         hutangId: data['hutang']['hutangId'] ?? '',
//         namaPemberiPinjam: data['hutang']['namaPemberiPinjam'] ?? '',
//         noteleponPemberiPinjam: data['hutang']['noteleponPemberiPinjam'] ?? '',
//         nominalPinjam: data['hutang']['nominalPinjam'] ?? 0.0,
//         tanggalPinjam: data['hutang']['tanggalPinjam'] ?? '',
//         tanggalJatuhTempo: data['hutang']['tanggalJatuhTempo'] ?? '',
//         deskripsi: data['hutang']['deskripsi'] ?? '',
//       );

//       _hutangController.addHutang(hutangModel).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Data Hutang berhasil disimpan')),
//         );
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Hutang()),
//         );
//       }).catchError((e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Gagal menyimpan data Hutang')),
//         );
//       });
//     } catch (e) {
//       print('Error saving Hutang data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Gagal menyimpan data')),
//       );
//     }
//   }
// }

// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';
// import 'package:tugasakhir/model/hutangmodel.dart';
// import 'package:tugasakhir/view/piutang.dart';

// class QRCodeScanPiutang extends StatefulWidget {
//   @override
//   _QRCodeScanPiutangState createState() => _QRCodeScanPiutangState();
// }

// class _QRCodeScanPiutangState extends State<QRCodeScanPiutang> {
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   QRViewController? controller;

//   @override
//   void dispose() {
//     controller?.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Scan QR Code'),
//       ),
//       body: QRView(
//         key: qrKey,
//         onQRViewCreated: _onQRViewCreated,
//       ),
//     );
//   }

//   void _onQRViewCreated(QRViewController controller) {
//     this.controller = controller;
//     controller.scannedDataStream.listen((scanData) async {
//       if (scanData.code != null) {
//         final data = json.decode(scanData.code!);
//         if (data['hutang'] != null && data['hutang']['hutangId'] != null) {
//           String hutangId = data['hutang']['hutangId'];
//           await _fetchAndDisplayData(hutangId);
//         } else {
//           // Handle case where hutangId or necessary data is null
//           print('Invalid QR code data');
//           // Optionally show an alert or handle the error appropriately
//         }
//       } else {
//         // Handle case where scanData.code is null
//         print('Empty QR code data');
//         // Optionally show an alert or handle the error appropriately
//       }
//     });
//   }

//   Future<void> _fetchAndDisplayData(String hutangId) async {
//     final HutangController hutangController = HutangController();

//     // Fetch hutang data by hutangId
//     final HutangModel hutang = await hutangController.getHutangById(hutangId);

//     // Calculate total nominal bayar
//     final totalBayar = await hutangController.getTotalNominalBayar(hutangId);

//     // Calculate sisa hutang
//     final sisaHutang = await hutangController.calculateTotalSisaHutang(
//         hutangId, hutang.nominalPinjam);

//     // Fetch payment snapshots
//     final paymentSnapshots = FirebaseFirestore.instance
//         .collection('bayarHutang')
//         .where('hutangId', isEqualTo: hutangId)
//         .snapshots();

//     // Show Dialog to confirm saving the data as Piutang
//     showDialog(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Detail Hutang'),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Nama Pemberi Pinjam: ${hutang.namaPemberiPinjam}'),
//             Text('No. Telepon: ${hutang.noteleponPemberiPinjam}'),
//             Text('Nominal Pinjam: ${hutang.nominalPinjam}'),
//             Text('Tanggal Pinjam: ${hutang.tanggalPinjam}'),
//             Text('Tanggal Jatuh Tempo: ${hutang.tanggalJatuhTempo}'),
//             Text('Deskripsi: ${hutang.deskripsi}'),
//             Text('Total Bayar: $totalBayar'),
//             Text('Sisa Hutang: $sisaHutang'),
//           ],
//         ),
//         actions: [
//           TextButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the dialog
//             },
//             child: Text('Batal'),
//           ),
//           ElevatedButton(
//             onPressed: () {
//               Navigator.pop(context); // Close the dialog
//               // Prepare data in Map<String, dynamic> format
//               Map<String, dynamic> data = {
//                 'hutang': {
//                   'hutangId': hutangId,
//                   'namaPemberiPinjam': hutang.namaPemberiPinjam,
//                   'noteleponPemberiPinjam': hutang.noteleponPemberiPinjam,
//                   'nominalPinjam': hutang.nominalPinjam,
//                   'tanggalPinjam': hutang.tanggalPinjam,
//                   'tanggalJatuhTempo': hutang.tanggalJatuhTempo,
//                   'deskripsi': hutang.deskripsi,
//                 }
//               };
//               _handleSaveHutangData(data);
//             },
//             child: Text('Simpan sebagai Piutang'),
//           ),
//         ],
//       ),
//     );
//   }

//   void _handleSaveHutangData(Map<String, dynamic> data) {
//     try {
//       final HutangModel hutangModel = HutangModel(
//         hutangId: data['hutang']['hutangId'] ?? '',
//         namaPemberiPinjam: data['hutang']['namaPemberiPinjam'] ?? '',
//         noteleponPemberiPinjam: data['hutang']['noteleponPemberiPinjam'] ?? '',
//         nominalPinjam: data['hutang']['nominalPinjam'] ?? 0.0,
//         tanggalPinjam: data['hutang']['tanggalPinjam'] ?? '',
//         tanggalJatuhTempo: data['hutang']['tanggalJatuhTempo'] ?? '',
//         deskripsi: data['hutang']['deskripsi'] ?? '',
//       );

//       final HutangController hutangController = HutangController();

//       hutangController.addHutang(hutangModel).then((_) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Data Hutang berhasil disimpan')),
//         );
//         Navigator.of(context).pushReplacement(
//           MaterialPageRoute(builder: (context) => const Piutang()),
//         );
//       }).catchError((e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Gagal menyimpan data Hutang')),
//         );
//       });
//     } catch (e) {
//       print('Error saving Hutang data: $e');
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Gagal menyimpan data')),
//       );
//     }
//   }
// }
