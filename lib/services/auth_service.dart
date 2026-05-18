import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  User? get currentFirebaseUser => _auth.currentUser;

  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final user = UserModel(
        uid: credential.user!.uid,
        name: name,
        email: email,
        phone: phone,
        address: '',
      );
      await _db.collection('users').doc(user.uid).set(user.toMap());
      return user;
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Registration failed');
    }
  }

  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      final doc = await _db
          .collection('users')
          .doc(credential.user!.uid)
          .get();
      if (doc.exists) {
        return UserModel.fromMap(doc.data()!);
      }
      return UserModel(
        uid: credential.user!.uid,
        name: credential.user!.displayName ?? email.split('@')[0],
        email: email,
        phone: '',
        address: '',
      );
    } on FirebaseAuthException catch (e) {
      throw Exception(e.message ?? 'Login failed');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> updateProfile(UserModel user) async {
    await _db.collection('users').doc(user.uid).update(user.toMap());
  }

  Future<UserModel?> getCurrentUser() async {
    final firebaseUser = _auth.currentUser;
    if (firebaseUser == null) return null;
    try {
      final doc = await _db
          .collection('users')
          .doc(firebaseUser.uid)
          .get();
      if (doc.exists) return UserModel.fromMap(doc.data()!);
    } catch (_) {}
    return null;
  }
}
