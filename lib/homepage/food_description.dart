import 'package:flutter/material.dart';

class FoodDescriptionPage extends StatelessWidget {
  const FoodDescriptionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Center(
                      child: Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Kolom Kiri
                        Expanded(child: _buildLeftColumn()),
                        const SizedBox(width: 16),
                        // Kolom Kanan
                        Expanded(child: _buildRightColumn()),
                      ],
                    ),
                    const SizedBox(height: 24),
                    _buildIngredientsCard(),
                    const SizedBox(height: 32),
                    _buildFreshnessIndicator(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget untuk AppBar dengan gambar
  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      backgroundColor: const Color(0xFFE8F5E9), // Warna hijau muda
      elevation: 0,
      pinned: true,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Image.asset(
          'assets/sate_ayam.png', // Ganti dengan path gambar Anda
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  // Widget untuk kolom kiri
  Widget _buildLeftColumn() {
    return Column(
      children: [
        _buildInfoCard(
          iconPath: 'assets/icons/food_plate.png',
          title: 'Nama Makanan',
          value: 'Sate Ayam',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          iconPath: 'assets/icons/category.png',
          title: 'Kategori',
          value: 'Kuliner Lokal',
        ),
        const SizedBox(height: 16),
        _buildInfoCard(
          iconPath: 'assets/icons/hourglass.png',
          title: 'Estimasi Umur Simpan',
          value: '± 4 jam sejak dibuat',
        ),
        const SizedBox(height: 16),
        _buildStatusCard(
            title: 'Status Konsumsi', value: 'Layak Dikonsumsi'),
        const SizedBox(height: 16),
        _buildQuoteCard(),
      ],
    );
  }

  // Widget untuk kolom kanan (Nutrisi)
  Widget _buildRightColumn() {
    return Column(
      children: [
        _buildNutritionCard('Kalori', '🔥 270 kcal', '*Total energi per porsi'),
        const SizedBox(height: 12),
        _buildNutritionCard('Karbohidrat', '🍞 10g', '*Bisa disertai persen AKG'),
        const SizedBox(height: 12),
        _buildNutritionCard('Protein', '🍗 22g', '*Penting untuk konsumen sadar protein'),
        const SizedBox(height: 12),
        _buildNutritionCard('Lemak', '🧈 15g', ''),
        const SizedBox(height: 12),
        _buildNutritionCard('Gula', '🍬 4g', '*Penting untuk konsumen diabetes'),
        const SizedBox(height: 12),
        _buildNutritionCard('Sodium', '🧂 650mg', ''),
      ],
    );
  }

  // Card info umum (nama makanan, kategori, dll)
  Widget _buildInfoCard({required String iconPath, required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Image.asset(iconPath, width: 24, height: 24),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // Card khusus untuk status
  Widget _buildStatusCard({required String title, required String value}) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.check_circle, color: Colors.green),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              const SizedBox(height: 2),
              Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  // Card untuk quote kuning
  Widget _buildQuoteCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.amber.shade100,
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: Text(
          '“Konsumsi secepatnya agar tetap aman dan lezat”',
          textAlign: TextAlign.center,
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
        ),
      ),
    );
  }

  // Card untuk nutrisi
  Widget _buildNutritionCard(String title, String value, String subtitle) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(color: Colors.grey, fontSize: 12)),
            ],
          ),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ]
        ],
      ),
    );
  }
  
  // Card untuk ingredients
  Widget _buildIngredientsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ingredients',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Daging ayam\nBumbu Kacang', style: TextStyle(height: 1.5)),
              SizedBox(width: 8),
              Text(': Daging Ayam\n: Kacang tanah, bawang, gula merah, cabai, garam', style: TextStyle(height: 1.5)),
            ],
          )
        ],
      ),
    );
  }

  // Widget untuk indikator kesegaran (progress bar)
  Widget _buildFreshnessIndicator() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '69%', // Anda bisa mengganti nilai ini
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Stack(
          children: [
            Container(
              height: 10,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) {
                // Persentase kesegaran (0.0 - 1.0)
                const freshness = 0.69; 
                final redWidth = constraints.maxWidth * freshness;
                final greenWidth = constraints.maxWidth * (1 - freshness);

                return Row(
                  children: [
                    Container(
                      width: redWidth,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          bottomLeft: Radius.circular(5),
                        ),
                      ),
                    ),
                    Container(
                      width: greenWidth,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
             Positioned(
              left: 135, // Sesuaikan posisi handle
              top: -3,
              child: Container(
                width: 4,
                height: 16,
                decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}