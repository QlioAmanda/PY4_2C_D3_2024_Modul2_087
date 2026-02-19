// Nama : Qlio Amanda Febriany | Nim : 241511087 | Kelas : 2C
import 'package:flutter/material.dart';
import 'login_controller.dart';
import '../logbook/counter_view.dart' as logbook;

class LoginView extends StatefulWidget {
  const LoginView({super.key});
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _c = LoginController();
  final TextEditingController _userC = TextEditingController();
  final TextEditingController _passC = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isObscure = true;

  // PALET WARNA VINTAGE
  final Color _bgCream = const Color(0xFFFDF5E6);
  final Color _brownPrimary = const Color(0xFF6D4C41);
  final Color _brownText = const Color(0xFF3E2723);

  @override
  void dispose() {
    _userC.dispose(); _passC.dispose(); _c.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      if (_c.login(_userC.text, _passC.text)) {
        Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => logbook.CounterView(username: _userC.text)),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(_c.isLocked.value ? "Akses terkunci!" : "Akun tidak valid!", 
            style: const TextStyle(color: Colors.white)),
          backgroundColor: _c.isLocked.value ? const Color(0xFFC62828) : const Color(0xFFA1887F),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgCream,
      appBar: AppBar(
        title: Text("Gatekeeper LogBook", 
          style: TextStyle(color: _brownText, fontWeight: FontWeight.bold, fontFamily: 'serif')),
        backgroundColor: Colors.transparent, elevation: 0, centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(30.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.menu_book_rounded, size: 90, color: _brownPrimary),
                const SizedBox(height: 30),
                _buildTextField(_userC, "Username", Icons.person),
                const SizedBox(height: 15),
                _buildTextField(_passC, "Password", Icons.lock, isPass: true),
                const SizedBox(height: 25),
                
                // REVISI LINT: Menghapus underscore ganda & withOpacity
                ValueListenableBuilder<bool>(
                  valueListenable: _c.isLocked,
                  builder: (ctxLock, isLocked, childLock) => ValueListenableBuilder<int>(
                    valueListenable: _c.remainingTime,
                    builder: (ctxTime, timeLeft, childTime) => SizedBox(
                      width: double.infinity, height: 50,
                      child: ElevatedButton(
                        onPressed: isLocked ? null : _handleLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _brownPrimary, foregroundColor: _bgCream,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                          elevation: 5, shadowColor: _brownText.withValues(alpha: 0.3), // FIX OPACITY
                        ),
                        child: Text(isLocked ? "Terkunci ($timeLeft s)" : "Buka LogBook", 
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, fontFamily: 'serif')),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool isPass = false}) {
    return TextFormField(
      controller: controller, obscureText: isPass ? _isObscure : false, maxLength: isPass ? 8 : null,
      style: TextStyle(color: _brownText, fontFamily: 'serif'),
      decoration: InputDecoration(
        labelText: label, labelStyle: TextStyle(color: _brownPrimary),
        prefixIcon: Icon(icon, color: _brownPrimary),
        filled: true, fillColor: const Color(0xFFFFF8E1),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: _brownPrimary)),
        // FIX OPACITY DI BAWAH INI
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: _brownPrimary.withValues(alpha: 0.5))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide(color: _brownPrimary, width: 2)),
        suffixIcon: isPass ? IconButton(
          icon: Icon(_isObscure ? Icons.visibility_off : Icons.visibility, color: _brownPrimary),
          onPressed: () => setState(() => _isObscure = !_isObscure),
        ) : null,
      ),
      validator: (v) => isPass ? (v!.length < 3 ? 'Minimal 3 karakter!' : null) : (v!.isEmpty ? 'Wajib diisi!' : null),
    );
  }
}