import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DetailHutang extends StatelessWidget {
  const DetailHutang(
      {Key? key,
      required this.namaPemberiPinjam,
      required this.noteleponPemberiPinjam,
      required this.nominalPinjam,
      required this.tanggalPinjam,
      required this.tanggalJatuhTempo,
      required this.deskripsi})
      : super(key: key);

  final String namaPemberiPinjam;
  final String noteleponPemberiPinjam;
  final String nominalPinjam;
  final String tanggalPinjam;
  final String tanggalJatuhTempo;
  final String deskripsi;

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF24675B),
        centerTitle: true,
        title: Text(
          'Detail Hutang',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildDetailItem('Nama Pemberi Pinjam', namaPemberiPinjam),
              buildDivider(),
              buildDetailItem(
                  'No. Telepon Pemberi Pinjam', noteleponPemberiPinjam),
              buildDivider(),
              buildDetailItem('Nominal Pinjam', nominalPinjam),
              buildDivider(),
              buildDetailItem('Tanggal Pinjam', tanggalPinjam),
              buildDivider(),
              buildDetailItem('Tanggal Jatuh Tempo', tanggalJatuhTempo),
              buildDivider(),
              buildDetailItem('Deskripsi', deskripsi),
              buildDivider(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildDetailItem(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(
          height: 8,
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ],
    );
  }

  Widget buildDivider() {
    return const Divider(
      color: Colors.black,
      height: 16,
      thickness: 1,
    );
  }
}
