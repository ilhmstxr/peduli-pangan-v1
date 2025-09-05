import 'package:flutter/material.dart';

// Nama class diubah menjadi ScanPage2 agar cocok dengan definisi di app_routes.dart
class ScanPage2 extends StatefulWidget {
  const ScanPage2({super.key});

  @override
  State<ScanPage2> createState() => _ScanPage2State();
}

class _ScanPage2State extends State<ScanPage2>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _scanAnimation =
        Tween<double>(begin: -0.1, end: 1.1).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
    _animationController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final scannerSize = screenSize.width * 0.7;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF63D471), Color(0xFF238A31)],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          // Main content
          Center(
            child: SizedBox(
              width: scannerSize,
              height: scannerSize,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      'https://i.ibb.co/L5hPbrJ/sate-ayam.png',
                      width: scannerSize * 0.95,
                      height: scannerSize * 0.95,
                      fit: BoxFit.cover,
                    ),
                  ),
                  CustomPaint(
                    size: Size(scannerSize, scannerSize),
                    painter: ScannerPainter(),
                  ),
                  AnimatedBuilder(
                    animation: _scanAnimation,
                    builder: (context, child) {
                      return Positioned(
                        top: _scanAnimation.value * scannerSize,
                        child: Container(
                          width: scannerSize,
                          height: 3,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.7),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
          // Bottom Information Card
          _buildBottomCard(),
          // Back Button (opsional, jika halaman ini bisa diakses dari halaman lain)
          Positioned(
            top: 50,
            left: 20,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () {
                  // Jika ada halaman sebelumnya, gunakan pop.
                  // Jika tidak, mungkin arahkan ke home.
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    // Opsi: Arahkan ke halaman home jika tidak ada halaman untuk kembali
                    // Navigator.pushReplacementNamed(context, AppRoutes.home);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ... (Salin fungsi _buildBottomCard dan class ScannerPainter dari jawaban sebelumnya ke sini)
  Widget _buildBottomCard() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
        decoration: const BoxDecoration(
          color: Color(0xFFF3F4F6),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.network('https://i.ibb.co/L5hPbrJ/sate-ayam.png',
                      width: 50, height: 50, fit: BoxFit.cover)),
              const SizedBox(width: 15),
              const Expanded(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text("Sate Ayam",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    SizedBox(height: 4),
                    Row(children: [
                      Text("Layak untuk dimakan",
                          style: TextStyle(color: Colors.green)),
                      SizedBox(width: 5),
                      Icon(Icons.check_circle, color: Colors.green, size: 16)
                    ])
                  ])),
              const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18)
            ]),
            const SizedBox(height: 20),
            const Text("Kelayakan Makanan",
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.black54)),
            const SizedBox(height: 10),
            LayoutBuilder(builder: (context, constraints) {
              return Stack(children: [
                Container(
                    width: double.infinity,
                    height: 8,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: const LinearGradient(
                            colors: [Color(0xFFE57373), Color(0xFF66BB6A)],
                            stops: [0.3, 0.3]))),
                Positioned(
                    left: constraints.maxWidth * 0.3 - 2,
                    child: Container(
                        width: 4,
                        height: 8,
                        color: const Color(0xFF8A2BE2)))
              ]);
            }),
            const SizedBox(height: 20),
            const Row(children: [
              Icon(Icons.list_alt, color: Colors.black54),
              SizedBox(width: 15),
              Expanded(
                  child: Text("Read more about ingredients",
                      style: TextStyle(
                          fontSize: 16, fontWeight: FontWeight.w500))),
              Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 18)
            ])
          ],
        ),
      ),
    );
  }
}

class ScannerPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round;
    double cornerLength = size.width * 0.1;
    canvas.drawLine(const Offset(0, 0), Offset(cornerLength, 0), paint);
    canvas.drawLine(const Offset(0, 0), Offset(0, cornerLength), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width - cornerLength, 0), paint);
    canvas.drawLine(
        Offset(size.width, 0), Offset(size.width, cornerLength), paint);
    canvas.drawLine(
        Offset(0, size.height), Offset(cornerLength, size.height), paint);
    canvas.drawLine(Offset(0, size.height),
        Offset(0, size.height - cornerLength), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width - cornerLength, size.height), paint);
    canvas.drawLine(Offset(size.width, size.height),
        Offset(size.width, size.height - cornerLength), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}