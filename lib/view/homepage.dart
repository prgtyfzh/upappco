import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/controller/hutangcontroller.dart';
import 'package:tugasakhir/controller/piutangcontroller.dart';
import 'package:tugasakhir/loginpage.dart';
import 'package:tugasakhir/view/hutang.dart';
import 'package:tugasakhir/view/piutang.dart';
import 'package:tugasakhir/view/riwayat.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String userName = 'Loading...';
  String totalSisaHutang = 'Loading...';
  String totalSisaPiutang = 'Loading...';
  int _currentIndex = 0;
  List<String> _categories = ['Hutang', 'Piutang'];
  List<String> _amounts = ['Loading...', 'Loading...'];

  @override
  void initState() {
    super.initState();
    fetchUserName();
    fetchTotalSisaHutang();
    fetchTotalSisaPiutang();
  }

  Future<void> fetchUserName() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        userName = userDoc['uName'] ?? 'User';
      });
    }
  }

  Future<void> fetchTotalSisaHutang() async {
    final hutangController = HutangController();
    String total = await hutangController.getTotalSisaHutang();
    setState(() {
      totalSisaHutang = total;
      _amounts[0] = 'Rp$totalSisaHutang'; // Update Hutang amount
    });
  }

  Future<void> fetchTotalSisaPiutang() async {
    final piutangController = PiutangController();
    String total = await piutangController.getTotalSisaPiutang();
    setState(() {
      totalSisaPiutang = total;
      _amounts[1] = 'Rp$totalSisaPiutang'; // Update Piutang amount
    });
  }

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
              padding: const EdgeInsets.only(
                  top: 0,
                  bottom: 10,
                  left: 20,
                  right: 20), // Add some padding inside
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      margin: const EdgeInsets.only(left: 0, top: 0),
                      child: Image.asset(
                        'assets/image/logoupapp.png',
                        height: 90,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildCarousel(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCarousel() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: 2, // Tetap dua item: Hutang dan Piutang
          options: CarouselOptions(
            height: 150.0,
            enableInfiniteScroll: true, // Mengaktifkan guliran tak terbatas
            autoPlay: false, // Auto play agar terus bergerak
            viewportFraction: 1.0,
            onPageChanged: (index, reason) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return _buildHutangPiutangCard(
              title: _categories[index],
              amount: _amounts[index],
            );
          },
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _categories.length,
            (index) => Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _currentIndex == index ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // Widget untuk menampilkan kartu Hutang atau Piutang
  Widget _buildHutangPiutangCard(
      {required String title, required String amount}) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      padding: const EdgeInsets.all(10.0),
      width: 330,
      height: 150,
      decoration: const BoxDecoration(
        color: Color(0xFFB18154), // Set background color to white
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
          bottomLeft: Radius.circular(20.0),
          bottomRight: Radius.circular(20.0),
        ), // Add rounded corners
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
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
          RichText(
            text: TextSpan(
              text: 'Selamat datang, ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: userName,
                  style: const TextStyle(
                    color: Color(0xFFB18154),
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
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
                    MaterialPageRoute(builder: (context) => const LoginPage()),
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
