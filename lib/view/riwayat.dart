import 'package:flutter/material.dart';

class Riwayat extends StatelessWidget {
  const Riwayat({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dummyHutangData = [
      'Riwayat Hutang 1',
      'Riwayat Hutang 2',
      'Riwayat Hutang 3',
      'Riwayat Hutang 4',
      'Riwayat Hutang 5',
    ];

    List<String> dummyPiutangData = [
      'Riwayat Piutang 1',
      'Riwayat Piutang 2',
      'Riwayat Piutang 3',
      'Riwayat Piutang 4',
      'Riwayat Piutang 5',
    ];

    return DefaultTabController(
      length: 2, // Jumlah tab (hutang dan piutang)
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Riwayat',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Hutang'),
              Tab(text: 'Piutang'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildRiwayatList(dummyHutangData),
            _buildRiwayatList(dummyPiutangData),
          ],
        ),
      ),
    );
  }

  Widget _buildRiwayatList(List<String> dummyData) {
    return ListView.builder(
      itemCount: dummyData.length,
      itemBuilder: (context, index) {
        Color bgColor = index % 2 == 0 ? const Color(0xFF24675B) : Colors.white;
        Color textColor =
            bgColor == const Color(0xFF24675B) ? Colors.white : Colors.black;

        return Container(
          color: bgColor,
          child: ListTile(
            title: Text(
              dummyData[index],
              style: TextStyle(color: textColor),
            ),
            subtitle: Text(
              'Deskripsi Riwayat',
              style: TextStyle(color: textColor),
            ),
          ),
        );
      },
    );
  }
}
