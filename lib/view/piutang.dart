import 'package:flutter/material.dart';
import 'package:tugasakhir/view/piutang/createpiutang.dart';

class Piutang extends StatelessWidget {
  const Piutang({super.key});

  @override
  Widget build(BuildContext context) {
    List<String> dummyData = [
      'Piutang 1',
      'Piutang 2',
      'Piutang 3',
      'Piutang 4',
      'Piutang 5',
    ];
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Daftar Piutang',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: dummyData.length,
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Card(
                color: const Color(0xFF24675B),
                child: ListTile(
                  title: Text(
                    dummyData[index],
                    style: const TextStyle(color: Colors.white),
                  ),
                  subtitle: const Text(
                    'Deskripsi Piutang',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            );
          },
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
