import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/view/hutang/createhutang.dart';

class Hutang extends StatefulWidget {
  const Hutang({super.key});

  @override
  State<Hutang> createState() => _HutangState();
}

class _HutangState extends State<Hutang> {
  var hutangController = HutangController();

  @override
  void initState() {
    super.initState();
    hutangController.getHutang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Hutang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: hutangController.stream,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }

                  final List<DocumentSnapshot> data = snapshot.data!;

                  return ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5.0,
                          horizontal: 20.0,
                        ),
                        child: Card(
                          color: const Color(0xFF24675B),
                          elevation: 4,
                          child: ListTile(
                            title: Text(
                              'Rp${data[index]['nominalPinjam']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['namaPemberiPinjam'],
                                  style: const TextStyle(
                                      color: const Color(0xFFB18154)),
                                ),
                                Text(
                                  data[index]['tanggalPinjam'],
                                  style:
                                      const TextStyle(color: Color(0xFFB18154)),
                                ),
                                Text(
                                  data[index]['tanggalJatuhTempo'],
                                  style:
                                      const TextStyle(color: Color(0xFFB18154)),
                                ),
                              ],
                            ),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(
                                Icons.more_vert,
                                size: 25,
                              ),
                              // onSelected: (value) {
                              //   if (value == 'edit') {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => UpdatePendapatan(
                              //           pendapatanID: data[index]
                              //               ['pendapatanID'],
                              //           namaCust: data[index]['namaCust'],
                              //           telpCust: data[index]['telpCust'],
                              //           alamatCust: data[index]['alamatCust'],
                              //           sepatuCust: data[index]['sepatuCust'],
                              //           treatment: data[index]['treatment'],
                              //           tglMasuk: data[index]['tglMasuk'],
                              //           tglKeluar: data[index]['tglKeluar'],
                              //           hargaTreatment: data[index]
                              //               ['hargaTreatment'],
                              //         ),
                              //       ),
                              //     ).then((value) {
                              //       if (value == true) {
                              //         setState(() {
                              //           penc.getPendapatan();
                              //         });
                              //       }
                              //     });
                              //   } else if (value == 'delete') {
                              //     showDialog(
                              //       context: context,
                              //       builder: (BuildContext context) {
                              //         return AlertDialog(
                              //           backgroundColor: Colors.white,
                              //           title: const Text(
                              //               'Konfirmasi Penghapusan'),
                              //           content: const Text(
                              //               'Yakin ingin menghapus pengeluaran ini?'),
                              //           actions: <Widget>[
                              //             TextButton(
                              //               child: const Text(
                              //                 'Batal',
                              //                 style:
                              //                     TextStyle(color: Colors.red),
                              //               ),
                              //               onPressed: () {
                              //                 Navigator.of(context).pop();
                              //               },
                              //             ),
                              //             TextButton(
                              //               child: const Text(
                              //                 'Hapus',
                              //                 style:
                              //                     TextStyle(color: Colors.blue),
                              //               ),
                              //               onPressed: () {
                              //                 penc.removePendapatan(data[index]
                              //                         ['pendapatanID']
                              //                     .toString());
                              //                 setState(() {
                              //                   penc.getPendapatan();
                              //                 });
                              //                 Navigator.of(context).pop();
                              //               },
                              //             ),
                              //           ],
                              //         );
                              //       },
                              //     );
                              //   } else if (value == 'viewdetail') {
                              //     Navigator.push(
                              //       context,
                              //       MaterialPageRoute(
                              //         builder: (context) => DetailPendapatan(
                              //           tglMasuk: pendapatan['tglMasuk'],
                              //           tglKeluar: pendapatan['tglKeluar'],
                              //           namaCust: pendapatan['namaCust'],
                              //           telpCust: pendapatan['telpCust'],
                              //           alamatCust: pendapatan['alamatCust'],
                              //           sepatuCust: pendapatan['sepatuCust'],
                              //           treatment: pendapatan['treatment'],
                              //           hargaTreatment:
                              //               pendapatan['hargaTreatment'],
                              //         ),
                              //       ),
                              //     );
                              //   }
                              // },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Ubah'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Hapus'),
                                ),
                                const PopupMenuItem(
                                  value: 'viewdetail',
                                  child: Text('Lihat Data'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateHutang(),
            ),
          );
        },
        backgroundColor: const Color(0xFF24675B),
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
