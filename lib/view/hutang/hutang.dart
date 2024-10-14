import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/view/hutang/createhutang.dart';
import 'package:tugasakhir/view/hutang/detailhutang.dart';
import 'package:tugasakhir/view/hutang/qrcodehutang.dart';
import 'package:tugasakhir/view/hutang/qrcodescanhutang.dart';

class Hutang extends StatefulWidget {
  const Hutang({Key? key}) : super(key: key);

  @override
  State<Hutang> createState() => _HutangState();
}

class _HutangState extends State<Hutang> {
  final HutangController _hutangController = HutangController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String keyword = "";
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    _hutangController.hutangWithoutStatusStream();
    _loadData;
    setState(() {});
  }

  @override
  void dispose() {
    _hutangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: isSearching
            ? Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                width: 350,
                height: 45,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: 'Cari hutang...',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(vertical: 11),
                  ),
                  onChanged: (newKeyword) {
                    setState(() {
                      keyword = newKeyword;
                    });
                  },
                ),
              )
            : const Text(
                'Daftar Hutang',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
        actions: [
          IconButton(
            icon: Icon(isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                isSearching = !isSearching;
                keyword = ''; // Reset keyword when closing search
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => QRCodeScanHutang(),
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
                stream: _hutangController.hutangWithoutStatusStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    // Tampilkan kesalahan jika ada
                    return const Center(
                        child: Text('Terjadi kesalahan saat memuat data'));
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('Tidak ada data hutang'));
                  }

                  final List<DocumentSnapshot> data = snapshot.data!;

                  // Implementasi logika pencarian
                  List<DocumentSnapshot> filteredDocuments =
                      data.where((document) {
                    var hutangData = document.data() as Map<String, dynamic>;
                    String searchField = hutangData['namaPemberiPinjam'] +
                        hutangData['nominalPinjam'].toString() +
                        hutangData['tanggalPinjam'] +
                        hutangData['tanggalJatuhTempo'];
                    return searchField
                        .toLowerCase()
                        .contains(keyword.toLowerCase());
                  }).toList();

                  return ListView.builder(
                    itemCount: filteredDocuments.length,
                    itemBuilder: (context, index) {
                      var hutangData = filteredDocuments[index];
                      return FutureBuilder<Map<String, String>>(
                        future: _loadData(hutangData['hutangId'] ?? '0',
                            hutangData['nominalPinjam']),
                        builder: (context,
                            AsyncSnapshot<Map<String, String>> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Center(child: Container());
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

                          var hutangDetailData = snapshot.data!;
                          var sisaHutang =
                              hutangDetailData['sisaHutang'] ?? '0';
                          var totalBayar =
                              hutangDetailData['totalBayar'] ?? '0';

                          // Menghitung progres sesuai dengan jumlah yang sudah dibayar
                          double totalBayarDouble = double.tryParse(totalBayar
                                  .replaceAll('.', '')
                                  .replaceAll(',', '')) ??
                              0.0;
                          double nominalPinjamDouble = double.tryParse(
                                  hutangData['nominalPinjam']
                                      .replaceAll('.', '')
                                      .replaceAll(',', '')) ??
                              1.0;
                          double _progress =
                              totalBayarDouble / nominalPinjamDouble;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 5.0, horizontal: 20.0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => DetailHutang(
                                      namaPemberiPinjam:
                                          hutangData['namaPemberiPinjam'],
                                      nominalPinjam:
                                          hutangData['nominalPinjam'],
                                      tanggalPinjam:
                                          hutangData['tanggalPinjam'],
                                      tanggalJatuhTempo:
                                          hutangData['tanggalJatuhTempo'],
                                      deskripsi: hutangData['deskripsi'] ?? '',
                                      hutangId: hutangData['hutangId'],
                                    ),
                                  ),
                                ).then((_) {
                                  setState(() {
                                    _hutangController
                                        .hutangWithoutStatusStream();
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
                                      _buildHutangHeader(context, hutangData,
                                          sisaHutang, totalBayar, _progress),
                                      const SizedBox(height: 5),
                                      _buildHutangDates(hutangData),
                                      const SizedBox(height: 10),
                                      _buildHutangAmounts(context, hutangData,
                                          totalBayar, sisaHutang),
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
              builder: (context) => const CreateHutang(),
            ),
          ).then((value) {
            if (value == true) {
              setState(() {
                _hutangController.hutangWithoutStatusStream();
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
      String hutangId, String nominalPinjam) async {
    String totalBayar = await _hutangController.getTotalNominalBayar(hutangId);
    String sisaHutang = await _hutangController.calculateTotalSisaHutang(
        hutangId, nominalPinjam);
    return {
      'totalBayar': totalBayar,
      'sisaHutang': sisaHutang,
    };
  }

  Widget _buildHutangHeader(BuildContext context, var hutangData,
      String sisaHutang, String totalBayar, double _progress) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            hutangData['namaPemberiPinjam'],
            style: const TextStyle(
                color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
          ),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white),
          itemBuilder: (context) {
            double sisaHutangDouble = double.tryParse(
                    sisaHutang.replaceAll('.', '').replaceAll(',', '')) ??
                0.0;
            if (sisaHutangDouble == 0) {
              return [
                const PopupMenuItem<String>(
                    value: 'selesai', child: Text('Selesaikan Hutang'))
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
            if (value == 'selesai') {
              _showConfirmationDialog(
                context,
                title: 'Konfirmasi Penyelesaian Hutang',
                content: 'Apakah Anda yakin ingin menyelesaikan hutang ini?',
                onConfirm: () async {
                  // Mendapatkan user ID yang aktif
                  final String userIdPihakHutang = _auth.currentUser?.uid ?? '';

                  if (userIdPihakHutang.isNotEmpty) {
                    // Selesaikan hutang
                    await _hutangController
                        .selesaikanHutang(hutangData['hutangId']);
                    setState(() {
                      _hutangController.hutangWithoutStatusStream();
                    });
                  } else {
                    // Tampilkan pesan kesalahan jika user ID tidak ditemukan
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('User ID tidak ditemukan')),
                    );
                  }
                },
              );
            } else if (value == 'delete') {
              _showConfirmationDialog(
                context,
                title: 'Konfirmasi Hapus Hutang',
                content: 'Apakah Anda yakin ingin menghapus hutang ini?',
                onConfirm: () {
                  _hutangController.removeHutang(hutangData['hutangId']);
                  setState(() {
                    _hutangController.hutangWithoutStatusStream();
                  });
                },
              );
            } else if (value == 'qrCode') {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      QRCodeHutang(hutangId: hutangData['hutangId']),
                ),
              );
            }
          },
        ),
      ],
    );
  }

  Widget _buildHutangDates(var hutangData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Pinjam', style: TextStyle(color: Colors.white)),
            Text(hutangData['tanggalPinjam'],
                style: const TextStyle(color: Colors.white)),
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tanggal Jatuh Tempo',
                style: TextStyle(color: Colors.white)),
            Text(hutangData['tanggalJatuhTempo'],
                style: const TextStyle(color: Colors.white)),
          ],
        ),
      ],
    );
  }

  Widget _buildHutangAmounts(BuildContext context, var hutangData,
      String totalBayar, String sisaHutang) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildAmountContainer(
            context, 'Hutang', 'Rp${hutangData['nominalPinjam']}'),
        _buildAmountContainer(context, 'Dibayar', 'Rp$totalBayar'),
        _buildAmountContainer(context, 'Sisa', 'Rp$sisaHutang'),
      ],
    );
  }

  // void _handleMenuSelection(String value, var hutangData) {
  //   if (value == 'selesai') {
  //     _showConfirmationDialog(
  //       context,
  //       title: 'Konfirmasi Penyelesaian Hutang',
  //       content: 'Apakah Anda yakin ingin menyelesaikan hutang ini?',
  //       onConfirm: () {
  //         _hutangController.moveHutangToHistory(hutangData['hutangId']);
  //         setState(() {
  //           _hutangController.getHutangSortedByDate();
  //         });
  //       },
  //     );
  //   } else if (value == 'delete') {
  //     _showConfirmationDialog(
  //       context,
  //       title: 'Konfirmasi Hapus Hutang',
  //       content: 'Apakah Anda yakin ingin menghapus hutang ini?',
  //       onConfirm: () {
  //         _hutangController.removeHutang(hutangData['hutangId']);
  //         setState(() {
  //           _hutangController.getHutangSortedByDate();
  //         });
  //       },
  //     );
  //   } else if (value == 'qrCode') {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => QRCodeHutang(hutangId: hutangData['hutangId']),
  //       ),
  //     );
  //   }
  // }

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
