import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/view/piutang/createpiutang.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';

class Piutang extends StatefulWidget {
  const Piutang({super.key});

  @override
  State<Piutang> createState() => _PiutangState();
}

class _PiutangState extends State<Piutang> {
  var piutangController = PiutangController();

  @override
  void initState() {
    piutangController.getPiutang();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Piutang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: StreamBuilder<List<DocumentSnapshot>>(
                stream: piutangController.stream,
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
                              'Rp${data[index]['nominalDiPinjam']}',
                              style: const TextStyle(color: Colors.white),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data[index]['namaPeminjam'],
                                  style:
                                      const TextStyle(color: Color(0xFFB18154)),
                                ),
                                Text(
                                  data[index]['tanggalDiPinjam'],
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
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'Ubah',
                                  child: Text('Edit'),
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
              builder: (context) => const CreatePiutang(),
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
