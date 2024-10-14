import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/model/pembayaranmodel.dart';

class FormBayar extends StatefulWidget {
  FormBayar({
    Key? key,
    this.hutangId,
    this.piutangId,
    required this.sisaHutang,
  }) : super(key: key);

  final String? hutangId;
  final String? piutangId;
  final String sisaHutang;

  @override
  State<FormBayar> createState() => _FormBayarState();
}

class _FormBayarState extends State<FormBayar> {
  final _formKey = GlobalKey<FormState>();
  final hutangController = HutangController();
  final piutangController = PiutangController();

  String? nominalBayar;
  String? tanggalBayar;
  String formattedDate = DateFormat('yyyy-MM-dd').format(DateTime.now());
  double nominalPinjamDouble = 0.0;
  double sisaHutangDouble = 0.0;
  double nominalDiPinjamDouble = 0.0;
  double sisaPiutangDouble = 0.0;

  TextEditingController nominalBayarController = TextEditingController();
  TextEditingController tanggalBayarController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchInitialValues();
    tanggalBayarController.text = formattedDate;
    tanggalBayar = formattedDate; // Initialize tanggalBayar with today's date
  }

  @override
  void dispose() {
    nominalBayarController.dispose();
    tanggalBayarController.dispose();
    super.dispose();
  }

  void fetchInitialValues() async {
    try {
      if (widget.hutangId != null) {
        String? nominalPinjamStr =
            await hutangController.getNominalPinjam(widget.hutangId!);
        nominalPinjamDouble = double.tryParse(
                nominalPinjamStr?.replaceAll('.', '').replaceAll(',', '') ??
                    '0.0') ??
            0.0;
        sisaHutangDouble = double.tryParse(
                widget.sisaHutang.replaceAll('.', '').replaceAll(',', '')) ??
            0.0;
      } else if (widget.piutangId != null) {
        String? nominalDiPinjamStr =
            await piutangController.getNominalDiPinjam(widget.piutangId!);
        nominalDiPinjamDouble = double.tryParse(
                nominalDiPinjamStr?.replaceAll('.', '').replaceAll(',', '') ??
                    '0.0') ??
            0.0;
        sisaPiutangDouble = double.tryParse(
                widget.sisaHutang.replaceAll('.', '').replaceAll(',', '')) ??
            0.0;
      }
      setState(() {});
    } catch (e) {
      print('Error fetching initial values: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Form Pembayaran',
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
                            'Nominal Bayar',
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
                          controller: nominalBayarController,
                          decoration: InputDecoration(
                            hintText: 'Masukkan nominal bayar',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Nominal bayar tidak boleh kosong!';
                            }
                            final numericRegex =
                                RegExp(r'^\d{1,3}(?:\.\d{3})*(?:,\d+)?$');
                            if (!numericRegex.hasMatch(value)) {
                              return 'Format nominal bayar tidak valid.';
                            }
                            double parsedValue = double.tryParse(value
                                    .replaceAll('.', '')
                                    .replaceAll(',', '')) ??
                                0.0;

                            // Validasi untuk nominal 0
                            if (parsedValue == 0.0) {
                              return 'Nominal bayar tidak boleh nol.';
                            }
                            if (widget.hutangId != null) {
                              if (parsedValue > sisaHutangDouble) {
                                return 'Nominal bayar tidak boleh lebih besar dari sisa hutang (${NumberFormat.currency(locale: 'id_ID').format(sisaHutangDouble)})';
                              } else if (parsedValue > nominalPinjamDouble) {
                                return 'Nominal bayar tidak boleh lebih besar dari nominal pinjam (${NumberFormat.currency(locale: 'id_ID').format(nominalPinjamDouble)})';
                              }
                            } else if (widget.piutangId != null) {
                              if (parsedValue > sisaPiutangDouble) {
                                return 'Nominal bayar tidak boleh lebih besar dari sisa piutang (${NumberFormat.currency(locale: 'id_ID').format(sisaPiutangDouble)})';
                              } else if (parsedValue > nominalDiPinjamDouble) {
                                return 'Nominal bayar tidak boleh lebih besar dari nominal di pinjam (${NumberFormat.currency(locale: 'id_ID').format(nominalDiPinjamDouble)})';
                              }
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
                                nominalBayar = formattedNominal;
                              });
                              nominalBayarController.value =
                                  nominalBayarController.value.copyWith(
                                text: formattedNominal,
                                selection: TextSelection.collapsed(
                                    offset: formattedNominal.length),
                              );
                            } else {
                              setState(() {
                                nominalBayar = null;
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
                            'Tanggal Bayar',
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
                          controller: tanggalBayarController,
                          decoration: InputDecoration(
                            hintText: formattedDate,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            filled: true,
                            fillColor: Colors.white,
                          ),
                          readOnly: true,
                          onTap: () async {
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2020),
                              lastDate: DateTime(2101),
                            );
                            if (pickedDate != null) {
                              String formattedPickedDate =
                                  DateFormat('yyyy-MM-dd').format(pickedDate);
                              setState(() {
                                tanggalBayar = formattedPickedDate;
                                tanggalBayarController.text =
                                    formattedPickedDate;
                              });
                            }
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Tanggal bayar tidak boleh kosong!';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            // Show confirmation dialog
                            bool confirm =
                                await _showConfirmationDialog(context);
                            if (confirm) {
                              PembayaranModel pembayaranModel = PembayaranModel(
                                nominalBayar: nominalBayar!.replaceAll(',', ''),
                                tanggalBayar: tanggalBayar ?? formattedDate,
                                hutangId: widget.hutangId,
                                piutangId: widget.piutangId,
                              );

                              try {
                                if (widget.hutangId != null) {
                                  await hutangController
                                      .addBayarHutang(pembayaranModel);
                                  print('Hutang bayar added successfully');
                                } else if (widget.piutangId != null) {
                                  await piutangController
                                      .addBayarPiutang(pembayaranModel);
                                  print('Piutang bayar added successfully');
                                }
                                Navigator.pop(context);
                                setState(() {});
                              } catch (e) {
                                print('Error adding bayar: $e');
                              }
                            }
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
                      const SizedBox(height: 20),
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

Future<bool> _showConfirmationDialog(BuildContext context) async {
  return await showDialog<bool>(
        context: context,
        barrierDismissible:
            false, // Prevents dismissing the dialog by tapping outside of it
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Konfirmasi Pembayaran'),
            content: const Text(
              'Apakah nominal pembayaran sudah sesuai? Pastikan tidak ada kesalahan dalam memasukkan data.',
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Batal'),
                onPressed: () {
                  Navigator.of(context).pop(false); // Return false
                },
              ),
              TextButton(
                child: const Text('Simpan'),
                onPressed: () {
                  Navigator.of(context).pop(true); // Return true
                },
              ),
            ],
          );
        },
      ) ??
      false; // Default to false if dialog is dismissed
}
