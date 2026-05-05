import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'home_screen.dart';
import '../profile/profile_screen.dart';
import '../mystore/mystore_screen.dart';
import '../wishlist/wishlist_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int currentIndex = 0;

  final List<Widget> screens = [
    HomeScreen(),
    MystoreScreen(),
    const WishlistScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            onTap: (index) {
              setState(() {
                currentIndex = index;
              });
            },
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: 'nav.home'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.business),
              label: 'nav.store'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.favorite_border),
              label: 'nav.wishlist'.tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.person),
              label: 'nav.profile'.tr,
            ),
          ],
        ),
    );
  }
}
