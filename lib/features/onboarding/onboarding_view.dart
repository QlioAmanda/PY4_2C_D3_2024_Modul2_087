// Nama : Qlio Amanda Febriany | Nim : 241511087 | Kelas : 2C
import 'package:flutter/material.dart';
import 'dart:ui'; // PENTING: Untuk efek Blur/Kaca (Glassmorphism)
import '../../auth/login_view.dart';

class OnboardingView extends StatefulWidget {
  const OnboardingView({super.key});
  @override
  State<OnboardingView> createState() => _OnboardingViewState();
}

class _OnboardingViewState extends State<OnboardingView> {
  final PageController _pageC = PageController();
  int _curPage = 0;

  final List<Map<String, String>> _data = [
    {
      "img": "assets/images/vintage_book.jpg",
      "title": "Mulai Lembaran Baru",
      "desc": "Selamat datang. Awali hari cerahmu dengan mencatat aktivitas secara terstruktur."
    },
    {
      "img": "assets/images/vintage_clock.jpg",
      "title": "Pantau Waktumu",
      "desc": "Lihat perputaran rutinitas layaknya jarum jam. Jangan ada yang terlewat!"
    },
    {
      "img": "assets/images/vintage_camera.jpg",
      "title": "Abadikan Momen!",
      "desc": "Jadikan hari-harimu lebih produktif. Ayo buka LogBook dan mulai mencatat!"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageC,
            onPageChanged: (v) => setState(() => _curPage = v),
            itemCount: _data.length,
            itemBuilder: (_, i) => _buildPage(_data[i]),
          ),
          Positioned(bottom: 30, left: 30, right: 30, child: _buildBottom()),
        ],
      ),
    );
  }

  Widget _buildPage(Map<String, String> item) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(image: AssetImage(item["img"]!), fit: BoxFit.cover),
      ),
      child: Container(
        padding: const EdgeInsets.only(bottom: 110, left: 24, right: 24),
        alignment: Alignment.bottomCenter,
        // EFEK KACA BURAM VINTAGE (Glassmorphism)
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8), // Kekuatan blur kaca
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: const Color(0xFF3E2723).withValues(alpha: 0.65), // Coklat gelap transparan
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFD4AF37).withValues(alpha: 0.4), width: 1.5), // Garis tepi emas pudar
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(item["title"]!, textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFFFDF5E6), 
                      fontFamily: 'serif', letterSpacing: 1.2
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Garis pemisah keemasan yang elegan
                  Divider(color: const Color(0xFFD4AF37).withValues(alpha: 0.5), thickness: 1, indent: 40, endIndent: 40),
                  const SizedBox(height: 12),
                  Text(item["desc"]!, textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15, color: Colors.white70, height: 1.6, 
                      fontFamily: 'serif', fontStyle: FontStyle.italic // Tulisan miring klasik
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBottom() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: List.generate(_data.length, (i) => AnimatedContainer(
            duration: const Duration(milliseconds: 300), 
            margin: const EdgeInsets.only(right: 6),
            height: 10, width: _curPage == i ? 25 : 10,
            decoration: BoxDecoration(
              color: _curPage == i ? const Color(0xFFFDF5E6) : Colors.white54,
              borderRadius: BorderRadius.circular(5),
            ),
          )),
        ),
        ElevatedButton(
          onPressed: () {
            if (_curPage == _data.length - 1) {
              Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => const LoginView())
              );
            } else {
              _pageC.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFDF5E6), // Cream
            foregroundColor: const Color(0xFF6D4C41), // Brown Text
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 5,
          ),
          child: Text(_curPage == _data.length - 1 ? "Mulai" : "Lanjut", 
            style: const TextStyle(fontWeight: FontWeight.bold, fontFamily: 'serif')),
        ),
      ],
    );
  }
}