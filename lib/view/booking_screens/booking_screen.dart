import 'package:fix_mates_servicer/view/booking_screens/booking_detailed_screen.dart';
import 'package:fix_mates_servicer/view_model/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final BookingController controller = Get.put(BookingController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bookings'),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.bookings.isEmpty) {
          return const Center(child: Text('No bookings available.'));
        } else {
          return ListView.builder(
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text('Date: ${booking['date']}'),
                  subtitle: Text('User: ${booking['userName']}'),
                  trailing: Text('Time: ${booking['timeSlot']}'),
                  onTap: () {
                    Get.to(() =>
                        BookingDetailScreen(bookingId: booking['bookingId']));
                  },
                ),
              );
            },
          );
        }
      }),
    );
  }
}
