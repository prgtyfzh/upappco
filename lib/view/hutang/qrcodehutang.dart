// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:qr_flutter/qr_flutter.dart';
// // import 'package:tugasakhir/controller/hutangcontroller.dart';

// // class QRCodeHutang extends StatefulWidget {
// //   const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

// //   final String hutangId;

// //   @override
// //   _QRCodeHutangState createState() => _QRCodeHutangState();
// // }

// // class _QRCodeHutangState extends State<QRCodeHutang> {
// //   final HutangController _hutangController = HutangController();

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: const Text('Detail Hutang'),
// //       ),
// //       body: FutureBuilder<Map<String, dynamic>>(
// //         future: _getDataForQRCode(),
// //         builder: (context, snapshot) {
// //           if (snapshot.connectionState == ConnectionState.waiting) {
// //             return const Center(child: CircularProgressIndicator());
// //           } else if (snapshot.hasError) {
// //             return Center(child: Text('Error: ${snapshot.error}'));
// //           } else if (!snapshot.hasData || snapshot.data == null) {
// //             return const Center(child: Text('No data found'));
// //           } else {
// //             final jsonData = json.encode(snapshot.data!);
// //             return Center(
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   QrImageView(
// //                     data: jsonData,
// //                     version: QrVersions.auto,
// //                     size: 200.0,
// //                   ),
// //                 ],
// //               ),
// //             );
// //           }
// //         },
// //       ),
// //     );
// //   }

// //   Future<Map<String, dynamic>> _getDataForQRCode() async {
// //     final hutang = await _hutangController.getHutangById(widget.hutangId);
// //     final totalBayar =
// //         await _hutangController.getTotalNominalBayar(widget.hutangId);
// //     final sisaHutang = await _hutangController.calculateTotalSisaHutang(
// //         widget.hutangId, hutang.nominalPinjam);

// //     final nominalPinjam = hutang.nominalPinjam;

// //     final data = {
// //       'hutang': hutang.toMap(),
// //       'pinjam': {
// //         'nominalPinjam': nominalPinjam,
// //       },
// //       'bayarHutang': {
// //         'totalBayar': totalBayar,
// //         'sisaHutang': sisaHutang,
// //       },
// //     };

// //     return data;
// //   }
// // }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';

// class QRCodeHutang extends StatefulWidget {
//   const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

//   final String hutangId;

//   @override
//   _QRCodeHutangState createState() => _QRCodeHutangState();
// }

// class _QRCodeHutangState extends State<QRCodeHutang> {
//   final HutangController _hutangController = HutangController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Hutang'),
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
//     final hutang = await _hutangController.getHutangById(widget.hutangId);
//     final totalBayar =
//         await _hutangController.getTotalNominalBayar(widget.hutangId);
//     final sisaHutang = await _hutangController.calculateTotalSisaHutang(
//         widget.hutangId, hutang.nominalPinjam);

//     final nominalPinjam = hutang.nominalPinjam;

//     final data = {
//       'hutang': hutang.toMap(),
//       'pinjam': {
//         'nominalPinjam': nominalPinjam,
//       },
//       'bayarHutang': {
//         'totalBayar': totalBayar,
//         'sisaHutang': sisaHutang,
//       },
//     };

//     return data;
//   }
// }

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';

// class QRCodeHutang extends StatefulWidget {
//   const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

//   final String hutangId;

//   @override
//   _QRCodeHutangState createState() => _QRCodeHutangState();
// }

// class _QRCodeHutangState extends State<QRCodeHutang> {
//   final HutangController _hutangController = HutangController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Hutang'),
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
//                     data: jsonData, // Use QrImage instead of QrImageView
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
//     final hutang = await _hutangController.getHutangById(widget.hutangId);
//     final totalBayar =
//         await _hutangController.getTotalNominalBayar(widget.hutangId);
//     final sisaHutang = await _hutangController.calculateTotalSisaHutang(
//         widget.hutangId, hutang.nominalPinjam);

//     final nominalPinjam = hutang.nominalPinjam;

//     final data = {
//       'hutang': hutang.toMap(),
//       'pinjam': {
//         'nominalPinjam': nominalPinjam,
//       },
//       'bayarHutang': {
//         'totalBayar': totalBayar,
//         'sisaHutang': sisaHutang,
//       },
//     };

//     return data;
//   }
// }

// import 'dart:convert';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:qr_flutter/qr_flutter.dart';
// import 'package:tugasakhir/controller/hutangcontroller.dart';

// class QRCodeHutang extends StatefulWidget {
//   const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

//   final String hutangId;

//   @override
//   _QRCodeHutangState createState() => _QRCodeHutangState();
// }

// class _QRCodeHutangState extends State<QRCodeHutang> {
//   final HutangController _hutangController = HutangController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Detail Hutang'),
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
//     final hutang = await _hutangController.getHutangById(widget.hutangId);
//     final totalBayar =
//         await _hutangController.getTotalNominalBayar(widget.hutangId);
//     final sisaHutang = await _hutangController.calculateTotalSisaHutang(
//         widget.hutangId, hutang.nominalPinjam);

//     // Fetch payment history
//     final paymentSnapshots = await FirebaseFirestore.instance
//         .collection('bayarHutang')
//         .where('hutangId', isEqualTo: widget.hutangId)
//         .get();

//     final paymentHistory =
//         paymentSnapshots.docs.map((doc) => doc.data()).toList();

//     final data = {
//       'hutang': hutang.toMap(),
//       'pinjam': {
//         'nominalPinjam': hutang.nominalPinjam,
//       },
//       'bayarHutang': {
//         'totalBayar': totalBayar,
//         'sisaHutang': sisaHutang,
//         'history': paymentHistory,
//       },
//     };

//     return data;
//   }
// }

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';

class QRCodeHutang extends StatefulWidget {
  const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

  final String hutangId;

  @override
  _QRCodeHutangState createState() => _QRCodeHutangState();
}

class _QRCodeHutangState extends State<QRCodeHutang> {
  final HutangController _hutangController = HutangController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Hutang'),
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
    final hutang = await _hutangController.getHutangById(widget.hutangId);
    final totalBayar =
        await _hutangController.getTotalNominalBayar(widget.hutangId);
    final sisaHutang = await _hutangController.calculateTotalSisaHutang(
        widget.hutangId, hutang.nominalPinjam);

    final nominalPinjam = hutang.nominalPinjam;

    final data = {
      'hutang': hutang.toMap(),
      'pinjam': {
        'nominalPinjam': nominalPinjam,
      },
      'bayarHutang': {
        'totalBayar': totalBayar,
        'sisaHutang': sisaHutang,
      },
    };

    return data;
  }
}
