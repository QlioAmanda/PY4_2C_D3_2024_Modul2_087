// Nama : Qlio Amanda Febriany
// Nim : 241511087
// Kelas : 2C
/* CATATAN PENGEMBANGAN (AI ASSISTED):
  - File ini disusun dengan bantuan AI untuk menerapkan prinsip Clean Code.
  - Alasan Modularisasi: Memisahkan detail dekorasi UI (Presentational) 
    agar file View utama tidak membengkak lebih dari 200 baris.
  - Reusability: Widget didefinisikan secara statis agar efisien dalam penggunaan memori.
*/

import 'package:flutter/material.dart';
import 'counter_controller.dart';

class CounterWidgets {
  // 1. Panel Utama: Dibuat modular karena memiliki dekorasi gradasi dan shadow yang kompleks.
  // Memisahkan ini akan membuat struktur pohon widget (Widget Tree) di View utama tetap rapi.
  static Widget buildTotalPanel(int value) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 50),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [
          Colors.grey.shade300,
          const Color.fromARGB(255, 174, 203, 218)
        ]),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(color: Colors.black45, blurRadius: 4, offset: Offset(0, 2))
        ],
      ),
      child: Column(children: [
        const Text("TOTAL HITUNGAN",
            style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                fontFamily: 'serif')),
        Text('$value',
            style: const TextStyle(
                fontSize: 48, fontWeight: FontWeight.bold, fontFamily: 'serif')),
        const Text("Batas Maks: 300",
            style: TextStyle(
                fontSize: 10, color: Colors.blueGrey, fontFamily: 'serif')),
      ]),
    );
  }

  // 2. Panel Slider: Dipisah agar tidak memenuhi body di view utama.
  // Parameter setState dipassing (dilempar) agar slider tetap bisa merubah state di View.
  static Widget buildSliderPanel(CounterController controller, Function(VoidCallback) setState) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFCFD8DC),
        borderRadius: BorderRadius.circular(15),
        border: Border(top: BorderSide(color: Colors.blueGrey.shade700, width: 25)),
      ),
      child: Column(children: [
        Transform.translate(
          offset: const Offset(0, -30),
          child: const Text("ATUR LANGKAH (STEP)",
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10, fontFamily: 'serif')),
        ),
        Row(children: [
          Expanded(
            child: Slider(
              value: controller.step.toDouble(),
              min: 1, max: 10, divisions: 9,
              activeColor: const Color(0xFF546E7A),
              onChanged: (v) => setState(() => controller.setStep(v.toInt())),
            ),
          ),
          Text("${controller.step}/10", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        ]),
      ]),
    );
  }

  // 3. Panel Riwayat Aktivitas: Mengatur list riwayat yang tersimpan di controller.
  static Widget buildHistoryPanel(CounterController controller) {
    return Container(
      height: 265,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color(0xFF90A4AE),
          borderRadius: BorderRadius.circular(15)),
      clipBehavior: Clip.antiAlias,
      child: Column(children: [
        Container(
          width: double.infinity, padding: const EdgeInsets.symmetric(vertical: 8),
          color: Colors.white,
          child: const Text("RIWAYAT AKTIVITAS", textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'serif')),
        ),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: controller.history.length,
            itemBuilder: (context, index) {
              final item = controller.history[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                    color: getHistoryColor(item),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(item, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white)),
              );
            },
          ),
        ),
      ]),
    );
  }

  // 4. Circle Button: Dipecah agar tidak terjadi duplikasi kode (Don't Repeat Yourself - DRY).
  static Widget circleBtn(IconData icon, Color color, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        border: Border.all(color: Colors.white24, width: 2),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 24),
        onPressed: onTap,
      ),
    );
  }

  // 5. UI Logic Color: Memisahkan logika penentuan warna riwayat aktivitas agar 
  // file View utama benar-benar hanya fokus pada interaksi user.
  static Color getHistoryColor(String item) {
    if (item.contains("Ditambah")) return const Color(0xFF689F38);
    if (item.contains("Dikurang")) return const Color(0xFFC62828);
    if (item.contains("reset")) return const Color(0xFFF9A825);
    return Colors.blueGrey;
  }
}