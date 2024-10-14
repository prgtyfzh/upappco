// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';
// import 'package:tugasakhir/model/hutangmodel.dart';
// import 'package:tugasakhir/view/hutang/hutang.dart';

// class QRCodeScanHutang extends StatefulWidget {
//   @override
//   _QRCodeScanHutangState createState() => _QRCodeScanHutangState();
// }

// class _QRCodeScanHutangState extends State<QRCodeScanHutang> {
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

//       if (data.containsKey('piutang')) {
//         return _buildHutangDialog(data);
//       } else {
//         throw FormatException('Data QR code tidak sesuai dengan Piutang');
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
//       title: const Text('Data dari QR Code Piutang'),
//       content: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text(
//                 'Nama Peminjam: ${data['piutang']['namaPeminjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Nominal Pinjam: ${data['piutang']['nominalDiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Tanggal Pinjam: ${data['piutang']['tanggalDiPinjam'] ?? 'Data tidak tersedia'}'),
//             Text(
//                 'Tanggal Jatuh Tempo: ${data['piutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
//             Text(
//               'Deskripsi: ${data['piutang']['deskripsi']?.isNotEmpty == true ? data['piutang']['deskripsi'] : 'Data tidak tersedia'}',
//             ),
//             Text(
//                 'Total Bayar: ${data['piutang']['totalBayar']?.isNotEmpty == true ? data['piutang']['totalBayar'] : 'Data tidak tersedia'}'),
//             Text(
//                 'Sisa Hutang: ${data['piutang']['sisaHutang']?.isNotEmpty == true ? data['piutang']['sisaHutang'] : 'Data tidak tersedia'}'),
//             Text(
//                 'Status: ${data['piutang']['status']?.isNotEmpty == true ? data['piutang']['status'] : 'Data tidak tersedia'}'),
//           ],
//         ),
//       ),
//       actions: <Widget>[
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             setState(() {});
//             _handleConvertAndSaveHutangData(data);
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

//   Future<void> _handleConvertAndSaveHutangData(
//       Map<String, dynamic> data) async {
//     try {
//       String userId = data['piutang']['userId'] ?? '';
//       String namaPemberiPinjam = await _fetchUsername(userId);

//       final HutangModel hutangModel = HutangModel(
//         hutangId: data['piutang']['piutangId'] ?? '',
//         namaPemberiPinjam: namaPemberiPinjam,
//         nominalPinjam: data['piutang']['nominalDiPinjam'] ?? 0.0,
//         tanggalPinjam: data['piutang']['tanggalDiPinjam'] ?? '',
//         tanggalJatuhTempo: data['piutang']['tanggalJatuhTempo'] ?? '',
//         deskripsi: data['piutang']['deskripsi'] ?? '',
//         totalBayar: data['piutang']['totalBayar'] ?? '',
//         sisaHutang: data['piutang']['sisaHutang'] ?? '',
//         status: data['piutang']['status'] ?? '',
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

//   Future<String> _fetchUsername(String userId) async {
//     if (userId.isEmpty) return 'N/A'; // Handle empty userId

//     DocumentSnapshot userDoc =
//         await FirebaseFirestore.instance.collection('users').doc(userId).get();

//     return userDoc['uName'] ?? 'N/A'; // Ambil username
//   }
// }

import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/model/hutangmodel.dart';
import 'package:tugasakhir/view/hutang/hutang.dart';

class QRCodeScanHutang extends StatefulWidget {
  @override
  _QRCodeScanHutangState createState() => _QRCodeScanHutangState();
}

class _QRCodeScanHutangState extends State<QRCodeScanHutang> {
  Barcode? result;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  final HutangController _hutangController = HutangController();

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
        title: const Text('Scan QR Code Piutang'),
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

      if (data.containsKey('piutang')) {
        return _buildHutangDialog(data); // Data valid, lanjutkan
      } else if (data.containsKey('hutang')) {
        // Tampilkan pesan error jika QR code adalah hutang, bukan piutang
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('QR code ini adalah data Hutang, bukan Piutang')),
          );
        });
        return Container(); // Jangan lakukan apa-apa
      } else {
        throw FormatException('Data QR code tidak sesuai dengan Piutang');
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

  Widget _buildHutangDialog(Map<String, dynamic> data) {
    return AlertDialog(
      title: const Text('Data dari QR Code Piutang'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                'Nama Peminjam: ${data['piutang']['namaPeminjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Nominal Pinjam: ${data['piutang']['nominalDiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Pinjam: ${data['piutang']['tanggalDiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Jatuh Tempo: ${data['piutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
            Text(
              'Deskripsi: ${data['piutang']['deskripsi']?.isNotEmpty == true ? data['piutang']['deskripsi'] : 'Data tidak tersedia'}',
            ),
            Text(
                'Total Bayar: ${data['piutang']['totalBayar']?.isNotEmpty == true ? data['piutang']['totalBayar'] : 'Data tidak tersedia'}'),
            Text(
                'Sisa Hutang: ${data['piutang']['sisaHutang']?.isNotEmpty == true ? data['piutang']['sisaHutang'] : 'Data tidak tersedia'}'),
            Text(
                'Status: ${data['piutang']['status']?.isNotEmpty == true ? data['piutang']['status'] : 'Data tidak tersedia'}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
            _handleConvertAndSaveHutangData(data);
          },
          child: const Text('Simpan Data'),
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

  Future<void> _handleConvertAndSaveHutangData(
      Map<String, dynamic> data) async {
    try {
      String userId = data['piutang']['userId'] ?? '';
      String namaPemberiPinjam = await _fetchUsername(userId);

      final HutangModel hutangModel = HutangModel(
        hutangId: data['piutang']['piutangId'] ?? '',
        namaPemberiPinjam: namaPemberiPinjam,
        nominalPinjam: data['piutang']['nominalDiPinjam'] ?? 0.0,
        tanggalPinjam: data['piutang']['tanggalDiPinjam'] ?? '',
        tanggalJatuhTempo: data['piutang']['tanggalJatuhTempo'] ?? '',
        deskripsi: data['piutang']['deskripsi'] ?? '',
        totalBayar: data['piutang']['totalBayar'] ?? '',
        sisaHutang: data['piutang']['sisaHutang'] ?? '',
        status: data['piutang']['status'] ?? '',
      );

      _hutangController.addHutang(hutangModel).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Hutang berhasil disimpan')),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Hutang()),
        );
      }).catchError((e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Gagal menyimpan data Hutang')),
        );
      });
    } catch (e) {
      print('Error saving Hutang data: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan data')),
      );
    }
  }

  Future<String> _fetchUsername(String userId) async {
    if (userId.isEmpty) return 'N/A'; // Handle empty userId

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc['uName'] ?? 'N/A'; // Ambil username
  }
}
