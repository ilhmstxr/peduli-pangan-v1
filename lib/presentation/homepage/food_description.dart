import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Anda bisa menjalankan aplikasi dengan widget ini sebagai halaman utama
class FoodDescriptionPage extends StatelessWidget {
  const FoodDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Membuat status bar menjadi terang agar ikonnya terlihat di atas gambar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);

    double valueSlider = 60; // Contoh nilai dinamis untuk slider konsumsi
    return Scaffold(
      backgroundColor: Colors.grey[200], // Warna latar belakang body
      body: SingleChildScrollView(
        child: Column(
          children: [
            // BAGIAN 1: GAMBAR HEADER & TOMBOL KEMBALI
            _buildHeaderImage(),

            // Memberi jarak antara header dengan konten
            const SizedBox(height: 16),

            // BAGIAN 2: KONTEN UTAMA (DESKRIPSI, NUTRISI, DLL)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildDescriptionSection(),
                  const SizedBox(height: 16),
                  _buildIngredientsSection(),
                  const SizedBox(height: 16),
                  _buildConsumptionSlider(valueSlider),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// WIDGET KOMPONEN: Gambar Header
Widget _buildHeaderImage() {
  return Stack(
    children: [
      ClipRRect(
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(30)),
        child: Image.asset(
          'asset/images/food/sate.png',
          height: 300,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      ),
      Positioned(
        top: 50,
        left: 16,
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              // Aksi ketika tombol kembali ditekan
            },
          ),
        ),
      ),
    ],
  );
}

// WIDGET KOMPONEN: Bagian Deskripsi Utama
Widget _buildDescriptionSection() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Description",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Kolom Kiri
            Expanded(
              child: _buildLeftInfoPanel(),
            ),
            const SizedBox(width: 16),
            // Kolom Kanan
            Expanded(
              child: _buildRightNutritionPanel(),
            ),
          ],
        )
      ],
    ),
  );
}

// WIDGET KOMPONEN: Panel Informasi Kiri
Widget _buildLeftInfoPanel() {
  return Column(
    children: [
      _buildInfoRow(
        icon: Icons.fastfood,
        title: "Nama Makanan",
        value: "Sate Ayam",
      ),
      _buildInfoRow(
        icon: Icons.category,
        title: "Kategori",
        value: "Kuliner Lokal",
      ),
      _buildInfoRow(
        icon: Icons.timer,
        title: "Estimasi Umur Simpan",
        value: "± 4 jam sejak dibuat",
      ),
      _buildInfoRow(
        icon: Icons.check_circle,
        title: "Status Konsumsi",
        value: "Layak Dikonsumsi",
        iconColor: Colors.green,
      ),
      const SizedBox(height: 16),
      Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.yellow[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Text(
          "“Konsumsi secepatnya agar tetap aman dan lezat”",
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      )
    ],
  );
}

// WIDGET KOMPONEN: Panel Nutrisi Kanan
Widget _buildRightNutritionPanel() {
  return Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      border: Border.all(color: Colors.grey[300]!),
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        _buildNutritionFact(
          label: "Kalori",
          value: "270 kcal",
          subtitle: "*Total energi per porsi",
          icon: Icons.local_fire_department,
          iconColor: Colors.orange,
        ),
        _buildNutritionFact(
          label: "Karbohidrat",
          value: "10g",
          subtitle: "*Bisa disertai persen AKG",
          icon: Icons.rice_bowl,
          iconColor: Colors.brown,
        ),
        _buildNutritionFact(
          label: "Protein",
          value: "22g",
          subtitle: "*Penting untuk konsumen sadar protein",
          icon: Icons.fitness_center,
          iconColor: Colors.red,
        ),
        _buildNutritionFact(
          label: "Lemak",
          value: "15g",
          subtitle: "",
          icon: Icons.water_drop,
          iconColor: Colors.amber,
        ),
        _buildNutritionFact(
          label: "Gula",
          value: "4g",
          subtitle: "*Penting untuk konsumen diabetes",
          icon: Icons.candlestick_chart_outlined,
          iconColor: Colors.pink,
        ),
        _buildNutritionFact(
          label: "Sodium",
          value: "650mg",
          subtitle: "",
          icon: Icons.grain,
          iconColor: Colors.blueGrey,
        ),
      ],
    ),
  );
}

