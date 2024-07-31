import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/view/formbayar.dart';

class DetailPiutang extends StatefulWidget {
  final String namaPeminjam;
  final String noteleponPeminjam;
  final String nominalDiPinjam;
  final String tanggalDiPinjam;
  final String tanggalJatuhTempo;
  final String deskripsi;
  final String piutangId;
  final bool fromRiwayat;

  const DetailPiutang({
    Key? key,
    required this.namaPeminjam,
    required this.noteleponPeminjam,
    required this.nominalDiPinjam,
    required this.tanggalDiPinjam,
    required this.tanggalJatuhTempo,
    required this.deskripsi,
    required this.piutangId,
    this.fromRiwayat = false,
  }) : super(key: key);

  @override
  _DetailPiutangState createState() => _DetailPiutangState();
}

class _DetailPiutangState extends State<DetailPiutang> {
  final PiutangController _piutangController = PiutangController();
  String _sisaPiutang = '0';
  String _totalBayar = '0';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadTotalBayar();
    await _loadSisaPiutang();
    _calculateProgress();
  }

  Future<void> _loadSisaPiutang() async {
    String sisaPiutang = await _piutangController.calculateTotalSisaPiutang(
      widget.piutangId,
      widget.nominalDiPinjam,
    );
    setState(() {
      _sisaPiutang = sisaPiutang;
    });
  }

  Future<void> _loadTotalBayar() async {
    String totalBayar =
        await _piutangController.getTotalNominalBayar(widget.piutangId);
    setState(() {
      _totalBayar = totalBayar;
    });
  }

  void _calculateProgress() {
    double nominalDiPinjam = double.parse(
        widget.nominalDiPinjam.replaceAll('.', '').replaceAll(',', ''));
    double totalBayar =
        double.parse(_totalBayar.replaceAll('.', '').replaceAll(',', ''));
    setState(() {
      _progress = totalBayar / nominalDiPinjam;
      if (_progress > 1.0) {
        _progress = 1.0;
      }
    });
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
        title: Text(
          'Detail Piutang',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: const Color(0xFF24675B),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.namaPeminjam,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.phone,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.noteleponPeminjam,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        const Icon(
                          Icons.list_alt_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 5),
                        Text(
                          widget.deskripsi,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      height: 5,
                      child: Container(
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Di Pinjam',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.tanggalDiPinjam,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Tanggal Jatuh Tempo',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.tanggalJatuhTempo,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildAmountContainer(
                            context, 'Dipinjam', 'Rp${widget.nominalDiPinjam}'),
                        _buildAmountContainer(
                            context, 'Dibayar', 'Rp$_totalBayar'),
                        _buildAmountContainer(
                            context, 'Sisa', 'Rp$_sisaPiutang'),
                      ],
                    ),
                    const SizedBox(height: 10),
                    LinearProgressIndicator(
                      value: _progress,
                      backgroundColor: Colors.grey,
                      valueColor:
                          const AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Riwayat Pembayaran',
              style: GoogleFonts.inter(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pembayaran')
                    .where('piutangId', isEqualTo: widget.piutangId)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Terjadi kesalahan saat memuat data'),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text('Tidak ada riwayat pembayaran.'),
                    );
                  }

                  final List<DocumentSnapshot> documents = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: documents.length,
                    itemBuilder: (context, index) {
                      final data =
                          documents[index].data() as Map<String, dynamic>;
                      final nominalBayar = data['nominalBayar'] ?? 0;
                      final tanggalBayar = data['tanggalBayar'] ?? 'N/A';

                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 5),
                        child: ListTile(
                          title: Text(
                              'Nominal Bayar: Rp${nominalBayar.toString()}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Tanggal Bayar: ${tanggalBayar.toString()}'),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            if (!widget.fromRiwayat)
              Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FormBayar(
                                piutangId: widget.piutangId,
                                sisaHutang: _sisaPiutang.toString(),
                              ),
                            ),
                          ).then((_) {
                            // Refresh data when coming back from FormBayar
                            _loadData();
                          });
                        },
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          backgroundColor: const Color(0xFF24675B),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: const Text(
                          'Terima Pembayaran',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            const SizedBox(height: 20),
          ],
        ),
      ),
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
