import 'package:flutter/material.dart';
import '../../auth/login_view.dart'; // Pastikan path ini sesuai dengan struktur foldermu

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});

  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  // Variabel untuk menyimpan langkah saat ini
  int step = 1;

  void _nextStep() {
    setState(() {
      if (step < 3) {
        // Jika belum langkah 3, tambah angkanya
        step++;
      } else {
        // Jika sudah melewati langkah 3, pindah ke halaman Login
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginView()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Halaman Onboarding",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),
            // Menampilkan angka yang membesar
            Text(
              '$step',
              style: const TextStyle(fontSize: 100, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 60),
            // Tombol Lanjut
            ElevatedButton(
              onPressed: _nextStep,
              child: const Text("Lanjut"),
            ),
          ],
        ),
      ),
    );
  }
}