import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/piutangmodel.dart';

class CreatePiutang extends StatefulWidget {
  const CreatePiutang({super.key});

  @override
  State<CreatePiutang> createState() => _CreatePiutangState();
}

class _CreatePiutangState extends State<CreatePiutang> {
  final _formKey = GlobalKey<FormState>();
  final piutangController = PiutangController();

  String? namaPeminjam;
  String? noteleponPeminjam;
  String? nominalDiPinjam;
  String? tanggalDiPinjam;
  String? tanggalJatuhTempo;
  String? deskripsi;

  TextEditingController nominalController = TextEditingController();
  final TextEditingController _tanggalDiPinjamController =
      TextEditingController();
  final TextEditingController _tanggalJatuhTempoController =
      TextEditingController();

  // final _picker = ImagePicker();

  // Future<void> _pickImage() async {
  //   final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

  //   if (pickedFile != null) {
  //     setState(() {
  //       _selectedFile = File(pickedFile.path);
  //     });
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tambahkan Piutang',
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
                            hintText: 'Masukkan nama peminjam',
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
                          onChanged: (value) {
                            setState(() {
                              namaPeminjam = value;
                            });
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
                            hintText: 'Masukkan nomor telepon',
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
                          onChanged: (value) {
                            setState(() {
                              noteleponPeminjam = value;
                            });
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
                          controller: nominalController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan nominal dipinjam',
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
                                nominalDiPinjam = formattedNominal;
                              });

                              nominalController.value =
                                  nominalController.value.copyWith(
                                text: formattedNominal,
                                selection: TextSelection.collapsed(
                                    offset: formattedNominal.length),
                              );
                            } else {
                              setState(() {
                                nominalDiPinjam = null;
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
                            'Tanggal Dipinjam',
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
                            hintText: 'Pilih tanggal di pinjam',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? tanggaldp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2030),
                                );

                                if (tanggaldp != null) {
                                  tanggalDiPinjam = DateFormat('dd-MM-yyyy')
                                      .format(tanggaldp);

                                  setState(() {
                                    _tanggalDiPinjamController.text =
                                        tanggalDiPinjam.toString();
                                  });
                                }
                              },
                            ),
                          ),
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
                            hintText: 'Pilih tanggal jatuh tempo',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
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
                                  tanggalJatuhTempo = DateFormat('dd-MM-yyyy')
                                      .format(tanggaljt);

                                  setState(() {
                                    _tanggalJatuhTempoController.text =
                                        tanggalJatuhTempo.toString();
                                  });
                                }
                              },
                            ),
                          ),
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
                            hintText: 'Masukkan deskripsi',
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
                          onChanged: (value) {
                            setState(() {
                              deskripsi = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            PiutangModel piutangmodel = PiutangModel(
                              namaPeminjam: namaPeminjam!,
                              noteleponPeminjam: noteleponPeminjam!,
                              nominalDiPinjam: nominalDiPinjam!,
                              tanggalDiPinjam: tanggalDiPinjam!,
                              tanggalJatuhTempo: tanggalJatuhTempo!,
                              deskripsi: deskripsi!,
                            );
                            piutangController.addPiutang(piutangmodel);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Data berhasil ditambahkan')),
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
