import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/view/formbayar.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';

class DetailHutang extends StatefulWidget {
  final String namaPemberiPinjam;

  final String nominalPinjam;
  final String tanggalPinjam;
  final String tanggalJatuhTempo;
  final String deskripsi;
  final String hutangId;
  final bool fromRiwayat;

  const DetailHutang({
    Key? key,
    required this.namaPemberiPinjam,
    required this.nominalPinjam,
    required this.tanggalPinjam,
    required this.tanggalJatuhTempo,
    required this.deskripsi,
    required this.hutangId,
    this.fromRiwayat = false,
  }) : super(key: key);

  @override
  _DetailHutangState createState() => _DetailHutangState();
}

class _DetailHutangState extends State<DetailHutang> {
  final HutangController _hutangController = HutangController();

  String userName = 'Loading...';
  String _sisaHutang = '0';
  String _totalBayar = '0';
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    setState(() {});
    _loadData();
  }

  Future<void> _loadData() async {
    await _loadTotalBayar();
    await _loadSisaHutang();
    _calculateProgress();
  }

  Future<void> _loadSisaHutang() async {
    String sisaHutang = await _hutangController.calculateTotalSisaHutang(
      widget.hutangId,
      widget.nominalPinjam,
    );
    setState(() {
      _sisaHutang = sisaHutang;
    });
  }

  Future<void> _loadTotalBayar() async {
    String totalBayar =
        await _hutangController.getTotalNominalBayar(widget.hutangId);
    setState(() {
      _totalBayar = totalBayar;
    });
  }

  void _calculateProgress() {
    double nominalPinjam = double.parse(
        widget.nominalPinjam.replaceAll('.', '').replaceAll(',', ''));
    double totalBayar =
        double.parse(_totalBayar.replaceAll('.', '').replaceAll(',', ''));
    setState(() {
      _progress = totalBayar / nominalPinjam;
      if (_progress > 1.0) {
        _progress = 1.0;
      }
    });
  }

  Future<String> _fetchUsername(String userId) async {
    if (userId.isEmpty) return 'N/A'; // Handle empty userId

    DocumentSnapshot userDoc =
        await FirebaseFirestore.instance.collection('users').doc(userId).get();

    return userDoc['uName'] ?? 'N/A';
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
        title: Text(
          'Detail Hutang',
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
                      widget.namaPemberiPinjam,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20),
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
                              'Tanggal Pinjam',
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              widget.tanggalPinjam,
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
                            context, 'Pinjam', 'Rp${widget.nominalPinjam}'),
                        _buildAmountContainer(
                            context, 'Dibayar', 'Rp$_totalBayar'),
                        _buildAmountContainer(
                            context, 'Sisa', 'Rp$_sisaHutang'),
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
                    .where('hutangId', isEqualTo: widget.hutangId)
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
                      final userId = data['userId'];

                      return FutureBuilder<String>(
                        future: _fetchUsername(userId),
                        builder: (context, usernameSnapshot) {
                          String username = 'Loading...';
                          if (usernameSnapshot.connectionState ==
                              ConnectionState.done) {
                            if (usernameSnapshot.hasError) {
                              username = 'Error fetching username';
                            } else {
                              username = usernameSnapshot.data ?? 'N/A';
                            }
                          }

                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            child: ListTile(
                              title: Text(
                                'Nominal Bayar: Rp${nominalBayar.toString()}',
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Tanggal Bayar: ${tanggalBayar.toString()}',
                                  ),
                                  Text(
                                    'Penginput: $username', // Menampilkan username
                                  ),
                                ],
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
                                hutangId: widget.hutangId,
                                sisaHutang: _sisaHutang.toString(),
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
                          'Tambahkan Pembayaran',
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
