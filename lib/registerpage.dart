import 'package:flutter/material.dart';
import 'package:tugasakhir/controller/authcontroller.dart';
import 'package:tugasakhir/loginpage.dart';
import 'package:tugasakhir/model/usermodel.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final authController = AuthController();
  final _passwordController = TextEditingController();
  bool isPasswordVisible = false;
  bool isConfirmPasswordVisible = false;

  String? name;
  String? email;
  String? password;
  String? confirmPassword;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height,
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
                        height: 200,
                      ),
                    ),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     right: 250,
                    //   ),
                    //   child: const Text(
                    //     'Nama',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
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
                            return 'Nama tidak boleh kosong';
                          }
                          if (value.length > 30) {
                            return 'Nama tidak boleh lebih dari 30 karakter';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            name = value;
                          });
                        },
                      ),
                    ),

                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     right: 250,
                    //   ),
                    //   child: const Text(
                    //     'Email',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
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
                            return 'Email tidak boleh kosong';
                          } else if (!value.contains('@')) {
                            return 'Masukkan email yang benar';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            email = value;
                          });
                        },
                      ),
                    ),

                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     right: 210,
                    //   ),
                    //   child: const Text(
                    //     'Kata Sandi',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),

                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        controller: _passwordController,
                        obscureText: !isPasswordVisible,
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
                                isPasswordVisible = !isPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi tidak boleh kosong';
                          } else if (value.length < 6) {
                            return 'Kata sandi harus berisi minimal 6 karakter';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            password = value;
                          });
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Container(
                    //   margin: const EdgeInsets.only(
                    //     right: 125,
                    //   ),
                    //   child: const Text(
                    //     'Konfirmasi Kata Sandi',
                    //     style: TextStyle(
                    //       color: Colors.black,
                    //       fontWeight: FontWeight.bold,
                    //       fontSize: 16,
                    //     ),
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 50),
                      child: TextFormField(
                        obscureText: !isConfirmPasswordVisible,
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
                                    !isConfirmPasswordVisible;
                              });
                            },
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Kata sandi tidak boleh kosong';
                          }
                          if (value != _passwordController.text) {
                            return 'Kata sandi harus sama';
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
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
                                      email!, password!, name!);
                              if (registeredUser != null) {
                                // Registration successful
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return Theme(
                                      data: ThemeData(
                                        // Customize the color of the dialog background
                                        dialogBackgroundColor:
                                            const Color(0xFFD9D9D9),
                                      ),
                                      child: AlertDialog(
                                        title: const Text(
                                            'Registration Successful'),
                                        content: const Text(
                                            'You have been successfully registered.'),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.push(context,
                                                  MaterialPageRoute(
                                                      builder: (context) {
                                                return const LoginPage();
                                              }));
                                              // Navigate to the next screen or perform any desired action
                                            },
                                            child: const Text('OK'),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              }
                            } else {
                              // Registration failed
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return Theme(
                                    data: ThemeData(
                                      // Customize the color of the dialog background
                                      dialogBackgroundColor:
                                          const Color(0xFFD9D9D9),
                                    ),
                                    child: AlertDialog(
                                      title: const Text('Registration Failed'),
                                      content: const Text(
                                          'An error occurred during registration.'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF24675B),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(18),
                        ),
                        minimumSize: const Size(280, 50),
                      ),
                      child: const Text(
                        'Daftar',
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.white,
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
                                builder: (context) => const LoginPage(),
                              ),
                            );
                          },
                          child: const Text(
                            'Masuk',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB18154),
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
