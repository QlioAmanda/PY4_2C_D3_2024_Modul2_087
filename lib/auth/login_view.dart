// Nama : Qlio Amanda Febriany
// Nim : 241511087
// Kelas : 2C
// Catatan: Struktur UI menggunakan widget Form dan validasinya dioptimalkan 
// dengan bantuan AI, lalu diintegrasikan dengan ValueListenableBuilder 
// untuk mendengarkan lock state dari Controller.

import 'package:flutter/material.dart';
import 'login_controller.dart';
import '../logbook/counter_view.dart'; // Sesuaikan path jika berbeda

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _controller = LoginController();
  final TextEditingController _userController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  
  // Key wajib untuk validasi form kosong
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  // State untuk mata password
  bool _isObscure = true;

  @override
  void dispose() {
    _userController.dispose();
    _passController.dispose();
    _controller.dispose();
    super.dispose();
  }

  void _handleLogin() {
    // Cek apakah ada field yang kosong
    if (_formKey.currentState!.validate()) {
      String user = _userController.text;
      String pass = _passController.text;

      bool isSuccess = _controller.login(user, pass);

      if (isSuccess) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CounterView(username: user),
          ),
        );
      } else {
        // Cek apakah gagal karena salah pass atau karena terblokir
        if (_controller.isLocked.value) {
           ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Akses terkunci sementara!"), backgroundColor: Colors.red),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Username atau Password tidak valid!"), backgroundColor: Colors.orange),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login Gatekeeper")),
      // PERBAIKAN: Dibungkus Center dan SingleChildScrollView agar bisa di-scroll saat keyboard muncul
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Bungkus dengan Form agar validator berfungsi
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.security, size: 80, color: Colors.indigo),
                const SizedBox(height: 30),
                
                TextFormField(
                  controller: _userController,
                  decoration: const InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.person),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Username tidak boleh kosong!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                
                TextFormField(
                  controller: _passController,
                  obscureText: _isObscure,
                  // TWIST 1: Membatasi ketikan maksimal 8 karakter agar UI rapi
                  maxLength: 8, 
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure; // Toggle mata
                        });
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong!';
                    }
                    // TWIST 2: Logika validasi minimal karakter
                    // set minimal 3 karakter karena password "123" dan "087" panjangnya 3
                    if (value.length < 3) {
                      return 'Password terlalu pendek (minimal 3 karakter)!';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                
                // Reactive Button menggunakan Listeners
                ValueListenableBuilder<bool>(
                  valueListenable: _controller.isLocked,
                  builder: (context, isLocked, child) {
                    return ValueListenableBuilder<int>(
                      valueListenable: _controller.remainingTime,
                      builder: (context, timeLeft, child) {
                        return SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            // Jika isLocked true, onPressed menjadi null (tombol disable otomatis)
                            onPressed: isLocked ? null : _handleLogin,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                            ),
                            child: Text(
                              isLocked 
                                ? "Terkunci ($timeLeft detik)" 
                                : "Masuk"
                            ),
                          ),
                        );
                      }
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}