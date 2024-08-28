import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BookingController extends GetxController {
  var bookings = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  late String workerDocId;

  @override
  void onInit() {
    super.onInit();
    fetchBookings();
  }

  Future<void> fetchBookings() async {
    isLoading(true);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    workerDocId = prefs.getString('workerDocId') ?? '';

    if (workerDocId.isNotEmpty) {
      FirebaseFirestore.instance
          .collection('Bookings')
          .where('workerId', isEqualTo: workerDocId)
          .snapshots()
          .listen((snapshot) async {
        List<Map<String, dynamic>> fetchedBookings = [];

        for (var doc in snapshot.docs) {
          var data = doc.data();
          data['bookingId'] = doc.id;

          // Fetch the userName based on userId
          var userId = data['userId'];
          var userDoc = await FirebaseFirestore.instance
              .collection('usersDetails')
              .doc(userId)
              .get();

          data['userName'] = userDoc.data()?['userName'] ?? 'Unknown User';
          fetchedBookings.add(data);
        }

        bookings.value = fetchedBookings;
        isLoading(false);
      });
    } else {
      isLoading(false);
    }
  }
}
