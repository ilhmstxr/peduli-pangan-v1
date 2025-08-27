import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import './widgets/floating_cart_summary.dart';
import './widgets/menu_category_chips.dart';
import './widgets/menu_item_bottom_sheet.dart';
import './widgets/menu_item_card.dart';
import './widgets/restaurant_hero_section.dart';
import './widgets/restaurant_info_section.dart';
import './widgets/reviews_section.dart';

class RestaurantDetailScreen extends StatefulWidget {
  const RestaurantDetailScreen({super.key});

  @override
  State<RestaurantDetailScreen> createState() => _RestaurantDetailScreenState();
}

class _RestaurantDetailScreenState extends State<RestaurantDetailScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _menuScrollController;
  late ScrollController _categoryScrollController;

  String selectedCategory = 'Appetizers';
  int cartItemCount = 0;
  String cartTotal = '\$0.00';
  bool isRestaurantClosed = false;

  // Mock restaurant data
  final Map<String, dynamic> restaurantData = {
    "id": 1,
    "name": "Bella Vista Italian Kitchen",
    "cuisine": "Italian • Mediterranean",
    "rating": 4.8,
    "deliveryTime": "25-35 min",
    "deliveryFee": "Free delivery",
    "image":
        "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
    "address": "123 Main Street, Downtown District, New York, NY 10001",
    "phone": "+1 (555) 123-4567",
    "email": "info@bellavistakitchen.com",
    "hours": {
      "Monday": "11:00 AM - 10:00 PM",
      "Tuesday": "11:00 AM - 10:00 PM",
      "Wednesday": "11:00 AM - 10:00 PM",
      "Thursday": "11:00 AM - 10:00 PM",
      "Friday": "11:00 AM - 11:00 PM",
      "Saturday": "10:00 AM - 11:00 PM",
      "Sunday": "10:00 AM - 9:00 PM",
    },
    "deliveryPolicies": [
      "Minimum order of \$15 for delivery",
      "Free delivery on orders over \$30",
      "Delivery available within 5 miles radius",
      "Contact-free delivery available",
      "Orders can be cancelled within 5 minutes of placement",
    ],
  };

  // Mock menu data
  final List<String> menuCategories = [
    'Appetizers',
    'Pasta',
    'Pizza',
    'Main Courses',
    'Desserts',
    'Beverages',
  ];

  final Map<String, List<Map<String, dynamic>>> menuItems = {
    'Appetizers': [
      {
        "id": 1,
        "name": "Bruschetta Classica",
        "description":
            "Toasted bread topped with fresh tomatoes, basil, garlic, and extra virgin olive oil",
        "price": "\$12.99",
        "image":
            "https://images.unsplash.com/photo-1572695157366-5e585ab2b69f?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Appetizers",
      },
      {
        "id": 2,
        "name": "Antipasto Platter",
        "description":
            "Selection of cured meats, cheeses, olives, and marinated vegetables",
        "price": "\$18.99",
        "image":
            "https://images.unsplash.com/photo-1544025162-d76694265947?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Appetizers",
      },
    ],
    'Pasta': [
      {
        "id": 3,
        "name": "Spaghetti Carbonara",
        "description":
            "Classic Roman pasta with eggs, pancetta, parmesan cheese, and black pepper",
        "price": "\$16.99",
        "image":
            "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Pasta",
      },
      {
        "id": 4,
        "name": "Fettuccine Alfredo",
        "description":
            "Rich and creamy pasta with butter, parmesan cheese, and fresh herbs",
        "price": "\$15.99",
        "image":
            "https://images.unsplash.com/photo-1563379091339-03246963d96c?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Pasta",
      },
    ],
    'Pizza': [
      {
        "id": 5,
        "name": "Margherita Pizza",
        "description":
            "Traditional pizza with tomato sauce, fresh mozzarella, and basil leaves",
        "price": "\$14.99",
        "image":
            "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Pizza",
      },
      {
        "id": 6,
        "name": "Pepperoni Supreme",
        "description":
            "Classic pepperoni pizza with extra cheese and Italian herbs",
        "price": "\$17.99",
        "image":
            "https://images.unsplash.com/photo-1628840042765-356cda07504e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Pizza",
      },
    ],
    'Main Courses': [
      {
        "id": 7,
        "name": "Osso Buco Milanese",
        "description":
            "Braised veal shanks with vegetables, white wine, and broth served with risotto",
        "price": "\$28.99",
        "image":
            "https://images.unsplash.com/photo-1546833999-b9f581a1996d?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Main Courses",
      },
      {
        "id": 8,
        "name": "Grilled Salmon",
        "description":
            "Fresh Atlantic salmon with lemon herb butter and seasonal vegetables",
        "price": "\$24.99",
        "image":
            "https://images.unsplash.com/photo-1467003909585-2f8a72700288?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Main Courses",
      },
    ],
    'Desserts': [
      {
        "id": 9,
        "name": "Tiramisu",
        "description":
            "Classic Italian dessert with coffee-soaked ladyfingers and mascarpone cream",
        "price": "\$8.99",
        "image":
            "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Desserts",
      },
      {
        "id": 10,
        "name": "Panna Cotta",
        "description": "Silky smooth vanilla custard with berry compote",
        "price": "\$7.99",
        "image":
            "https://images.unsplash.com/photo-1488477181946-6428a0291777?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Desserts",
      },
    ],
    'Beverages': [
      {
        "id": 11,
        "name": "Italian Espresso",
        "description":
            "Rich and bold espresso made from premium Italian coffee beans",
        "price": "\$3.99",
        "image":
            "https://images.unsplash.com/photo-1510707577719-ae7c14805e3a?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Beverages",
      },
      {
        "id": 12,
        "name": "San Pellegrino",
        "description": "Sparkling natural mineral water from Italy",
        "price": "\$2.99",
        "image":
            "https://images.unsplash.com/photo-1544145945-f90425340c7e?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "category": "Beverages",
      },
    ],
  };

  // Mock reviews data
  final List<Map<String, dynamic>> reviewsData = [
    {
      "id": 1,
      "userName": "Sarah Johnson",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 5,
      "date": "2 days ago",
      "comment":
          "Absolutely amazing food! The pasta was perfectly cooked and the service was exceptional. Will definitely be coming back soon.",
      "images": [
        "https://images.unsplash.com/photo-1621996346565-e3dbc353d2e5?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
        "https://images.unsplash.com/photo-1574071318508-1cdbab80d002?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      ],
      "helpfulCount": 12,
    },
    {
      "id": 2,
      "userName": "Michael Chen",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 4,
      "date": "1 week ago",
      "comment":
          "Great Italian restaurant with authentic flavors. The pizza was delicious and the atmosphere was cozy. Delivery was quick too!",
      "images": [],
      "helpfulCount": 8,
    },
    {
      "id": 3,
      "userName": "Emily Rodriguez",
      "userAvatar":
          "https://cdn.pixabay.com/photo/2015/03/04/22/35/avatar-659652_640.png",
      "rating": 5,
      "date": "2 weeks ago",
      "comment":
          "Best tiramisu I've ever had! The portion sizes are generous and everything tastes fresh. Highly recommend this place.",
      "images": [
        "https://images.unsplash.com/photo-1571877227200-a0d98ea607e9?fm=jpg&q=60&w=3000&ixlib=rb-4.0.3",
      ],
      "helpfulCount": 15,
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _menuScrollController = ScrollController();
    _categoryScrollController = ScrollController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _menuScrollController.dispose();
    _categoryScrollController.dispose();
    super.dispose();
  }

  void _onCategorySelected(String category) {
    setState(() {
      selectedCategory = category;
    });
    // Scroll to category section in menu
    _scrollToCategory(category);
  }

  void _scrollToCategory(String category) {
    // Calculate scroll position based on category
    double scrollPosition = 0;
    for (int i = 0; i < menuCategories.indexOf(category); i++) {
      final categoryItems = menuItems[menuCategories[i]] ?? [];
      scrollPosition +=
          (categoryItems.length * 120) + 80; // Approximate heights
    }

    _menuScrollController.animateTo(
      scrollPosition,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  void _onAddToCart() {
    setState(() {
      cartItemCount++;
      // Calculate total (simplified)
      double total = cartItemCount * 15.99; // Average price
      cartTotal = '\$${total.toStringAsFixed(2)}';
    });
  }

  void _showMenuItemDetails(Map<String, dynamic> menuItem) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => MenuItemBottomSheet(
        menuItem: menuItem,
        onAddToCart: _onAddToCart,
      ),
    );
  }

  void _onViewCart() {
    // Navigate to cart screen or show cart bottom sheet
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Cart functionality would be implemented here'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _onShare() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Share functionality would be implemented here'),
        backgroundColor: AppTheme.lightTheme.primaryColor,
      ),
    );
  }

  void _showNotifyWhenOpenDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Restaurant Closed'),
        content: Text(
            'This restaurant is currently closed. Would you like to be notified when they open?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('You will be notified when the restaurant opens'),
                  backgroundColor: AppTheme.lightTheme.primaryColor,
                ),
              );
            },
            child: Text('Notify Me'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                // Custom App Bar
                SliverAppBar(
                  expandedHeight: 35.h,
                  floating: false,
                  pinned: true,
                  backgroundColor: theme.scaffoldBackgroundColor,
                  leading: IconButton(
                    icon: Container(
                      padding: EdgeInsets.all(2.w),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.3),
                        shape: BoxShape.circle,
                      ),
                      child: CustomIconWidget(
                        iconName: 'arrow_back_ios_new',
                        color: Colors.white,
                        size: 20,
                      ),
                    ),
                    onPressed: () {
                      HapticFeedback.lightImpact();
                      Navigator.pop(context);
                    },
                  ),
                  actions: [
                    IconButton(
                      icon: Container(
                        padding: EdgeInsets.all(2.w),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.3),
                          shape: BoxShape.circle,
                        ),
                        child: CustomIconWidget(
                          iconName: 'share',
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: _onShare,
                    ),
                    SizedBox(width: 2.w),
                  ],
                  flexibleSpace: FlexibleSpaceBar(
                    background: RestaurantHeroSection(
                      restaurant: restaurantData,
                    ),
                  ),
                ),

                // Tab Bar
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _SliverTabBarDelegate(
                    TabBar(
                      controller: _tabController,
                      tabs: const [
                        Tab(text: 'Menu'),
                        Tab(text: 'Reviews'),
                        Tab(text: 'Info'),
                      ],
                    ),
                  ),
                ),
              ];
            },
            body: TabBarView(
              controller: _tabController,
              children: [
                // Menu Tab
                Column(
                  children: [
                    // Category Chips
                    MenuCategoryChips(
                      categories: menuCategories,
                      selectedCategory: selectedCategory,
                      onCategorySelected: _onCategorySelected,
                      scrollController: _categoryScrollController,
                    ),

                    // Menu Items
                    Expanded(
                      child: ListView.builder(
                        controller: _menuScrollController,
                        padding: EdgeInsets.only(bottom: 15.h),
                        itemCount: _getTotalMenuItemCount(),
                        itemBuilder: (context, index) {
                          final itemData = _getMenuItemAtIndex(index);
                          if (itemData['isHeader'] == true) {
                            return _buildCategoryHeader(
                                theme, itemData['category'] as String);
                          } else {
                            return MenuItemCard(
                              menuItem:
                                  itemData['item'] as Map<String, dynamic>,
                              onTap: () => _showMenuItemDetails(
                                  itemData['item'] as Map<String, dynamic>),
                              onAddToCart: _onAddToCart,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // Reviews Tab
                ReviewsSection(reviews: reviewsData),

                // Info Tab
                RestaurantInfoSection(restaurant: restaurantData),
              ],
            ),
          ),

          // Restaurant Closed Overlay
          if (isRestaurantClosed)
            Container(
              color: Colors.black.withValues(alpha: 0.7),
              child: Center(
                child: Card(
                  margin: EdgeInsets.all(8.w),
                  child: Padding(
                    padding: EdgeInsets.all(6.w),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CustomIconWidget(
                          iconName: 'schedule',
                          color: theme.colorScheme.onSurfaceVariant,
                          size: 48,
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          'Restaurant Closed',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          'This restaurant is currently closed. Check back during business hours.',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 3.h),
                        ElevatedButton(
                          onPressed: _showNotifyWhenOpenDialog,
                          child: Text('Notify When Open'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Floating Cart Summary
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FloatingCartSummary(
              itemCount: cartItemCount,
              totalPrice: cartTotal,
              onViewCart: _onViewCart,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryHeader(ThemeData theme, String category) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
      child: Text(
        category,
        style: theme.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: AppTheme.lightTheme.primaryColor,
        ),
      ),
    );
  }

  int _getTotalMenuItemCount() {
    int count = 0;
    for (String category in menuCategories) {
      count += 1; // Header
      count += (menuItems[category] ?? []).length; // Items
    }
    return count;
  }

  Map<String, dynamic> _getMenuItemAtIndex(int index) {
    int currentIndex = 0;

    for (String category in menuCategories) {
      // Check if this is the header
      if (currentIndex == index) {
        return {'isHeader': true, 'category': category};
      }
      currentIndex++;

      // Check items in this category
      final items = menuItems[category] ?? [];
      for (var item in items) {
        if (currentIndex == index) {
          return {'isHeader': false, 'item': item};
        }
        currentIndex++;
      }
    }

    return {'isHeader': false, 'item': {}};
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;

  _SliverTabBarDelegate(this.tabBar);

  @override
  double get minExtent => tabBar.preferredSize.height;

  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar;
  }
}
