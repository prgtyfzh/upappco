import 'package:flutter/material.dart';
import 'package:tugasakhir/controller/authcontroller.dart';
import 'package:tugasakhir/model/usermodel.dart';
import 'package:tugasakhir/view/loginpage.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>(); // Kunci form untuk validasi
  final authController = AuthController(); // Inisialisasi AuthController
  final _passwordController =
      TextEditingController(); // Kontroler untuk password field
  bool isPasswordVisible = false; // Menyimpan status visibilitas password
  bool isConfirmPasswordVisible =
      false; // Menyimpan status visibilitas konfirmasi password

  String? name; // Menyimpan nilai nama
  String? email; // Menyimpan nilai email
  String? password; // Menyimpan nilai password
  String? confirmPassword; // Menyimpan nilai konfirmasi password

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context)
                  .size
                  .height, // Mengatur tinggi minimum agar scroll view mengisi layar
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Image.asset(
                        'assets/image/logoupapp.png',
                        height: 200, // Menampilkan gambar logo aplikasi
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.account_circle),
                          hintText: 'Masukkan nama',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Nama tidak boleh kosong'; // Validasi nama kosong
                          }
                          if (value.length > 30) {
                            return 'Nama tidak boleh lebih dari 30 karakter'; // Validasi panjang nama
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            name = value; // Menyimpan nilai nama
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.email),
                          hintText: 'Masukkan email',
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Email tidak boleh kosong'; // Validasi email kosong
                          } else if (!value.contains('@')) {
                            return 'Masukkan email yang benar'; // Validasi format email
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value; // Menyimpan nilai email
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText:
                            !isPasswordVisible, // Atur visibilitas password
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Masukkan kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isPasswordVisible =
                                    !isPasswordVisible; // Toggle visibilitas password
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi tidak boleh kosong'; // Validasi password kosong
                          } else if (value.length < 6) {
                            return 'Kata sandi harus berisi minimal 6 karakter'; // Validasi panjang password
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value; // Menyimpan nilai password
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        obscureText:
                            !isConfirmPasswordVisible, // Atur visibilitas konfirmasi password
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          prefixIcon: const Icon(Icons.lock),
                          hintText: 'Masukkan konfirmasi kata sandi',
                          suffixIcon: IconButton(
                            icon: Icon(
                              isConfirmPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                            onPressed: () {
                              setState(() {
                                isConfirmPasswordVisible =
                                    !isConfirmPasswordVisible; // Toggle visibilitas konfirmasi password
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi tidak boleh kosong'; // Validasi konfirmasi password kosong
                          }
                          if (value != _passwordController.text) {
                            return 'Kata sandi harus sama'; // Validasi kesesuaian password
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            confirmPassword =
                                value; // Menyimpan nilai konfirmasi password
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 35),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          if (password == confirmPassword) {
                            if (name != null &&
                                email != null &&
                                password != null) {
                              UserModel? registeredUser = await authController
                                  .registerWithEmailAndPassword(
                                      email!, password!, name!, context);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xFF24675B), // Warna tombol
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(18), // Bentuk tombol
                        ),
                        minimumSize: const Size(280, 50), // Ukuran tombol
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white, // Warna teks tombol
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Sudah punya akun?"),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const LoginPage(), // Navigasi ke halaman login
                              ),
                            );
                          },
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB18154), // Warna teks tombol
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
