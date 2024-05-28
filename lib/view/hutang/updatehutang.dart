import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/model/hutangmodel.dart';
import 'package:tugasakhir/view/hutang.dart';

class UpdateHutang extends StatefulWidget {
  const UpdateHutang(
      {Key? key,
      this.hutangId,
      this.namaPemberiPinjam,
      this.noteleponPemberiPinjam,
      this.nominalPinjam,
      this.tanggalPinjam,
      this.tanggalJatuhTempo,
      this.deskripsi})
      : super(key: key);

  final String? hutangId;
  final String? namaPemberiPinjam;
  final String? noteleponPemberiPinjam;
  final String? nominalPinjam;
  final String? tanggalPinjam;
  final String? tanggalJatuhTempo;
  final String? deskripsi;

  @override
  State<UpdateHutang> createState() => _UpdateHutangState();
}

class _UpdateHutangState extends State<UpdateHutang> {
  var hutangController = HutangController();

  final _formKey = GlobalKey<FormState>();

  String? newNamaPemberiPinjam;
  String? newNoTelepeonPemberiPinjam;
  String? newNominalPinjam;
  String? newTanggalPinjam;
  String? newTanggalJatuhTempo;
  String? newDeskripsi;

  Future<void> _showConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi'),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Yakin ingin mengubah hutang?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Batal'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Ubah'),
              onPressed: () {
                Navigator.of(context).pop();
                _updateHutang();
              },
            ),
          ],
        );
      },
    );
  }

  void _updateHutang() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      HutangModel hutangmodel = HutangModel(
        hutangId: widget.hutangId,
        namaPemberiPinjam: newNamaPemberiPinjam!.toString(),
        noteleponPemberiPinjam: newNoTelepeonPemberiPinjam!.toString(),
        nominalPinjam: newNominalPinjam!.toString(),
        tanggalPinjam: newTanggalPinjam!.toString(),
        tanggalJatuhTempo: newTanggalJatuhTempo!.toString(),
        deskripsi: newDeskripsi!.toString(),
      );
      hutangController.updateHutang(hutangmodel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hutang Berubah'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Hutang(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFF24675B),
        title: Text(
          'Edit Hutang',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Container(
                width: 350,
                decoration: const BoxDecoration(
                  color: Color(0xFF24675B),
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nama Pemberi Pinjaman',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nama Pemberi Pinjaman tidak boleh kosong!';
                            } else if (value.length > 30) {
                              return 'Nama Pemberi Pinjaman maksimal 30 karakter!';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'Nama Pemberi Pinjaman harus berisi huruf alphabet saja.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newNamaPemberiPinjam = value;
                          },
                          initialValue: widget.namaPemberiPinjam,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'No. Telepon',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nomor telepon tidak boleh kosong!';
                            } else if (value.length < 10 || value.length > 13) {
                              return 'Nomor telepon harus memiliki panjang 10-13 karakter!';
                            } else if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                              return 'Nomor telepon hanya boleh berisi angka.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newNoTelepeonPemberiPinjam = value;
                          },
                          initialValue: widget.noteleponPemberiPinjam,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Nominal',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nominal Pinjaman tidak boleh kosong!';
                            } else if (!RegExp(r'^\d+$').hasMatch(value)) {
                              return 'Nominal Pinjaman harus berupa angka!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newNominalPinjam = value;
                          },
                          initialValue: widget.nominalPinjam,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal Pinjam',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal Pinjaman tidak boleh kosong!';
                            } else if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                .hasMatch(value)) {
                              return 'Tanggal Pinjaman harus berformat yyyy-mm-dd!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newTanggalPinjam = value;
                          },
                          initialValue: widget.tanggalPinjam,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Tanggal Jatuh Tempo',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal Jatuh Tempo tidak boleh kosong!';
                            } else if (!RegExp(r'^\d{4}-\d{2}-\d{2}$')
                                .hasMatch(value)) {
                              return 'Tanggal Jatuh Tempo harus berformat yyyy-mm-dd!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newTanggalJatuhTempo = value;
                          },
                          initialValue: widget.tanggalJatuhTempo,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 10.0,
                          horizontal: 30.0,
                        ),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Deskripsi (Opsional)',
                            style: GoogleFonts.inter(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            textAlign: TextAlign.start,
                          ),
                        ),
                      ),
                      Container(
                        width: 300,
                        child: TextFormField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          validator: (value) {
                            if (value != null &&
                                value.isNotEmpty &&
                                value.length < 10) {
                              return 'Deskripsi harus memiliki minimal 10 karakter jika diisi!';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newDeskripsi = value;
                          },
                          initialValue: widget.deskripsi,
                        ),
                      ),
                      const SizedBox(height: 20),
                      // ElevatedButton.icon(
                      //   onPressed: _pickImage,
                      //   icon: const Icon(Icons.upload_file),
                      //   label: const Text('Upload Gambar'),
                      // ),
                      // if (_selectedFile != null)
                      //   Padding(
                      //     padding: const EdgeInsets.all(8.0),
                      //     child: Image.file(
                      //       _selectedFile!,
                      //       height: 100,
                      //       width: 100,
                      //     ),
                      //   ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _formKey.currentState!.save();
                            HutangModel hutangmodel = HutangModel(
                              hutangId: widget.hutangId,
                              namaPemberiPinjam:
                                  newNamaPemberiPinjam!.toString(),
                              noteleponPemberiPinjam:
                                  newNoTelepeonPemberiPinjam!.toString(),
                              nominalPinjam: newNominalPinjam!.toString(),
                              tanggalPinjam: newTanggalPinjam!.toString(),
                              tanggalJatuhTempo:
                                  newTanggalJatuhTempo!.toString(),
                              deskripsi: newDeskripsi!.toString(),
                            );
                            hutangController.updateHutang(hutangmodel);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Data berhasil diubah')),
                            );
                            Navigator.pop(context, true);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB18154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                          minimumSize: const Size(150, 50),
                        ),
                        child: const Text(
                          'Simpan',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
