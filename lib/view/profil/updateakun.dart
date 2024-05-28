import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tugasakhir/model/usermodel.dart';

class UpdateAccount extends StatefulWidget {
  const UpdateAccount({
    Key? key,
    this.uId,
    this.uName,
    this.uEmail,
  }) : super(key: key);

  final String? uId;
  final String? uName;
  final String? uEmail;

  @override
  State<UpdateAccount> createState() => _UpdateAccountState();
}

class _UpdateAccountState extends State<UpdateAccount> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? newName;
  String? newEmail;
  bool isLoading = false;

  Future<UserModel?> _getUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      if (snapshot.exists) {
        return UserModel.fromMap(snapshot.data()!);
      }
    }
    return null;
  }

  Future<void> _updateUserData(String uid, String name, String email) async {
    setState(() {
      isLoading = true;
    });
    try {
      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'uName': name,
        'uEmail': email,
      });

      // Update email in FirebaseAuth if it was changed
      final user = FirebaseAuth.instance.currentUser;
      if (user != null && user.email != email) {
        await user.updateEmail(email);
        await user.sendEmailVerification(); // Kirim ulang email verifikasi
      }
    } catch (e) {
      print('Error updating user data: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  // Panggil fungsi ini setelah pengguna berhasil mengubah email
  void sendEmailVerificationToOldEmail() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        await user.sendEmailVerification();
        print("Email verification sent to old email: ${user.email}");
      } catch (e) {
        print("Error sending email verification: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Akun'),
      ),
      body: FutureBuilder<UserModel?>(
        future: _getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return const Center(child: Text('User data not found'));
          }

          final userData = snapshot.data!;
          newName = userData.uName;
          newEmail = userData.uEmail;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  TextFormField(
                    initialValue: newName,
                    decoration: const InputDecoration(labelText: 'Name'),
                    onSaved: (value) {
                      newName = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Nama tidak boleh kosong';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    initialValue: newEmail,
                    decoration: const InputDecoration(labelText: 'Email'),
                    onSaved: (value) {
                      newEmail = value;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email tidak boleh kosong';
                      } else if (!value.contains('@')) {
                        return 'Masukkan email yang benar';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              await _updateUserData(
                                  userData.uId, newName!, newEmail!);
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Profil berhasil diperbarui'),
                                ),
                              );
                              Navigator.pop(
                                  context); // Kembali ke halaman sebelumnya
                            }
                          },
                          child: const Text('Simpan Perubahan'),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
