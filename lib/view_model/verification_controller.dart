import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_mates_servicer/view/home_screen.dart';

class VerificationController extends GetxController {
  final String userEmail;

  VerificationController(this.userEmail);

  @override
  void onInit() {
    super.onInit();
    _checkVerificationStatus();
  }

  void _checkVerificationStatus() {
    FirebaseFirestore.instance
        .collection('workers')
        .where('userEmail', isEqualTo: userEmail)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.docs.isNotEmpty) {
        var userDoc = snapshot.docs.first;
        if (userDoc['status'] == 'approved') {
          Get.offAll(
              () => HomeScreen()); // Navigate to HomeScreen upon approval
        }
      }
    });
  }
}
