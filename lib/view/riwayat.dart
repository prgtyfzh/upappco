import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/view/hutang/detailhutang.dart';
import 'package:tugasakhir/view/piutang/detailpiutang.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  final HutangController _hutangController = HutangController();
  final PiutangController _piutangController = PiutangController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first initialized
    _hutangController.hutangHistoryStream();
    _piutangController.piutangHistoryStream();
  }

  @override
  void dispose() {
    _hutangController.dispose();
    _piutangController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // Number of tabs (Hutang and Piutang)
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Riwayat',
            style: GoogleFonts.inter(fontWeight: FontWeight.bold),
          ),
          bottom: TabBar(
            tabs: const [
              Tab(
                text: 'Hutang',
              ),
              Tab(
                text: 'Piutang',
              ),
            ],
            indicatorColor: const Color(0xFF24675B), // Set the indicator color
            labelColor:
                const Color(0xFF24675B), // Set the label color for selected tab
            labelStyle: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ), // Apply text style for selected tab
            unselectedLabelColor:
                Colors.black, // Set the label color for unselected tabs
          ),
        ),
        body: TabBarView(
          children: [
            _buildHutangView(),
            _buildPiutangView(),
          ],
        ),
      ),
    );
  }

  Widget _buildHutangView() {
    return SafeArea(
      child: StreamBuilder<List<DocumentSnapshot>>(
        stream: _hutangController.hutangHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return const Center(
                child: Text('Terjadi kesalahan saat memuat data'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada data hutang yang selesai'));
          }

          final List<DocumentSnapshot> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var hutangData = data[index];
              return FutureBuilder<Map<String, String>>(
                future: _loadDataHutang(
                    hutangData['hutangId'] ?? '0', hutangData['nominalPinjam']),
                builder:
                    (context, AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Terjadi kesalahan saat memuat data'));
                  }

                  var hutangDetailData = snapshot.data!;
                  var sisaHutang = hutangDetailData['sisaHutang'] ?? '0';
                  var totalBayar = hutangDetailData['totalBayar'] ?? '0';

                  double totalBayarDouble = double.tryParse(
                          totalBayar.replaceAll('.', '').replaceAll(',', '')) ??
                      0.0;
                  double nominalPinjamDouble = double.tryParse(
                          hutangData['nominalPinjam']
                              .replaceAll('.', '')
                              .replaceAll(',', '')) ??
                      1.0;
                  double _progress = totalBayarDouble / nominalPinjamDouble;

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
                              nominalPinjam: hutangData['nominalPinjam'],
                              tanggalPinjam: hutangData['tanggalPinjam'],
                              tanggalJatuhTempo:
                                  hutangData['tanggalJatuhTempo'],
                              deskripsi: hutangData['deskripsi'] ?? '',
                              hutangId: hutangData['hutangId'],
                              fromRiwayat: true,
                            ),
                          ),
                        ).then((_) {
                          setState(() {
                            _hutangController.hutangHistoryStream();
                          });
                        });
                      },
                      child: Card(
                        color: const Color(0xFF24675B),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildHutangHeader(context, hutangData,
                                  sisaHutang, totalBayar, _progress),
                              const SizedBox(height: 5),
                              _buildHutangDates(hutangData),
                              const SizedBox(height: 10),
                              _buildHutangAmounts(
                                  context, hutangData, totalBayar, sisaHutang),
                              const SizedBox(height: 10),
                              LinearProgressIndicator(
                                value: _progress,
                                backgroundColor: Colors.grey,
                                valueColor: const AlwaysStoppedAnimation<Color>(
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
    );
  }

  Widget _buildPiutangView() {
    return SafeArea(
      child: StreamBuilder<List<DocumentSnapshot>>(
        stream: _piutangController.piutangHistoryStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Tidak ada data piutang yang selesai'));
          }

          final List<DocumentSnapshot> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              var piutangData = data[index];
              return FutureBuilder<Map<String, String>>(
                future: _loadDataPiutang(piutangData['piutangId'] ?? '0',
                    piutangData['nominalDiPinjam']),
                builder:
                    (context, AsyncSnapshot<Map<String, String>> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: Container());
                  }
                  if (snapshot.hasError) {
                    return const Center(
                        child: Text('Terjadi kesalahan saat memuat data'));
                  }

                  var piutangDetailData = snapshot.data!;
                  var sisaPiutang = piutangDetailData['sisaPiutang'] ?? '0';
                  var totalBayar = piutangDetailData['totalBayar'] ?? '0';

                  double totalBayarDouble = double.tryParse(
                          totalBayar.replaceAll('.', '').replaceAll(',', '')) ??
                      0.0;
                  double nominalPiutangDouble = double.tryParse(
                          piutangData['nominalDiPinjam']
                              .replaceAll('.', '')
                              .replaceAll(',', '')) ??
                      1.0;
                  double _progress = totalBayarDouble / nominalPiutangDouble;

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
                              nominalDiPinjam: piutangData['nominalDiPinjam'],
                              tanggalDiPinjam: piutangData['tanggalDiPinjam'],
                              tanggalJatuhTempo:
                                  piutangData['tanggalJatuhTempo'],
                              deskripsi: piutangData['deskripsi'] ?? '',
                              piutangId: piutangData['piutangId'],
                              fromRiwayat: true,
                            ),
                          ),
                        ).then((_) {
                          setState(() {
                            _piutangController.piutangHistoryStream();
                          });
                        });
                      },
                      child: Card(
                        color: const Color(0xFFB18154),
                        elevation: 4,
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                valueColor: const AlwaysStoppedAnimation<Color>(
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
    );
  }

  Future<Map<String, String>> _loadDataHutang(
      String hutangId, String nominalPinjam) async {
    String totalBayar = await _hutangController.getTotalNominalBayar(hutangId);
    String sisaHutang = await _hutangController.calculateTotalSisaHutang(
        hutangId, nominalPinjam);
    return {
      'totalBayar': totalBayar,
      'sisaHutang': sisaHutang,
    };
  }

  Future<Map<String, String>> _loadDataPiutang(
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
