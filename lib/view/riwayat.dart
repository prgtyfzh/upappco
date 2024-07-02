// import 'package:flutter/material.dart';

// class Riwayat extends StatelessWidget {
//   const Riwayat({super.key});

//   @override
//   Widget build(BuildContext context) {
//     List<String> dummyHutangData = [
//       'Riwayat Hutang 1',
//       'Riwayat Hutang 2',
//       'Riwayat Hutang 3',
//       'Riwayat Hutang 4',
//       'Riwayat Hutang 5',
//     ];

//     List<String> dummyPiutangData = [
//       'Riwayat Piutang 1',
//       'Riwayat Piutang 2',
//       'Riwayat Piutang 3',
//       'Riwayat Piutang 4',
//       'Riwayat Piutang 5',
//     ];

//     return DefaultTabController(
//       length: 2, // Jumlah tab (hutang dan piutang)
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text(
//             'Riwayat',
//             style: TextStyle(fontWeight: FontWeight.bold),
//           ),
//           bottom: const TabBar(
//             tabs: [
//               Tab(text: 'Hutang'),
//               Tab(text: 'Piutang'),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildRiwayatList(dummyHutangData),
//             _buildRiwayatList(dummyPiutangData),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildRiwayatList(List<String> dummyData) {
//     return ListView.builder(
//       itemCount: dummyData.length,
//       itemBuilder: (context, index) {
//         Color bgColor = index % 2 == 0 ? const Color(0xFF24675B) : Colors.white;
//         Color textColor =
//             bgColor == const Color(0xFF24675B) ? Colors.white : Colors.black;

//         return Container(
//           color: bgColor,
//           child: ListTile(
//             title: Text(
//               dummyData[index],
//               style: TextStyle(color: textColor),
//             ),
//             subtitle: Text(
//               'Deskripsi Riwayat',
//               style: TextStyle(color: textColor),
//             ),
//           ),
//         );
//       },
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/view/hutang/detailhutang.dart';

class Riwayat extends StatefulWidget {
  const Riwayat({Key? key}) : super(key: key);

  @override
  State<Riwayat> createState() => _RiwayatState();
}

class _RiwayatState extends State<Riwayat> {
  final HutangController _hutangController = HutangController();

  @override
  void initState() {
    super.initState();
    // Fetch initial data when the widget is first initialized
    _hutangController.getHutangHistorySortedByDate();
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
        title: const Text(
          'Riwayat Hutang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: StreamBuilder<List<DocumentSnapshot>>(
          stream: _hutangController.hutangHistoryStream(),
          builder: (context, AsyncSnapshot<List<DocumentSnapshot>> snapshot) {
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

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text('Tidak ada riwayat hutang'),
              );
            }

            final List<DocumentSnapshot> data = snapshot.data!;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                var hutangData = data[index].data() as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 5.0,
                    horizontal: 20.0,
                  ),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetailHutang(
                            namaPemberiPinjam: hutangData['namaPemberiPinjam'],
                            noteleponPemberiPinjam:
                                hutangData['noteleponPemberiPinjam'],
                            nominalPinjam: hutangData['nominalPinjam'],
                            tanggalPinjam: hutangData['tanggalPinjam'],
                            tanggalJatuhTempo: hutangData['tanggalJatuhTempo'],
                            deskripsi: hutangData['deskripsi'],
                            hutangId: hutangData['hutangId'],
                          ),
                        ),
                      ).then((_) {
                        // Refresh the data after returning from DetailHutang screen
                        _hutangController.getHutangHistorySortedByDate();
                      });
                    },
                    child: Card(
                      color: const Color(0xFF24675B),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Text(
                                    hutangData['namaPemberiPinjam'],
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 5),
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
                                      hutangData['tanggalPinjam'],
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                      hutangData['tanggalJatuhTempo'],
                                      style:
                                          const TextStyle(color: Colors.white),
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
                                  context,
                                  'Pinjam',
                                  'Rp ${hutangData['nominalPinjam']}',
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
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
        crossAxisAlignment: CrossAxisAlignment.center,
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