// WIDGET KOMPONEN: Bagian Bahan-bahan (Ingredients)
Widget _buildIngredientsSection() {
  return Container(
    padding: const EdgeInsets.all(16.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Ingredients",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        _buildIngredientRow("Daging ayam", "Daging Ayam"),
        const Divider(),
        _buildIngredientRow(
            "Bumbu Kacang", "Kacang tanah, bawang, gula merah, cabai, garam"),
      ],
    ),
  );
}
Widget _buildConsumptionSlider(double value) {
  // Gunakan SizedBox untuk memberikan area yang cukup untuk slider dan teksnya
  return SizedBox(
    height: 60, // Total tinggi untuk area slider
    child: LayoutBuilder(
      builder: (context, constraints) {
        final double barWidth = constraints.maxWidth;
        // Hitung posisi horizontal untuk semua elemen indikator
        final double position = barWidth * value / 100;

        return Stack(
          alignment: Alignment.center, // Menengahkan semua elemen yang tidak di-Positioned secara vertikal
          clipBehavior: Clip.none,
          children: [
            // 1. Latar Belakang Bar (merah & hijau)
            Row(
              children: [
                Expanded(
                  flex: value.toInt(),
                  child: Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFFFE645A),
                      borderRadius:
                          BorderRadius.horizontal(left: Radius.circular(10)),
                    ),
                  ),
                ),
                Expanded(
                  flex: 100 - value.toInt(),
                  child: Container(
                    height: 12,
                    decoration: const BoxDecoration(
                      color: Color(0xFF34D17F),
                      borderRadius:
                          BorderRadius.horizontal(right: Radius.circular(10)),
                    ),
                  ),
                ),
              ],
            ),

            // 2. Garis Ungu Pemisah
            // Diposisikan secara horizontal, dan akan otomatis berada di tengah secara vertikal
            // karena alignment Stack adalah Alignment.center
            Positioned(
              left: position,
              child: Transform.translate(
                // Geser ke kiri sebesar setengah lebarnya (5 / 2 = 2.5) agar pas di tengah
                offset: const Offset(-2.5, 0),
                child: Container(
                  height: 12, // Tinggi SAMA DENGAN bar agar pas di tengah
                  width: 5,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6A5ACD),
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
            ),

            // 3. Grup Angka dan Panah
            // Diposisikan secara horizontal, dan secara vertikal di atas bar
            Positioned(
              left: position,
              bottom: 22, // Posisikan di atas bar (sesuaikan angka ini jika perlu)
              child: Transform.translate(
                // Geser grup ini agar titik tengahnya sejajar dengan garis ungu
                offset: const Offset(-20, 0), // Sesuaikan nilai -20 jika perlu
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Angka (di atas)
                    Text(
                      value.toInt().toString(),
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    // Panah (di bawah angka)
                    const Icon(Icons.arrow_drop_down,
                        size: 30, color: Colors.black),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    ),
  );
}
// Helper untuk baris info di panel kiri
Widget _buildInfoRow({
  required IconData icon,
  required String title,
  required String value,
  Color iconColor = Colors.black,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 24, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: Colors.grey[600])),
              const SizedBox(height: 2),
              Text(value,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16)),
            ],
          ),
        )
      ],
    ),
  );
}

// Helper untuk baris fakta nutrisi di panel kanan
Widget _buildNutritionFact({
  required String label,
  required String value,
  required String subtitle,
  required IconData icon,
  required Color iconColor,
}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6.0),
    child: Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 10, color: Colors.grey[600]),
                ),
            ],
          ),
        ),
        Icon(icon, color: iconColor, size: 16),
        const SizedBox(width: 8),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
      ],
    ),
  );
}

// Helper untuk baris bahan-bahan
Widget _buildIngredientRow(String name, String details) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Row(
      children: [
        Text(name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        const SizedBox(width: 8),
        const Text(":", style: TextStyle(fontSize: 16)),
        const SizedBox(width: 8),
        Expanded(
          child: Text(details, style: const TextStyle(fontSize: 16)),
        ),
      ],
    ),
  );
}
