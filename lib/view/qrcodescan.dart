// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:tugasakhir/controller/piutangcontroller.dart';
// import 'package:tugasakhir/model/piutangmodel.dart';
// import 'package:tugasakhir/view/piutang.dart';

// class QRCodeScan extends StatefulWidget {
//   const QRCodeScan({Key? key}) : super(key: key);

//   @override
//   State<QRCodeScan> createState() => _QRCodeScanState();
// }

// class _QRCodeScanState extends State<QRCodeScan> {
//   Barcode? result;
//   QRViewController? controller;
//   final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
//   final PiutangController _piutangController = PiutangController();

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
//         title: const Text('Scan QR Code'),
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

//       return AlertDialog(
//         title: const Text('Data dari QR Code'),
//         content: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             Text('Nama Pemberi Pinjam: ${data['namaPemberiPinjam']}'),
//             Text('Nomor Telepon: ${data['noteleponPemberiPinjam']}'),
//             Text('Nominal Pinjam: ${data['nominalPinjam']}'),
//             Text('Tanggal Pinjam: ${data['tanggalPinjam']}'),
//             Text('Tanggal Jatuh Tempo: ${data['tanggalJatuhTempo']}'),
//             Text('Deskripsi: ${data['deskripsi']}'),
//           ],
//         ),
//         actions: <Widget>[
//           TextButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//               _handleSaveData(data);
//             },
//             child: const Text('Simpan Data'),
//           ),
//           TextButton(
//             onPressed: () {
//               setState(() {
//                 result = null;
//               });
//               controller!.resumeCamera();
//             },
//             child: const Text('Tutup'),
//           ),
//         ],
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Invalid QR code data')),
//       );
//       return Container();
//     }
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

//   void _handleSaveData(Map<String, dynamic> data) {
//     try {
//       // Convert JSON to PiutangModel
//       final PiutangModel piutangModel = PiutangModel(
//         piutangId: '', // Generate new ID when saving to Firestore
//         namaPeminjam: data['namaPemberiPinjam'],
//         noteleponPeminjam: data['noteleponPemberiPinjam'],
//         nominalDiPinjam: data['nominalPinjam'],
//         tanggalDiPinjam: data['tanggalPinjam'],
//         tanggalJatuhTempo: data['tanggalJatuhTempo'],
//         deskripsi: data['deskripsi'],
//       );

//       // Add Piutang data using PiutangController
//       _piutangController.addPiutang(piutangModel);

//       // Show success message and navigate to Piutang page
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Data Piutang berhasil disimpan')),
//       );

//       // Navigate to Piutang page after saving
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => Piutang()),
//       );
//     } catch (e) {
//       // Show error message if data is not in expected format
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(content: Text('Error: Invalid QR code data')),
//       );
//     }
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/piutangmodel.dart';
import 'package:tugasakhir/view/piutang.dart';

class QRCodeScan extends StatefulWidget {
  const QRCodeScan({Key? key}) : super(key: key);

  @override
  State<QRCodeScan> createState() => _QRCodeScanState();
}

class _QRCodeScanState extends State<QRCodeScan> {
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
        title: const Text('Scan QR Code'),
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

      return AlertDialog(
        title: const Text('Data dari QR Code'),
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Nama Pemberi Pinjam: ${data['namaPemberiPinjam']}'),
            Text('Nomor Telepon: ${data['noteleponPemberiPinjam']}'),
            Text('Nominal Pinjam: ${data['nominalPinjam']}'),
            Text('Tanggal Pinjam: ${data['tanggalPinjam']}'),
            Text('Tanggal Jatuh Tempo: ${data['tanggalJatuhTempo']}'),
            Text('Deskripsi: ${data['deskripsi']}'),
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _handleSaveData(data);
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
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Invalid QR code data')),
      );
      return Container();
    }
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

  void _handleSaveData(Map<String, dynamic> data) {
    try {
      // Convert JSON to PiutangModel
      final PiutangModel piutangModel = PiutangModel(
        piutangId: '', // Generate new ID when saving to Firestore
        namaPeminjam: data['namaPemberiPinjam'],
        noteleponPeminjam: data['noteleponPemberiPinjam'],
        nominalDiPinjam: data['nominalPinjam'],
        tanggalDiPinjam: data['tanggalPinjam'],
        tanggalJatuhTempo: data['tanggalJatuhTempo'],
        deskripsi: data['deskripsi'],
      );

      // Add Piutang data using PiutangController
      _piutangController.addPiutang(piutangModel).then((_) {
        // Show success message and navigate to Piutang page
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Piutang berhasil disimpan')),
        );

        // Navigate to Piutang page after saving
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => Piutang()),
        );
      }).catchError((e) {
        // Show error message if data already exists
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data sudah ada di daftar Piutang')),
        );
      });
    } catch (e) {
      // Show error message if data is not in expected format
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error: Invalid QR code data')),
      );
    }
  }
}
