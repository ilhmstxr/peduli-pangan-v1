import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with SingleTickerProviderStateMixin {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  Future<void>? _initializeControllerFuture;
  bool _isFlashOn = false;
  final ImagePicker _picker = ImagePicker();

  // Untuk animasi garis pemindai
  late AnimationController _animationController;
  late Animation<double> _scanAnimation;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _setupScanAnimation();
  }

  // Fungsi untuk inisialisasi kamera
  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    if (_cameras.isNotEmpty) {
      _cameraController = CameraController(
        _cameras[0], // Gunakan kamera utama
        ResolutionPreset.high,
      );
      _initializeControllerFuture = _cameraController!.initialize().then((_) {
        if (!mounted) {
          return;
        }
        setState(() {}); // Update UI setelah kamera siap
      });
    }
  }

  // Fungsi untuk mengatur animasi
  void _setupScanAnimation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.linear,
      ),
    );

    _animationController.repeat(reverse: false);
  }


  @override
  void dispose() {
    _cameraController?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  // Fungsi untuk toggle flash
  void _toggleFlash() {
    if (_cameraController != null &&
        _cameraController!.value.isInitialized) {
      setState(() {
        _isFlashOn = !_isFlashOn;
      });
      _cameraController!
          .setFlashMode(_isFlashOn ? FlashMode.torch : FlashMode.off);
    }
  }

  // Fungsi untuk mengambil gambar dari galeri
  Future<void> _pickImageFromGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      // TODO: Proses gambar yang dipilih dari galeri
      print('Image picked from gallery: ${image.path}');
    }
  }

  // Fungsi untuk mengambil gambar dengan kamera
  Future<void> _takePicture() async {
    try {
      await _initializeControllerFuture;
      final XFile image = await _cameraController!.takePicture();
      // TODO: Proses gambar yang diambil
      print('Picture taken: ${image.path}');
    } catch (e) {
      print('Error taking picture: $e');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Background Gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            // Camera Preview
            _buildCameraPreview(),

            // Scan Frame and Animation
            _buildScanOverlay(),

            // Custom App Bar
            _buildCustomAppBar(),

            // Bottom Controls
            _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraPreview() {
    // Menunggu controller siap sebelum menampilkan preview
    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (_cameraController != null &&
              _cameraController!.value.isInitialized) {
            final size = MediaQuery.of(context).size;
            return ClipRect(
              child: OverflowBox(
                alignment: Alignment.center,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: SizedBox(
                    width: size.width,
                    height: size.width * _cameraController!.value.aspectRatio,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
              ),
            );
          } else {
            return const Center(child: Text('Kamera tidak tersedia.', style: TextStyle(color: Colors.white),));
          }
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildScanOverlay() {
    return Center(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.7,
        height: MediaQuery.of(context).size.width * 0.7,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
          borderRadius: BorderRadius.circular(20),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: [
              // Animated Scan Line
              AnimatedBuilder(
                animation: _scanAnimation,
                builder: (context, child) {
                  return Positioned(
                    top: _scanAnimation.value * (MediaQuery.of(context).size.width * 0.7),
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 2,
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
    );
  }

  Widget _buildCustomAppBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white,
            child: Icon(Icons.arrow_back, color: Color(0xFF2E7D32)),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Scan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 40,
      left: 20,
      right: 20,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.3),
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            // Gallery Button
            IconButton(
              icon: const Icon(Icons.photo_library, color: Colors.white, size: 30),
              onPressed: _pickImageFromGallery,
            ),
            // Flash Button
            IconButton(
              icon: Icon(
                _isFlashOn ? Icons.flash_on : Icons.flash_off,
                color: Colors.white,
                size: 30,
              ),
              onPressed: _toggleFlash,
            ),
            // Take Picture Button
            IconButton(
              icon: const Icon(Icons.camera_alt, color: Colors.white, size: 30),
              onPressed: _takePicture,
            ),
          ],
        ),
      ),
    );
  }
}