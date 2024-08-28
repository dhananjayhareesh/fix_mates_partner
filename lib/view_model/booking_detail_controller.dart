import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingDetailController extends GetxController {
  Rx<DocumentSnapshot?> booking = Rx<DocumentSnapshot?>(null);

  void fetchBooking(String bookingId) async {
    booking.value = await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .get();
  }

  Future<void> updateBookingStatus(String bookingId, String status) async {
    await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .update({'status': status});
    fetchBooking(bookingId);
  }

  Future<void> startBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .update({
      'startTime': FieldValue.serverTimestamp(),
      'status': 'in_progress',
    });
    fetchBooking(bookingId);
  }

  Future<void> stopBooking(String bookingId) async {
    await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .update({
      'endTime': FieldValue.serverTimestamp(),
      'status': 'completed',
    });
    fetchBooking(bookingId);
  }
}
