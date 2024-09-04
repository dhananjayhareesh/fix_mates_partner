import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fix_mates_servicer/view_model/booking_detail_controller.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart';

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
        final userName = bookingController.userName.value;
        final location = bookingController.location.value;
        final locationName = bookingController.locationName.value;

        if (booking == null) {
          return const Center(child: CircularProgressIndicator());
        }

        final data = booking.data() as Map<String, dynamic>?;

        if (data == null) {
          return const Center(child: Text('Booking not found.'));
        }

        final latitude = location?['latitude'] as double?;
        final longitude = location?['longitude'] as double?;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Map Display
              if (latitude != null && longitude != null)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          color: Color.fromARGB(255, 198, 197, 197),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: FlutterMap(
                        options: MapOptions(
                          onTap: (tapPosition, point) {
                            checkLocationPermissionToViewMap(
                                latitude, longitude);
                          },
                          initialZoom: 12,
                          initialCenter: LatLng(latitude, longitude),
                          interactionOptions: const InteractionOptions(
                            flags: ~InteractiveFlag.doubleTapDragZoom,
                          ),
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName:
                                'dev.fleaflet.flutter_map.example',
                          ),
                          MarkerLayer(markers: [
                            Marker(
                              point: LatLng(latitude, longitude),
                              width: 60,
                              height: 60,
                              alignment: Alignment.center,
                              child: const Icon(
                                Icons.location_on,
                                size: 37,
                                color: Colors.blue,
                              ),
                            )
                          ]),
                        ],
                      ),
                    ),
                  ),
                ),

              // User and Location Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDetailContainer(
                  title: 'User Information',
                  children: [
                    _buildDetailRow('Name:', userName ?? 'Loading...'),
                    _buildDetailRow(
                        'Location Name:', locationName ?? 'Loading...'),
                    _buildDetailRow('Date:', data['date'] ?? 'Not available'),
                  ],
                ),
              ),

              // Booking Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDetailContainer(
                  title: 'Booking Details',
                  children: [
                    _buildDetailRow('Time Slot:', data['timeSlot']),
                    _buildDetailRow('Description:', data['description']),
                    _buildDetailRow('Status:', data['status']),
                  ],
                ),
              ),

              // Accept and Reject Buttons
              if (data['status'] == 'pending')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildActionButtons(
                    leftButtonText: 'Accept',
                    leftButtonColor: Colors.green,
                    leftButtonIcon: Icons.check,
                    leftButtonOnPressed: () => bookingController
                        .updateBookingStatus(bookingId, 'accepted'),
                    rightButtonText: 'Reject',
                    rightButtonColor: Colors.red,
                    rightButtonIcon: Icons.cancel,
                    rightButtonOnPressed: () => bookingController
                        .updateBookingStatus(bookingId, 'rejected'),
                  ),
                ),

              // Start and Stop Buttons
              if (data['status'] == 'accepted' ||
                  data['status'] == 'in_progress')
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _buildActionButtons(
                    leftButtonText: 'Start',
                    leftButtonColor: Colors.blueAccent,
                    leftButtonIcon: Icons.play_arrow,
                    leftButtonOnPressed: data['startTime'] == null
                        ? () => bookingController.startBooking(bookingId)
                        : null,
                    rightButtonText: 'Stop',
                    rightButtonColor: Colors.orange,
                    rightButtonIcon: Icons.stop,
                    rightButtonOnPressed:
                        data['endTime'] == null && data['startTime'] != null
                            ? () => bookingController.stopBooking(bookingId)
                            : null,
                  ),
                ),

              // Payment Details
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: _buildDetailContainer(
                  title: 'Payment Information',
                  children: [
                    _buildDetailRow(
                      'Amount:',
                      data['amount'] != null
                          ? '₹${data['amount']}'
                          : 'Not calculated yet',
                    ),
                    _buildDetailRow('Paid:', data['paid'] ?? 'Not Paid'),
                  ],
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDetailContainer({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 5.0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 16.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          ...children,
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Text(
              value ?? 'N/A',
              style: const TextStyle(color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons({
    required String leftButtonText,
    required Color leftButtonColor,
    required IconData leftButtonIcon,
    required VoidCallback? leftButtonOnPressed,
    required String rightButtonText,
    required Color rightButtonColor,
    required IconData rightButtonIcon,
    required VoidCallback? rightButtonOnPressed,
  }) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: leftButtonOnPressed,
            icon: Icon(leftButtonIcon),
            label: Text(leftButtonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: leftButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: rightButtonOnPressed,
            icon: Icon(rightButtonIcon),
            label: Text(rightButtonText),
            style: ElevatedButton.styleFrom(
              backgroundColor: rightButtonColor,
              padding: const EdgeInsets.symmetric(vertical: 16.0),
            ),
          ),
        ),
      ],
    );
  }

  void checkLocationPermissionToViewMap(double lat, double lng) async {
    PermissionStatus locationStatus = await Permission.location.request();
    if (locationStatus.isGranted) {
      openGoogleMaps(lat, lng);
    } else if (locationStatus.isDenied) {
      // Handle permission denied scenario
    } else if (locationStatus.isPermanentlyDenied) {
      openAppSettings();
    }
  }

  void openGoogleMaps(double lat, double lng) async {
    final Uri url =
        Uri.parse('https://www.google.com/maps/search/?api=1&query=$lat,$lng');

    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        throw 'Could not launch $url';
      }
    } catch (e) {
      print('Failed to launch URL: $e');
    }
  }
}
