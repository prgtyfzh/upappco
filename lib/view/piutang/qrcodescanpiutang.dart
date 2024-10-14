import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/piutangmodel.dart';
import 'package:tugasakhir/view/piutang/piutang.dart';

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

      // Jika data mengandung hutang, maka valid
      if (data.containsKey('hutang')) {
        return _buildPiutangDialog(data); // Data valid, lanjutkan
      }
      // Jika data mengandung piutang, tampilkan error
      else if (data.containsKey('piutang')) {
        // Tampilkan pesan error jika QR code adalah piutang, bukan hutang
        WidgetsBinding.instance!.addPostFrameCallback((_) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('QR code ini adalah data Piutang, bukan Hutang')),
          );
        });
        return Container(); // Jangan lakukan apa-apa
      }
      // Jika data tidak sesuai dengan format hutang/piutang yang diharapkan
      else {
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
                'Nominal Pinjam: ${data['hutang']['nominalPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Pinjam: ${data['hutang']['tanggalPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Jatuh Tempo: ${data['hutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
            Text(
                'Deskripsi: ${data['hutang']['deskripsi']?.isNotEmpty == true ? data['hutang']['deskripsi'] : 'Data tidak tersedia'}'),
            Text(
                'Total Bayar: ${data['hutang']['totalBayar']?.isNotEmpty == true ? data['hutang']['totalBayar'] : 'Data tidak tersedia'}'),
            Text(
                'Sisa Hutang: ${data['hutang']['sisaHutang']?.isNotEmpty == true ? data['hutang']['sisaHutang'] : 'Data tidak tersedia'}'),
            Text(
                'Status: ${data['hutang']['status']?.isNotEmpty == true ? data['hutang']['status'] : 'Data tidak tersedia'}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {});
            _handleConvertAndSavePiutangData(data);
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

  Future<void> _handleConvertAndSavePiutangData(
      Map<String, dynamic> data) async {
    try {
      String userId = data['hutang']['userId'] ?? '';
      String namaPeminjam = await _fetchUsername(userId);

      final PiutangModel piutangModel = PiutangModel(
        piutangId: data['hutang']['hutangId'] ?? '',
        namaPeminjam: namaPeminjam,
        nominalDiPinjam: data['hutang']['nominalPinjam'] ?? 0.0,
        tanggalDiPinjam: data['hutang']['tanggalPinjam'] ?? '',
        tanggalJatuhTempo: data['hutang']['tanggalJatuhTempo'] ?? '',
        deskripsi: data['hutang']['deskripsi'] ?? '',
        totalBayar: data['hutang']['totalBayar'] ?? '',
        sisaHutang: data['hutang']['sisaHutang'] ?? '',
        status: data['hutang']['status'] ?? '',
      );

      _piutangController.addPiutang(piutangModel).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Piutang berhasil disimpan')),
        );
        setState(() {});

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

  Future<String> _fetchUsername(String userId) async {
    if (userId.isEmpty) return 'N/A'; // Handle empty userId

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc['uName'] ?? 'N/A'; // Ambil username
  }
}
