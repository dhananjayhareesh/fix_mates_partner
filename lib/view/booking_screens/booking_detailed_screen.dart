import 'package:fix_mates_servicer/view_model/booking_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BookingDetailScreen extends StatelessWidget {
  final String bookingId;

  const BookingDetailScreen({required this.bookingId, super.key});

  @override
  Widget build(BuildContext context) {
    final BookingDetailController bookingController =
        Get.put(BookingDetailController());

    bookingController.fetchBooking(bookingId);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Booking Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        final booking = bookingController.booking.value;

        if (booking == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = booking.data() as Map<String, dynamic>?;

        if (data == null) {
          return const Center(child: Text('Booking not found.'));
        }

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailCard(title: 'Date', content: data['date']),
              _buildDetailCard(title: 'Time Slot', content: data['timeSlot']),
              _buildDetailCard(
                  title: 'Description', content: data['description']),
              _buildDetailCard(title: 'Status', content: data['status']),
              const SizedBox(height: 20),

              // Accept and Reject Buttons
              if (data['status'] == 'pending') ...[
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => bookingController.updateBookingStatus(
                            bookingId, 'accepted'),
                        icon: const Icon(Icons.check),
                        label: const Text('Accept'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => bookingController.updateBookingStatus(
                            bookingId, 'rejected'),
                        icon: const Icon(Icons.cancel),
                        label: const Text('Reject'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          padding: const EdgeInsets.symmetric(vertical: 16.0),
                        ),
                      ),
                    ),
                  ],
                ),
              ],

              // Start Button
              if (data['status'] == 'accepted')
                ElevatedButton.icon(
                  onPressed: data['startTime'] == null
                      ? () => bookingController.startBooking(bookingId)
                      : null,
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),

              // Stop Button
              if (data['status'] == 'in_progress')
                ElevatedButton.icon(
                  onPressed:
                      data['endTime'] == null && data['startTime'] != null
                          ? () => bookingController.stopBooking(bookingId)
                          : null,
                  icon: const Icon(Icons.stop),
                  label: const Text('Stop'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                  ),
                ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailCard({required String title, required String content}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4.0,
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(content),
      ),
    );
  }
}
