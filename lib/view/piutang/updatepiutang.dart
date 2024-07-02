import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/piutangmodel.dart';
import 'package:tugasakhir/view/piutang.dart';

class UpdatePiutang extends StatefulWidget {
  const UpdatePiutang(
      {Key? key,
      this.piutangId,
      this.namaPeminjam,
      this.noteleponPeminjam,
      this.nominalDiPinjam,
      this.tanggalDiPinjam,
      this.tanggalJatuhTempo,
      this.deskripsi})
      : super(key: key);

  final String? piutangId;
  final String? namaPeminjam;
  final String? noteleponPeminjam;
  final String? nominalDiPinjam;
  final String? tanggalDiPinjam;
  final String? tanggalJatuhTempo;
  final String? deskripsi;

  @override
  State<UpdatePiutang> createState() => _UpdatePiutangState();
}

class _UpdatePiutangState extends State<UpdatePiutang> {
  var piutangController = PiutangController();

  final _formKey = GlobalKey<FormState>();

  String? newNamaPeminjam;
  String? newNoTeleponPeminjam;
  String? newNominalDiPinjam;
  String? newTanggalDiPinjam;
  String? newTanggalJatuhTempo;
  String? newDeskripsi;

  final TextEditingController _tanggalDiPinjamController =
      TextEditingController();
  final TextEditingController _tanggalJatuhTempoController =
      TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

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
                Text('Yakin ingin mengubah piutang?'),
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
                _updatePiutang();
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePiutang() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      PiutangModel piutangmodel = PiutangModel(
        piutangId: widget.piutangId,
        namaPeminjam: newNamaPeminjam!.toString(),
        noteleponPeminjam: newNoTeleponPeminjam!.toString(),
        nominalDiPinjam: newNominalDiPinjam!.toString(),
        tanggalDiPinjam: newTanggalDiPinjam!.toString(),
        tanggalJatuhTempo: newTanggalJatuhTempo!.toString(),
        deskripsi: newDeskripsi!.toString(),
      );
      piutangController.updatePiutang(piutangmodel);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Hutang Berubah'),
        ),
      );
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const Piutang(),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _tanggalDiPinjamController.text = widget.tanggalDiPinjam ?? '';
    _tanggalJatuhTempoController.text = widget.tanggalJatuhTempo ?? '';
    _nominalController.text = widget.nominalDiPinjam ?? '';
    newTanggalDiPinjam = widget.tanggalDiPinjam;
    newTanggalJatuhTempo = widget.tanggalJatuhTempo;
    newNominalDiPinjam = widget.nominalDiPinjam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Piutang',
          style: GoogleFonts.inter(
            fontWeight: FontWeight.bold,
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
                            'Nama Peminjam',
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
                              return 'Nama Peminjam tidak boleh kosong!';
                            } else if (value.length > 30) {
                              return 'Nama Peminjam maksimal 30 karakter!';
                            } else if (!RegExp(r'^[a-zA-Z\s]+$')
                                .hasMatch(value)) {
                              return 'Nama Peminjam harus berisi huruf alphabet saja.';
                            }
                            return null;
                          },
                          onSaved: (value) {
                            newNamaPeminjam = value;
                          },
                          initialValue: widget.namaPeminjam,
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
                          keyboardType: TextInputType
                              .number, // Set the keyboard type to number
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Allow only digits
                          ],
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
                            newNoTeleponPeminjam = value;
                          },
                          initialValue: widget.noteleponPeminjam,
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
                          controller: _nominalController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType
                              .number, // Set the keyboard type to number
                          inputFormatters: <TextInputFormatter>[
                            FilteringTextInputFormatter
                                .digitsOnly // Allow only digits
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nominal tidak boleh kosong!';
                            } else if (!RegExp(r'^\d{1,3}(.\d{3})*(\.\d+)?$')
                                .hasMatch(value)) {
                              return 'Nominal harus berisi angka saja.';
                            }
                            return null;
                          },
                          onChanged: (value) {
                            final numberFormat = NumberFormat("#,##0", "id_ID");
                            final newValue = value.replaceAll(",", "");

                            if (newValue.isNotEmpty) {
                              final formattedNominal =
                                  numberFormat.format(int.parse(newValue));

                              setState(() {
                                newNominalDiPinjam = formattedNominal;
                              });

                              _nominalController.value =
                                  _nominalController.value.copyWith(
                                text: formattedNominal,
                                selection: TextSelection.collapsed(
                                    offset: formattedNominal.length),
                              );
                            } else {
                              setState(() {
                                newNominalDiPinjam = null;
                              });
                            }
                          },
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
                            'Tanggal Di Pinjam',
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
                          controller: _tanggalDiPinjamController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? tanggaldp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2043),
                                  lastDate: DateTime(2030),
                                );

                                if (tanggaldp != null) {
                                  newTanggalDiPinjam = DateFormat('dd-MM-yyyy')
                                      .format(tanggaldp)
                                      .toString();

                                  setState(() {
                                    _tanggalDiPinjamController.text =
                                        newTanggalDiPinjam!;
                                  });
                                }
                              },
                            ),
                          ),
                          onSaved: (value) {
                            newTanggalDiPinjam = value;
                          },
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal tidak boleh kosong!';
                            }
                            return null;
                          },
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
                          controller: _tanggalJatuhTempoController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? tanggaljt = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2030),
                                );

                                if (tanggaljt != null) {
                                  newTanggalJatuhTempo =
                                      DateFormat('dd-MM-yyyy')
                                          .format(tanggaljt)
                                          .toString();

                                  setState(() {
                                    _tanggalJatuhTempoController.text =
                                        newTanggalJatuhTempo!;
                                  });
                                }
                              },
                            ),
                          ),
                          onSaved: (value) {
                            newTanggalJatuhTempo = value;
                          },
                          readOnly: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal tidak boleh kosong!';
                            }
                            return null;
                          },
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
                            PiutangModel piutangmodel = PiutangModel(
                              piutangId: widget.piutangId,
                              namaPeminjam: newNamaPeminjam!.toString(),
                              noteleponPeminjam:
                                  newNoTeleponPeminjam!.toString(),
                              nominalDiPinjam: newNominalDiPinjam!.toString(),
                              tanggalDiPinjam: newTanggalDiPinjam!.toString(),
                              tanggalJatuhTempo:
                                  newTanggalJatuhTempo!.toString(),
                              deskripsi: newDeskripsi!.toString(),
                            );
                            piutangController.updatePiutang(piutangmodel);
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
