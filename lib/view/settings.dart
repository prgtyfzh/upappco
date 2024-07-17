import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/loginpage.dart';
import 'package:tugasakhir/model/usermodel.dart';
import 'package:tugasakhir/view/profil/updateakun.dart';

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
                _buildEditAccountSection(context),
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
        backgroundImage: NetworkImage('https://via.placeholder.com/150'),
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

  Widget _buildEditAccountSection(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.edit),
      title: const Text('Edit Akun'),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const UpdateAccount(),
          ),
        ).then((_) {
          // Refresh the user data when returning from UpdateAccount page
          setState(() {
            _userDataFuture = _getUserData();
          });
        });
      },
    );
  }

  Widget _buildLogoutButton(BuildContext context) {
    return ListTile(
      leading: const Icon(Icons.logout),
      title: const Text('Keluar'),
      onTap: () async {
        await FirebaseAuth.instance.signOut();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
      },
    );
  }
}
