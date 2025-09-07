import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import 'widgets/food_list_section.dart';
import 'widgets/restaurant_hero_section_new.dart';
import 'widgets/restaurant_info_card.dart';

class RestaurantDetailScreenNew extends StatefulWidget {
  const RestaurantDetailScreenNew({super.key});

  @override
  State<RestaurantDetailScreenNew> createState() =>
      _RestaurantDetailScreenNewState();
}

class _RestaurantDetailScreenNewState extends State<RestaurantDetailScreenNew> {
  // ... (data restaurantData tetap sama) ...
  final Map<String, dynamic> restaurantData = {
    "name": "JCO",
    "address": "Tunjungan Plaza, Jl. Embong Malang No.5 Lantai 4",
    "rating": 4.8,
    "image":
        "https://images.unsplash.com/photo-1551024601-bec78aea704b?q=80&w=1964&auto=format&fit=crop",
    "logo":
        "https://upload.wikimedia.org/wikipedia/commons/thumb/8/8a/J.CO_Donuts_%26_Coffee_logo.svg/1200px-J.CO_Donuts_%26_Coffee_logo.svg.png",
  };

  // --- PERUBAHAN DI SINI ---
  // Mock data disesuaikan dengan kebutuhan komponen FoodItemTile yang baru
  final List<Map<String, dynamic>> foodItems = [
    {
      "name": "Donat Kentang",
      "pickupTime": "18:00 - 20:00 WIB", // DATA BARU
      "itemsLeft": 3, // DATA BARU
      "distance": "800m",
      "price": "Rp 10.000",
      "image": "assets/images/food/donut.png",
    },
    {
      "name": "Hot Dog",
      "pickupTime": "18:00 - 20:00 WIB", // DATA BARU
      "itemsLeft": 5, // DATA BARU
      "distance": "800m",
      "price": "Rp 15.000",
      "image": "assets/images/food/hotdog.png", // Ganti dengan path lokal
    }
  ];
  // --- BATAS PERUBAHAN ---

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(
      statusBarColor: Colors.transparent,
    ));

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          RestaurantHeroSection(
            restaurantName: restaurantData['name']!,
            imageUrl: restaurantData['image']!,
            logoUrl: restaurantData['logo']!,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                RestaurantInfoCard(
                  name: restaurantData['name']!,
                  address: restaurantData['address']!,
                  rating: restaurantData['rating']!,
                ),
                SizedBox(height: 3.h),
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
