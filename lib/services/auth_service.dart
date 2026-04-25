// ============================================================
//  auth_service.dart  —  Firebase Authentication Service
//  Phase 2: Uncomment Firebase code and remove mock code
// ============================================================

// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';

class AuthService {
  // ── Firebase instances (Phase 2) ────────────────────────
  // final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _db = FirebaseFirestore.instance;
  // ────────────────────────────────────────────────────────

  // ── SIGN UP ─────────────────────────────────────────────
  Future<UserModel?> signUp({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    // ── Phase 2 (Firebase) ───────────────────────────────
    // try {
    //   final credential = await _auth.createUserWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   final user = UserModel(
    //     uid: credential.user!.uid,
    //     name: name,
    //     email: email,
    //     phone: phone,
    //     address: '',
    //   );
    //   // Save user profile to Firestore
    //   await _db.collection('users').doc(user.uid).set(user.toMap());
    //   return user;
    // } on FirebaseAuthException catch (e) {
    //   throw Exception(e.message ?? 'Registration failed');
    // }
    // ────────────────────────────────────────────────────

    // ── Phase 1 (Mock) ───────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 1200));
    return UserModel(
      uid: 'uid_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      address: '',
    );
    // ────────────────────────────────────────────────────
  }

  // ── SIGN IN ─────────────────────────────────────────────
  Future<UserModel?> signIn({
    required String email,
    required String password,
  }) async {
    // ── Phase 2 (Firebase) ───────────────────────────────
    // try {
    //   final credential = await _auth.signInWithEmailAndPassword(
    //     email: email,
    //     password: password,
    //   );
    //   // Fetch user profile from Firestore
    //   final doc = await _db
    //       .collection('users')
    //       .doc(credential.user!.uid)
    //       .get();
    //   if (doc.exists) {
    //     return UserModel.fromMap(doc.data()!);
    //   }
    //   return UserModel(
    //     uid: credential.user!.uid,
    //     name: credential.user!.displayName ?? email.split('@')[0],
    //     email: email,
    //     phone: '',
    //     address: '',
    //   );
    // } on FirebaseAuthException catch (e) {
    //   throw Exception(e.message ?? 'Login failed');
    // }
    // ────────────────────────────────────────────────────

    // ── Phase 1 (Mock) ───────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 1200));
    final name = email.split('@')[0];
    return UserModel(
      uid: 'uid_mock_001',
      name: name[0].toUpperCase() + name.substring(1),
      email: email,
      phone: '+94 77 123 4567',
      address: '123 Fashion Street, Colombo 03',
    );
    // ────────────────────────────────────────────────────
  }

  // ── SIGN OUT ────────────────────────────────────────────
  Future<void> signOut() async {
    // Phase 2: await _auth.signOut();
    await Future.delayed(const Duration(milliseconds: 300));
  }

  // ── UPDATE PROFILE ──────────────────────────────────────
  Future<void> updateProfile(UserModel user) async {
    // ── Phase 2 (Firebase) ───────────────────────────────
    // await _db.collection('users').doc(user.uid).update(user.toMap());
    // ────────────────────────────────────────────────────
    await Future.delayed(const Duration(milliseconds: 500));
  }

  // ── GET CURRENT USER ────────────────────────────────────
  // Phase 2: Stream<User?> get authStateChanges => _auth.authStateChanges();
}
