import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/view/loginpage.dart';
import 'package:tugasakhir/model/usermodel.dart';

class Pengaturan extends StatefulWidget {
  const Pengaturan({Key? key}) : super(key: key);

  @override
  State<Pengaturan> createState() => _PengaturanState();
}

class _PengaturanState extends State<Pengaturan> {
  late Future<UserModel?> _userDataFuture;

  Future<UserModel?> _getUserData() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final DocumentSnapshot<Map<String, dynamic>> snapshot =
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userDataFuture = _getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Pengaturan',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
        child: FutureBuilder<UserModel?>(
          future: _userDataFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text('User data not found'));
            }

            final userData = snapshot.data!;
            return ListView(
              children: [
                const SizedBox(height: 20),
                _buildProfileSection(userData),
                const SizedBox(height: 20),
                _buildLogoutButton(context),
                const SizedBox(height: 20),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildProfileSection(UserModel userData) {
    return ListTile(
      leading: const CircleAvatar(
        backgroundImage: AssetImage('assets/image/logoupapp.png'),
        radius: 40,
      ),
      title: Text(
        userData.uName,
        style: const TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      subtitle: Text(
        userData.uEmail,
        style: const TextStyle(
          fontSize: 16,
        ),
      ),
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Keluar'),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => const LoginPage(),
          ),
          (route) => false,
        );
      },
    );
  }
}
