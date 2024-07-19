import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scanner_main/main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../auth/auth_repository.dart';
import '../models/auth/user_detail/user_detail.dart';
// Adjust the import path as per your project structure

class FileRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final AuthRepository _authRepository; // Inject AuthRepository instance

  FileRepository({AuthRepository? authRepository})
      : _authRepository = authRepository ?? AuthRepository(); // Use injected or default AuthRepository instance

  Future<String> uploadFile(File file, String fileName) async {
    try {
      final userToken = await _authRepository.getUserTokenFromPref();
      if (userToken == null) {
        throw Exception('User token not found');
      }

      final storageRef = _storage.ref().child('uploads/$fileName');
      final metadata = SettableMetadata(
        customMetadata: {'userId': FirebaseAuth.instance.currentUser!.uid}, // Ensure userId is set in metadata
      );

      await storageRef.putFile(file, metadata);
      final downloadUrl = await storageRef.getDownloadURL();

      // Store file metadata in Firestore
      await _firestore.collection('files').add({
        'userId': FirebaseAuth.instance.currentUser!.uid,
        'fileName': fileName,
        'downloadUrl': downloadUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      return downloadUrl;
    } catch (e) {
      $logger.d('Error storing file metadata: $e');
      throw Exception('Error storing file metadata: $e');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPdfFiles() async {
    try {
      final List<Map<String, dynamic>> files = [];
      final userToken = await _authRepository.getUserTokenFromPref();
      if (userToken == null) {
        throw Exception('User token not found');
      }

      final userId = FirebaseAuth.instance.currentUser!.uid;
      final querySnapshot = await _firestore
          .collection('files')
          .where('userId', isEqualTo: userId)
          .get();

      for (var doc in querySnapshot.docs) {
        files.add(doc.data());
      }

      return files;
    } catch (e) {
      throw Exception('Error fetching files: $e');
    }
  }
}