import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/controller/authcontroller.dart';
import 'package:tugasakhir/view/homepage.dart';
import 'package:tugasakhir/view/loginpage.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final authctr = AuthController();

  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    authctr.getCurrentUser();
    checkLoginStatus();
  }

  Future checkLoginStatus() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    if (user != null) {
      DocumentSnapshot<Map<String, dynamic>> userSnapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();

      if (userSnapshot.exists) {
        setState(() {
          isLogin = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLogin) {
      return const HomePage();
    } else {
      return const LoginPage();
    }
  }
}
