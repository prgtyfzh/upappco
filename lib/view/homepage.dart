import 'package:flutter/material.dart';
import 'package:tugasakhir/view/hutang.dart';
import 'package:tugasakhir/view/piutang.dart';
import 'package:tugasakhir/view/riwayat.dart';
import 'package:tugasakhir/view/settings.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Bagian Header
              _buildHeader(),

              // Bagian Menu Utama
              _buildMainMenu(),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk bagian Header
  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 370,
            height: 300,
            decoration: const BoxDecoration(
              color: Color(0xFF24675B), // Set background color to green
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10.0),
                topRight: Radius.circular(10.0),
                bottomLeft: Radius.circular(50.0),
                bottomRight: Radius.circular(50.0),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0), // Add some padding inside
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(
                        right: 200), // Add some padding inside
                    child: const Text(
                      'Debt Wallet',
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(10),
                    width: 300,
                    height: 150,
                    margin:
                        const EdgeInsets.only(bottom: 0), // Remove any margin
                    decoration: const BoxDecoration(
                      color: Color(0xFFB18154), // Set background color to white
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                        bottomLeft: Radius.circular(5.0),
                        bottomRight: Radius.circular(5.0),
                      ), // Add rounded corners
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hutang',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Rp100.000,00',
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk bagian Menu Utama
  Widget _buildMainMenu() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: <Widget>[
          const Text(
            'Selamat datang, Asahi!',
            style: TextStyle(fontSize: 18),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMenuButton(
                icon: Icons.arrow_circle_down_outlined,
                text: 'Hutang',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Hutang()),
                  );
                },
              ),
              const SizedBox(width: 20),
              _buildMenuButton(
                icon: Icons.arrow_circle_up_outlined,
                text: 'Piutang',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Piutang()),
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildMenuButton(
                icon: Icons.history,
                text: 'Riwayat',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Riwayat()),
                  );
                },
              ),
              const SizedBox(width: 20),
              _buildMenuButton(
                icon: Icons.settings,
                text: 'Pengaturan',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Settings()),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Widget untuk tombol menu
  Widget _buildMenuButton({
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 150,
        height: 150,
        decoration: BoxDecoration(
          color: const Color(0xFF24675B),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, color: Colors.white),
              const SizedBox(height: 5),
              Text(
                text,
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
