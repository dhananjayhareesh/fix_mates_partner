import 'package:fix_mates_servicer/view/booking_screens/booking_screen.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';
import 'package:fix_mates_servicer/view/profile_screens/profile_screen.dart';
import 'package:fix_mates_servicer/view/review_screens/review_screen.dart';
import 'package:fix_mates_servicer/view_model/bottom_nav_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class MainScreen extends StatelessWidget {
  MainScreen({super.key});
  final BottomNavController _controller = Get.put(BottomNavController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        switch (_controller.currentIndex.value) {
          case 0:
            return HomeScreen();
          case 1:
            return const ReviewScreen();
          case 2:
            return BookingScreen();
          case 3:
            return const ProfileScreen();
          default:
            return HomeScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 2,
                blurRadius: 5,
              ),
            ],
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
            child: BottomNavigationBar(
              currentIndex: _controller.currentIndex.value,
              onTap: _controller.changeIndex,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0, // No elevation as we added custom shadows.
              items: [
                BottomNavigationBarItem(
                  icon: _buildNavItemIcon(
                    icon: Icons.home,
                    index: 0,
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItemIcon(
                    icon: Icons.star,
                    index: 1,
                  ),
                  label: 'Reviews',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItemIcon(
                    icon: Icons.calendar_month,
                    index: 2,
                  ),
                  label: 'Bookings',
                ),
                BottomNavigationBarItem(
                  icon: _buildNavItemIcon(
                    icon: Icons.person,
                    index: 3,
                  ),
                  label: 'Profile',
                ),
              ],
              selectedItemColor: Colors.blueAccent,
              unselectedItemColor: Colors.grey,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 12,
              ),
              showUnselectedLabels: true,
              selectedIconTheme: const IconThemeData(size: 28),
              unselectedIconTheme: const IconThemeData(size: 24),
            ),
          ),
        ),
      ),
    );
  }

  // Custom method for building enhanced icons with animation
  Widget _buildNavItemIcon({required IconData icon, required int index}) {
    return Obx(
      () {
        bool isSelected = _controller.currentIndex.value == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: isSelected ? 48 : 40,
          height: isSelected ? 48 : 40,
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.blueAccent.withOpacity(0.1)
                : Colors.transparent,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isSelected ? Colors.blueAccent : Colors.grey,
          ),
        );
      },
    );
  }
}
