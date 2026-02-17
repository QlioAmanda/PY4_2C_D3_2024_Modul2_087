// Nama : Qlio Amanda Febriany
// Nim : 241511087
// Kelas : 2C
// Catatan: Kode dikembangkan bersama AI untuk optimalisasi struktur file dan Persistence.

import 'package:flutter/material.dart';
import 'counter_controller.dart';
import 'counter_widgets.dart';
import 'package:logbook_app_087/features/onboarding/onboarding_view.dart';

class CounterView extends StatefulWidget {
  final String username;
  const CounterView({super.key, required this.username});

  @override
  State<CounterView> createState() => _CounterViewState();
}

class _CounterViewState extends State<CounterView> {
  late CounterController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = CounterController(widget.username);
    // Task 3: Load Persistence Data
    _controller.loadData(() {
      if (mounted) setState(() => _isLoading = false);
    });
  }

  // REVISI: Fungsi Konfirmasi Logout (Mencegah salah pencet)
  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Logout"),
        content: const Text("Apakah Anda yakin ingin keluar? Data Anda telah tersimpan secara otomatis."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const OnboardingView()),
                (route) => false,
              );
            },
            child: const Text("Ya, Keluar", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // Fungsi Konfirmasi Reset Data
  void _showResetConfirmation() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Konfirmasi Reset"),
        content: const Text("Yakin ingin menghapus semua data hitungan Anda?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text("Batal")),
          TextButton(
            onPressed: () {
              setState(() => _controller.reset());
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Data berhasil di-reset!"), backgroundColor: Colors.orange));
            },
            child: const Text("Ya, Reset", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2E3138),
      appBar: AppBar(
        title: Text("LogBook: ${widget.username}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'serif')),
        centerTitle: true,
        backgroundColor: const Color(0xFFB0BEC5),
        toolbarHeight: 45,
        elevation: 2,
        actions: [
          // Memanggil dialog konfirmasi logout
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.black),
            onPressed: _showLogoutConfirmation,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  // Memanggil widget statis dari CounterWidgets
                  CounterWidgets.buildTotalPanel(_controller.value),
                  const SizedBox(height: 10),
                  // Memanggil slider dengan passing state
                  CounterWidgets.buildSliderPanel(_controller, (fn) => setState(fn)),
                  const SizedBox(height: 10),
                  _buildActionButtons(),
                  const SizedBox(height: 15),
                  // Memanggil panel histori
                  CounterWidgets.buildHistoryPanel(_controller),
                ],
              ),
            ),
    );
  }

  // Tombol aksi (Minus, Reset, Plus) diletakkan di view karena langsung merubah State
  Widget _buildActionButtons() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      CounterWidgets.circleBtn(Icons.remove, const Color(0xFFB71C1C), () {
        if (!_controller.decrement()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Minimal 0!"), backgroundColor: Colors.orange));
        } else { setState(() {}); }
      }),
      CounterWidgets.circleBtn(Icons.refresh, const Color(0xFFAFB42B), _showResetConfirmation),
      CounterWidgets.circleBtn(Icons.add, const Color(0xFF388E3C), () {
        if (!_controller.increment()) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text("Maksimal 300!"), backgroundColor: Colors.red));
        } else { setState(() {}); }
      }),
    ]);
  }
}