import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> signUpUser({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        await _firestore.collection("servicers").doc(credential.user!.uid).set({
          'name': name,
          'email': email,
          'uid': credential.user!.uid,
        });
        res = 'success';
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String> sendPasswordResetEmail({required String email}) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty) {
        await _auth.sendPasswordResetEmail(email: email);
        res = "success";
      } else {
        res = "Please enter your email";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }
}
