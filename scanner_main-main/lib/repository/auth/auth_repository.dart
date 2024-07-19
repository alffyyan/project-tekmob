import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/auth/user_detail/user_detail.dart';

class AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepository({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
      if (!userCredential.user!.emailVerified) {
        throw Exception('email-not-verified');
      }
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        throw Exception('user-not-found');
      } else if (e.code == 'wrong-password') {
        throw Exception('wrong-password');
      } else {
        throw Exception(e.message ?? 'Error signing in with email and password');
      }
    }
  }

  Future<User?> registerWithEmailAndPassword(String email, String password, String fullName, String phoneNumber, String gender, DateTime birthDate) async {
    try {
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      if (user != null) {
        await user.sendEmailVerification();
        await _firestore.collection('users').doc(user.uid).set({
          'fullName': fullName,
          'email': email,
          'phoneNumber': phoneNumber,
          'gender': gender,
          'birthDate': birthDate.toIso8601String(),
        });

        await saveUserTokenToPref(user);
      }
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception('Error registering with email and password: ${e.message}');
    }
  }

  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      await clearTokenFromPref();
    } catch (e) {
      throw Exception('Error signing out: $e');
    }
  }

  Future<void> saveUserTokenToPref(User? user) async {
    if (user != null) {
      String? token = await user.getIdToken();
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('userToken', token!);
    }
  }

  Future<void> clearTokenFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken');
  }

  Future<String?> getUserTokenFromPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('userToken');
  }

  Future<UserDetail> getUserDetail(String token) async {
    final User? user = _firebaseAuth.currentUser;
    if (user != null) {
      final DocumentSnapshot doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists) {
        return UserDetail.fromJson(doc.data() as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } else {
      throw Exception('No authenticated user found');
    }
  }
}
