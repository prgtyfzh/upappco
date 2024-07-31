import 'dart:convert';
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
                'Hutang Id: ${data['hutang']['hutangId'] ?? 'Data tidak tersedia'}'),
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
            Text(
                'Total Bayar: ${data['hutang']['totalBayar'] ?? 'Data tidak tersedia'}'),
            Text(
                'Sisa Hutang: ${data['hutang']['sisaHutang'] ?? 'Data tidak tersedia'}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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
        totalBayar: data['hutang']['totalBayar'] ?? '',
        sisaHutang: data['hutang']['sisaHutang'] ?? '',
      );

      _piutangController.addPiutang(piutangModel).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Data Piutang berhasil disimpan')),
        );
        // // Panggil fungsi untuk memonitor perubahan Hutang terkait Piutang
        // _piutangController.listenToHutangChanges(data['hutang']['hutangId']);
        // HutangController().listenToHutangChanges(data['hutang']['hutangId']);

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
