import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/model/usermodel.dart';
import 'package:tugasakhir/view/homepage.dart';
import 'package:tugasakhir/view/loginpage.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  bool get success => false;

  // Fungsi untuk mendaftarkan pengguna dengan email, kata sandi, dan nama
  Future<UserModel?> registerWithEmailAndPassword(
      String email, String password, String name, BuildContext context) async {
    try {
      // Mendaftarkan pengguna dengan email dan kata sandi
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);
      final User? user = userCredential.user;

      if (user != null) {
        // Jika pendaftaran berhasil, buat model pengguna dengan informasi tambahan
        final UserModel newUser = UserModel(
          uEmail: user.email ?? '',
          uName: name,
          uId: user.uid,
        );

        // Tampilkan dialog sukses
        _showDialog(
          context,
          'Daftar Berhasil',
          'Akun anda telah terdaftar.',
          () {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) {
              return const LoginPage();
            }));
          },
        );
        // Simpan userModel ke dalam database Anda
        await userCollection.doc(newUser.uId).set(newUser.toMap());

        return newUser;
      }
    } catch (e) {
      print(e); // Cetak kesalahan jika ada
      // Tampilkan dialog gagal
      _showDialog(
        context,
        'Daftar Gagal',
        'Terdapat kesalahan dalam pendaftaran.',
        () {
          Navigator.pop(context);
        },
      );
      return null;
    }
    return null;
  }

  // Fungsi untuk login dengan email dan kata sandi
  Future<void> signInWithEmailAndPassword(
      String email, String password, BuildContext context) async {
    try {
      final UserCredential userCredential = await _auth
          .signInWithEmailAndPassword(email: email, password: password);
      if (userCredential.user != null) {
        // Login berhasil, navigasi ke halaman utama
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const HomePage(),
          ),
        );
      }
    } catch (e) {
      // Login gagal, tampilkan pesan kesalahan
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Gagal Masuk'),
            content: const Text('Email atau kata sandi salah.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // Fungsi untuk menampilkan dialog dengan pesan yang disesuaikan
  void _showDialog(
      BuildContext context, String title, String content, VoidCallback onOk) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Theme(
          data: ThemeData(
            dialogBackgroundColor:
                const Color(0xFFD9D9D9), // Warna latar belakang dialog
          ),
          child: AlertDialog(
            title: Text(title),
            content: Text(content),
            actions: <Widget>[
              TextButton(
                onPressed: onOk, // Fungsi yang dipanggil saat tombol OK ditekan
                child: const Text('OK'),
              ),
            ],
          ),
        );
      },
    );
  }
}
