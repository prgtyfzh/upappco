import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/model/hutangmodel.dart';

class QRCodeHutang extends StatefulWidget {
  final String hutangId;

  const QRCodeHutang({Key? key, required this.hutangId}) : super(key: key);

  @override
  _QRCodeHutangState createState() => _QRCodeHutangState();
}

class _QRCodeHutangState extends State<QRCodeHutang> {
  late Future<HutangModel> _hutangFuture;

  @override
  void initState() {
    super.initState();
    _hutangFuture = HutangController().getHutangById(widget.hutangId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Hutang'),
      ),
      body: Center(
        child: FutureBuilder<HutangModel>(
          future: _hutangFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (!snapshot.hasData) {
              return const Text('No data found');
            } else {
              final hutang = snapshot.data!;
              final hutangJson = json.encode(hutang.toMap());

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hutang ID: ${hutang.hutangId}'),
                  const SizedBox(height: 20),
                  QrImageView(
                    data: hutangJson,
                    version: QrVersions.auto,
                    size: 200.0,
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
