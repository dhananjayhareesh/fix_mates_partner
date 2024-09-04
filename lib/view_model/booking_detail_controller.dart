import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingDetailController extends GetxController {
  Rx<DocumentSnapshot?> booking = Rx<DocumentSnapshot?>(null);
  Rx<String?> userName = Rx<String?>(null);
  Rx<Map<String, dynamic>?> location = Rx<Map<String, dynamic>?>(null);
  Rx<String?> locationName = Rx<String?>(null);

  void fetchBooking(String bookingId) async {
    booking.value = await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .get();

    if (booking.value != null) {
      final userId = booking.value!.get('userId');
      fetchUserNameAndLocation(userId);
    }
  }

  Future<void> fetchUserNameAndLocation(String userId) async {
    final userDoc = await FirebaseFirestore.instance
        .collection('usersDetails')
        .doc(userId)
        .get();

    userName.value = userDoc.data()?['userName'] ?? 'Unknown User';
    location.value = userDoc.data()?['location'] as Map<String, dynamic>?;
    locationName.value = userDoc.data()?['locationName'] ?? 'Unknown Location';
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
    DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .get();

    Timestamp startTime = bookingSnapshot['startTime'];
    Timestamp endTime = Timestamp.now();

    int amount = calculateAmount(startTime, endTime);

    await FirebaseFirestore.instance
        .collection('Bookings')
        .doc(bookingId)
        .update({
      'endTime': endTime,
      'status': 'completed',
      'amount': amount,
      'paid': 'not_paid',
    });

    fetchBooking(bookingId);
  }

  int calculateAmount(Timestamp startTime, Timestamp endTime) {
    final duration = endTime.toDate().difference(startTime.toDate()).inHours;
    if (duration <= 1) {
      return 390;
    } else {
      return 390 + (duration - 1) * 100;
    }
  }
}
