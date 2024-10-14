import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/model/hutangmodel.dart';

class CreateHutang extends StatefulWidget {
  const CreateHutang({super.key});

  @override
  State<CreateHutang> createState() => _CreateHutangState();
}

class _CreateHutangState extends State<CreateHutang> {
  final _formKey = GlobalKey<FormState>();
  final hutangController = HutangController();

  String? namaPemberiPinjam;

  String? nominalPinjam;
  String? tanggalPinjam;
  String? tanggalJatuhTempo;
  String? deskripsi = "";

  TextEditingController nominalController = TextEditingController();
  final TextEditingController _tanggalPinjamController =
      TextEditingController();
  final TextEditingController _tanggalJatuhTempoController =
      TextEditingController();

  @override
  void dispose() {
    nominalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tambahkan Hutang',
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
                            hintText: 'Masukkan nama pemberi pinjaman',
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
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            setState(() {
                              namaPemberiPinjam = value;
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
                          controller:
                              nominalController, // Gunakan TextEditingController
                          decoration: InputDecoration(
                            hintText: 'Masukkan nominal pinjaman',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType
                              .number, // Set the keyboard type to number
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly // Allow only digits
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nominal tidak boleh kosong!';
                            }

                            final parsedValue =
                                int.tryParse(value.replaceAll('.', ''));

                            if (parsedValue == null) {
                              return 'Nominal harus berisi angka saja.';
                            } else if (parsedValue <= 200) {
                              return 'Nominal harus lebih dari 200 rupiah!';
                            }

                            return null;
                          },

                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          onChanged: (value) {
                            final numberFormat = NumberFormat("#,##0", "id_ID");
                            final newValue = value.replaceAll(",", "");

                            if (newValue.isNotEmpty) {
                              final formattedNominal =
                                  numberFormat.format(int.parse(newValue));

                              setState(() {
                                nominalPinjam = formattedNominal;
                              });

                              nominalController.value =
                                  nominalController.value.copyWith(
                                text: formattedNominal,
                                selection: TextSelection.collapsed(
                                    offset: formattedNominal.length),
                              );
                            } else {
                              setState(() {
                                nominalPinjam = null;
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
                            hintText: 'Pilih tanggal pinjam',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: const Color.fromRGBO(255, 255, 255, 1),
                            suffixIcon: IconButton(
                              icon: const Icon(Icons.calendar_today),
                              onPressed: () async {
                                DateTime? tanggalp = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2024),
                                  lastDate: DateTime(2030),
                                );

                                if (tanggalp != null) {
                                  tanggalPinjam =
                                      DateFormat('dd-MM-yyyy').format(tanggalp);

                                  setState(() {
                                    _tanggalPinjamController.text =
                                        tanggalPinjam.toString();
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
                          onChanged: (value) {
                            setState(() {
                              deskripsi = value;
                            });
                          },
                        ),
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            HutangModel hutangmodel = HutangModel(
                              namaPemberiPinjam: namaPemberiPinjam!,
                              nominalPinjam: nominalPinjam!,
                              tanggalPinjam: tanggalPinjam!,
                              tanggalJatuhTempo: tanggalJatuhTempo!,
                              deskripsi: deskripsi ?? '',
                            );
                            await hutangController.addHutangManual(hutangmodel);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Data berhasil ditambahkan')),
                            );
                            Navigator.pop(context, true);
                            setState(() {});
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFB18154),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          minimumSize: const Size(295, 50),
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
