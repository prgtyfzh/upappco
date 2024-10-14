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
        title: const Text('QRCode Hutang'),
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
                    size: 300.0,
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

    final data = {
      'hutang': hutang,
    };

    return data;
  }
}
