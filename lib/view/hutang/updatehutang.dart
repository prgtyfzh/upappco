import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/model/hutangmodel.dart';

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
  String? newNoTeleponPemberiPinjam;
  String? newNominalPinjam;
  String? newTanggalPinjam;
  String? newTanggalJatuhTempo;
  String? newDeskripsi;

  final TextEditingController _tanggalPinjamController =
      TextEditingController();
  final TextEditingController _tanggalJatuhTempoController =
      TextEditingController();
  final TextEditingController _nominalController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tanggalPinjamController.text = widget.tanggalPinjam ?? '';
    _tanggalJatuhTempoController.text = widget.tanggalJatuhTempo ?? '';
    _nominalController.text = widget.nominalPinjam ?? '';
    newTanggalPinjam = widget.tanggalPinjam;
    newTanggalJatuhTempo = widget.tanggalJatuhTempo;
    newNominalPinjam = widget.nominalPinjam;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Edit Hutang',
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
                            newNoTeleponPemberiPinjam = value;
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
                                newNominalPinjam = formattedNominal;
                              });

                              _nominalController.value =
                                  _nominalController.value.copyWith(
                                text: formattedNominal,
                                selection: TextSelection.collapsed(
                                    offset: formattedNominal.length),
                              );
                            } else {
                              setState(() {
                                newNominalPinjam = null;
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
                          controller: _tanggalPinjamController,
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? tanggalp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2043),
                                  lastDate: DateTime(2030),
                                );

                                if (tanggalp != null) {
                                  newTanggalPinjam = DateFormat('dd-MM-yyyy')
                                      .format(tanggalp)
                                      .toString();

                                  setState(() {
                                    _tanggalPinjamController.text =
                                        newTanggalPinjam!;
                                  });
                                }
                              },
                            ),
                          ),
                          onSaved: (value) {
                            newTanggalPinjam = value;
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
                            HutangModel hutangmodel = HutangModel(
                              hutangId: widget.hutangId,
                              namaPemberiPinjam:
                                  newNamaPemberiPinjam!.toString(),
                              noteleponPemberiPinjam:
                                  newNoTeleponPemberiPinjam!.toString(),
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
