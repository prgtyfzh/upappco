// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:tugasakhir/controller/piutangcontroller.dart';

// class QRCodePiutang extends StatefulWidget {
//   const QRCodePiutang({Key? key, required this.piutangId}) : super(key: key);

//   final String piutangId;

//   @override
//   State<QRCodePiutang> createState() => _QRCodePiutangState();
// }

// class _QRCodePiutangState extends State<QRCodePiutang> {
//   final PiutangController _piutangController = PiutangController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Piutang'),
//       ),
//       body: FutureBuilder<Map<String, dynamic>>(
//         future: _getDataForQRCode(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (!snapshot.hasData || snapshot.data == null) {
//             return const Center(child: Text('No data found'));
//           } else {
//             final jsonData = json.encode(snapshot.data!);
//             return Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   QrImageView(
//                     data: jsonData,
//                     version: QrVersions.auto,
//                     size: 200.0,
//                   ),
//                 ],
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }

//   Future<Map<String, dynamic>> _getDataForQRCode() async {
//     final piutang = await _piutangController.getPiutangById(widget.piutangId);
//     final totalBayar =
//         await _piutangController.getTotalNominalBayar(widget.piutangId);
//     final sisaPiutang = await _piutangController.calculateTotalSisaPiutang(
//         widget.piutangId, piutang.nominalDiPinjam);

//     final nominalDiPinjam = piutang.nominalDiPinjam;

//     final data = {
//       'piutang': piutang.toMap(),
//       'dipinjam': {
//         'nominalDiPinjam': nominalDiPinjam,
//       },
//       'bayarHutang': {
//         'totalBayar': totalBayar,
//         'sisaPiutang': sisaPiutang,
//       },
//     };

//     return data;
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';

class QRCodePiutang extends StatefulWidget {
  const QRCodePiutang({Key? key, required this.piutangId}) : super(key: key);

  final String piutangId;

  @override
  State<QRCodePiutang> createState() => _QRCodePiutangState();
}

class _QRCodePiutangState extends State<QRCodePiutang> {
  final PiutangController _piutangController = PiutangController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Piutang'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getDataForQRCode(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('No data found'));
          } else {
            final jsonData = json.encode(snapshot.data!);
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  QrImageView(
                    data: jsonData,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Future<Map<String, dynamic>> _getDataForQRCode() async {
    final piutang = await _piutangController.getPiutangById(widget.piutangId);
    final totalBayar =
        await _piutangController.getTotalNominalBayar(widget.piutangId);
    final sisaPiutang = await _piutangController.calculateTotalSisaPiutang(
        widget.piutangId, piutang.nominalDiPinjam);

    final nominalDiPinjam = piutang.nominalDiPinjam;

    final data = {
      'piutang': piutang.toMap(),
      'dipinjam': {
        'nominalDiPinjam': nominalDiPinjam,
      },
      'bayarHutang': {
        'totalBayar': totalBayar,
        'sisaPiutang': sisaPiutang,
      },
    };

    return data;
  }
}
