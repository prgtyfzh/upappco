import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/view/piutang/createpiutang.dart';
import 'package:tugasakhir/view/piutang/detailpiutang.dart';
import 'package:tugasakhir/view/piutang/qrcodepiutang.dart';
import 'package:tugasakhir/view/piutang/qrcodescanpiutang.dart';

class Piutang extends StatefulWidget {
  const Piutang({Key? key}) : super(key: key);

  @override
  State<Piutang> createState() => _PiutangState();
}

class _PiutangState extends State<Piutang> {
  final PiutangController _piutangController = PiutangController();

  @override
  void initState() {
    super.initState();
    _piutangController.getPiutangSortedByDate();
  }

  @override
  void dispose() {
    _piutangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Daftar Piutang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScanPiutang(),
                ),
              );
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: _piutangController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Terjadi kesalahan saat memuat data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data piutang'));
                  }

                  final List<DocumentSnapshot> data = snapshot.data!;
                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      var piutangData = data[index];
                      return FutureBuilder<Map<String, String>>(
                        future: _loadData(piutangData['piutangId'] ?? '0',
                            piutangData['nominalDiPinjam']),
                        builder: (context,
                            AsyncSnapshot<Map<String, String>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                                child: CircularProgressIndicator());
                          }
                          if (snapshot.hasError) {
                            return const Center(
                                child:
                                    Text('Terjadi kesalahan saat memuat data'));
                          }

                          // Check if snapshot.data is null
                          if (snapshot.data == null) {
                            return const Center(child: Text('Data is null'));
                          }

                          var piutangDetailData = snapshot.data!;
                          var sisaPiutang =
                              piutangDetailData['sisaPiutang'] ?? '0';
                          var totalBayar =
                              piutangDetailData['totalBayar'] ?? '0';

                          // Menghitung progres sesuai dengan jumlah yang sudah dibayar
                          double totalBayarDouble = double.tryParse(totalBayar
                                  .replaceAll('.', '')
                                  .replaceAll(',', '')) ??
                              0.0;
                          double nominalPiutangDouble = double.tryParse(
                                  piutangData['nominalDiPinjam']
                                      .replaceAll('.', '')
                                      .replaceAll(',', '')) ??
                              1.0;
                          double _progress =
                              totalBayarDouble / nominalPiutangDouble;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailPiutang(
                                      namaPeminjam: piutangData['namaPeminjam'],
                                      noteleponPeminjam:
                                          piutangData['noteleponPeminjam'],
                                      nominalDiPinjam:
                                          piutangData['nominalDiPinjam'],
                                      tanggalDiPinjam:
                                          piutangData['tanggalDiPinjam'],
                                      tanggalJatuhTempo:
                                          piutangData['tanggalJatuhTempo'],
                                      deskripsi: piutangData['deskripsi'] ?? '',
                                      piutangId: piutangData['piutangId'],
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _piutangController.getPiutangSortedByDate();
                                  });
                                });
                              },
                              child: Card(
                                color: const Color(0xFF24675B),
                                elevation: 4,
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      _buildPiutangHeader(context, piutangData,
                                          sisaPiutang, totalBayar, _progress),
                                      const SizedBox(height: 5),
                                      _buildPiutangDates(piutangData),
                                      const SizedBox(height: 10),
                                      _buildPiutangAmounts(context, piutangData,
                                          totalBayar, sisaPiutang),
                                      const SizedBox(height: 10),
                                      LinearProgressIndicator(
                                        value: _progress,
                                        backgroundColor: Colors.grey,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                                Colors.green),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreatePiutang(),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                _piutangController.getPiutangSortedByDate();
              });
            }
          });
        },
        backgroundColor: const Color(0xFF24675B),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<Map<String, String>> _loadData(
      String piutangId, String nominalDiPinjam) async {
    String totalBayar =
        await _piutangController.getTotalNominalBayar(piutangId);
    String sisaPiutang = await _piutangController.calculateTotalSisaPiutang(
        piutangId, nominalDiPinjam);
    return {
      'totalBayar': totalBayar,
      'sisaPiutang': sisaPiutang,
    };
  }

  Widget _buildPiutangHeader(BuildContext context, var piutangData,
      String sisaPiutang, String totalBayar, double _progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            piutangData['namaPeminjam'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (context) {
            double sisaPiutangDouble = double.tryParse(
                    sisaPiutang.replaceAll('.', '').replaceAll(',', '')) ??
                0.0;
            if (sisaPiutangDouble == 0) {
              return [
                const PopupMenuItem<String>(
                    value: 'selesai', child: Text('Selesaikan Piutang'))
              ];
            } else {
              return [
                const PopupMenuItem<String>(
                    value: 'delete', child: Text('Hapus')),
                const PopupMenuItem<String>(
                    value: 'qrCode', child: Text('Lihat QR Code')),
              ];
            }
          },
          onSelected: (String value) {
            _handleMenuSelection(value, piutangData);
          },
        ),
      ],
    );
  }

  Widget _buildPiutangDates(var piutangData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal DiPinjam',
                style: TextStyle(color: Colors.white)),
            Text(piutangData['tanggalDiPinjam'],
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Jatuh Tempo',
                style: TextStyle(color: Colors.white)),
            Text(piutangData['tanggalJatuhTempo'],
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildPiutangAmounts(BuildContext context, var piutangData,
      String totalBayar, String sisaPiutang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAmountContainer(context, 'Piutang',
            'Rp${piutangData['nominalDiPinjam']}'), // Menggunakan nominalPinjam
        _buildAmountContainer(context, 'Dibayar', 'Rp$totalBayar'),
        _buildAmountContainer(context, 'Sisa', 'Rp$sisaPiutang'),
      ],
    );
  }

  void _handleMenuSelection(String value, var piutangData) {
    if (value == 'selesai') {
      _showConfirmationDialog(
        context,
        title: 'Konfirmasi Penyelesaian Piutang',
        content: 'Apakah Anda yakin ingin menyelesaikan piutang ini?',
        onConfirm: () {
          _piutangController.movePiutangToHistory(piutangData['piutangId']);
          setState(() {
            _piutangController.getHistorySortedByDate();
          });
        },
      );
    } else if (value == 'delete') {
      _showConfirmationDialog(
        context,
        title: 'Konfirmasi Hapus Piutang',
        content: 'Apakah Anda yakin ingin menghapus piutang ini?',
        onConfirm: () {
          _piutangController.removePiutang(piutangData['piutangId']);
          setState(() {
            _piutangController.getPiutangSortedByDate();
          });
        },
      );
    } else if (value == 'qrCode') {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) =>
              QRCodePiutang(piutangId: piutangData['piutangId']),
        ),
      );
    }
  }

  void _showConfirmationDialog(BuildContext context,
      {required String title,
      required String content,
      required VoidCallback onConfirm}) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onConfirm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildAmountContainer(
      BuildContext context, String label, String value) {
    return Container(
      width: MediaQuery.of(context).size.width / 3 - 28,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(color: Colors.black),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
