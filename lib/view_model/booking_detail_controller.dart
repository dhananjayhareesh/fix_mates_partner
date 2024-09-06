import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingDetailController extends GetxController {
  Rx<DocumentSnapshot?> booking = Rx<DocumentSnapshot?>(null);
  Rx<String?> userName = Rx<String?>(null);
  Rx<Map<String, dynamic>?> location = Rx<Map<String, dynamic>?>(null);
  Rx<String?> locationName = Rx<String?>(null);
  RxList<Map<String, dynamic>> bookings = RxList([]);
  RxBool isLoading = false.obs;

  RxInt pendingCount = 0.obs;
  RxInt acceptedCount = 0.obs;
  RxInt completedCount = 0.obs;

  RxInt totalEarnings = 0.obs;
  RxInt pendingPayments = 0.obs;

  @override
  void onInit() {
    fetchBookings(); // Fetch bookings when the controller is initialized
    super.onInit();
  }

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

  void fetchBookings() async {
    isLoading.value = true;
    final bookingQuery =
        await FirebaseFirestore.instance.collection('Bookings').get();

    bookings.value = bookingQuery.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    pendingCount.value =
        bookings.where((booking) => booking['status'] == 'pending').length;
    acceptedCount.value =
        bookings.where((booking) => booking['status'] == 'accepted').length;
    completedCount.value =
        bookings.where((booking) => booking['status'] == 'completed').length;

    totalEarnings.value = bookings
        .where((booking) =>
            booking['status'] == 'completed' &&
            booking['payment_status'] == 'paid')
        .fold(0, (sum, booking) => sum + (booking['price'] as num).toInt());

    pendingPayments.value = bookings
        .where((booking) =>
            booking['status'] == 'completed' &&
            booking['payment_status'] == 'not_paid')
        .fold(0, (sum, booking) => sum + (booking['price'] as num).toInt());

    isLoading.value = false;
  }
}
