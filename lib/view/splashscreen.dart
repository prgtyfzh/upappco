import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tugasakhir/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    // Inisialisasi AnimationController untuk mengatur durasi animasi
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000), // Durasi animasi 1 detik
    );
    // Inisialisasi Tween untuk animasi ukuran gambar dari 0.0 hingga 200.0
    _animation =
        Tween<double>(begin: 0.0, end: 200.0).animate(_animationController);
    _animationController.forward(); // Memulai animasi

    // Menjalankan fungsi untuk pindah ke halaman login setelah 3 detik
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushAndRemoveUntil(
        context,
        CupertinoPageRoute(
          builder: (context) => const MainPage(),
        ),
        (route) => false,
      );
    });

    // Mengatur tampilan sistem UI ke mode edge-to-edge
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset:
          false, // Mencegah penyesuaian ukuran ketika keyboard muncul
      backgroundColor:
          Colors.white, // Mengatur warna latar belakang menjadi putih
      body: Center(
        child: AnimatedBuilder(
          animation: _animation, // Menggunakan animasi yang telah didefinisikan
          builder: (BuildContext context, Widget? child) {
            return SizedBox(
              width: _animation
                  .value, // Mengatur lebar gambar sesuai nilai animasi
              height: _animation
                  .value, // Mengatur tinggi gambar sesuai nilai animasi
              child: Image.asset(
                'assets/image/logoupapp.png', // Menampilkan gambar logo aplikasi
                width: 200,
                height: 200,
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _animationController
        .dispose(); // Membersihkan AnimationController saat widget dihapus
    super.dispose();
  }
}
