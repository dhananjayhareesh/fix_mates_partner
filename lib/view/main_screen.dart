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
            return const HomeScreen();
          case 1:
            return const ReviewScreen();
          case 2:
            return BookingScreen();
          case 3:
            return const ProfileScreen();
          default:
            return const HomeScreen();
        }
      }),
      bottomNavigationBar: Obx(
        () => BottomNavigationBar(
          currentIndex: _controller.currentIndex.value,
          onTap: _controller.changeIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
                color: Colors.black45,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.star,
                color: Colors.black45,
              ),
              label: 'Reviews',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.calendar_month,
                color: Colors.black45,
              ),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
                color: Colors.black45,
              ),
              label: 'Profile',
            ),
          ],
          selectedItemColor: Colors.black,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
