import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'widgets/food_list_section.dart';
import 'widgets/restaurant_hero_section_new.dart';
import 'widgets/restaurant_info_card.dart';

class RestaurantDetailScreenNew extends StatefulWidget {
  const RestaurantDetailScreenNew({super.key});

  @override
  State<RestaurantDetailScreenNew> createState() => _RestaurantDetailScreenNewState();
}

class _RestaurantDetailScreenNewState extends State<RestaurantDetailScreenNew> {
  // Mock data disesuaikan dengan desain baru
  final Map<String, dynamic> restaurantData = {
    "name": "JCO",
    "address": "Tunjungan Plaza, Jl. Embong Malang No.5 Lantai 4",
    "rating": 4.8,
    "image":
        "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=1964&auto=format&fit=crop",
    "logo":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/J.CO_Donuts_%26_Coffee_logo.svg/1200px-J.CO_Donuts_%26_Coffee_logo.svg.png",
  };

  final List<Map<String, dynamic>> foodItems = [
    {
      "name": "Donat Kentang",
      "distance": "800m",
      "price": "Rp 10.000",
      "image":
          "https://cdn.pixabay.com/photo/2017/04/13/03/03/donut-2226245_1280.png",
    },
    {
      "name": "Kebab",
      "distance": "800m",
      "price": "Rp 10.000",
      "image":
          "https://cdn.pixabay.com/photo/2014/10/22/17/33/kebab-498302_1280.png",
    },
    {
      "name": "Hot Dog",
      "distance": "800m",
      "price": "Rp 10.000",
      "image":
          "https://cdn.pixabay.com/photo/2012/04/12/20/20/hot-dog-30467_1280.png",
    }
  ];

  @override
  Widget build(BuildContext context) {
    // Memberikan warna System UI Overlay yang transparan agar menyatu dengan app bar
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      // Menggunakan CustomScrollView untuk layout yang lebih fleksibel dengan slivers
      body: CustomScrollView(
        slivers: [
          // Bagian 1: Hero Section (Header dengan gambar dan logo)
          RestaurantHeroSection(
            restaurantName: restaurantData['name']!,
            imageUrl: restaurantData['image']!,
            logoUrl: restaurantData['logo']!,
          ),
          // Bagian 2: Konten di bawah header (Info dan Daftar Makanan)
          SliverList(
            delegate: SliverChildListDelegate(
              [
                // Card Informasi Restoran
                RestaurantInfoCard(
                  name: restaurantData['name']!,
                  address: restaurantData['address']!,
                  rating: restaurantData['rating']!,
                ),
                SizedBox(height: 3.h),
                // Section Daftar Makanan
                FoodListSection(
                  foodItems: foodItems,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
