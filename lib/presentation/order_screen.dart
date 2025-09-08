import 'package:flutter/material.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({Key? key}) : super(key: key);

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Order'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.green[800],
              unselectedLabelColor: Colors.black54,
              indicatorColor: Colors.green[800],
              indicatorWeight: 3,
              tabs: const [
                Tab(text: 'Ongoing'),
                Tab(text: 'History'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Ongoing orders
                // Ganti dengan kondisi jika tidak ada pesanan
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          color: Colors.green[50],
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.shopping_bag_outlined, size: 70, color: Colors.green[800]),
                      ),
                      const SizedBox(height: 24),
                      const Text('Belum ada pesanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/home-screen');
                        },
                        child: const Text('Pesan sekarang', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
                // TODO: History orders
                Center(child: Text('History orders here')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
