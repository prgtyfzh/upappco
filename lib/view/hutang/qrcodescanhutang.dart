import 'dart:convert';
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
        return _buildHutangDialog(data);
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
                'Nomor Telepon: ${data['piutang']['noteleponPeminjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Nominal Pinjam: ${data['piutang']['nominalDiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Pinjam: ${data['piutang']['tanggalDiPinjam'] ?? 'Data tidak tersedia'}'),
            Text(
                'Tanggal Jatuh Tempo: ${data['piutang']['tanggalJatuhTempo'] ?? 'Data tidak tersedia'}'),
            Text(
                'Deskripsi: ${data['piutang']['deskripsi'] ?? 'Data tidak tersedia'}'),
            Text(
                'Total Bayar: ${data['piutang']['totalBayar'] ?? 'Data tidak tersedia'}'),
            Text(
                'Sisa Hutang: ${data['piutang']['sisaHutang'] ?? 'Data tidak tersedia'}'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
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

  void _handleConvertAndSaveHutangData(Map<String, dynamic> data) {
    try {
      final HutangModel hutangModel = HutangModel(
        hutangId: data['piutang']['piutangId'] ?? '',
        namaPemberiPinjam: data['piutang']['namaPeminjam'] ?? '',
        noteleponPemberiPinjam: data['piutang']['noteleponPeminjam'] ?? '',
        nominalPinjam: data['piutang']['nominalDiPinjam'] ?? 0.0,
        tanggalPinjam: data['piutang']['tanggalDiPinjam'] ?? '',
        tanggalJatuhTempo: data['piutang']['tanggalJatuhTempo'] ?? '',
        deskripsi: data['piutang']['deskripsi'] ?? '',
        totalBayar: data['piutang']['totalBayar'] ?? '',
        sisaHutang: data['piutang']['sisaHutang'] ?? '',
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
}
