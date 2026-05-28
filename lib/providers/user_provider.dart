import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/user_model.dart';

class UserProvider extends ChangeNotifier {
  firebase_auth.FirebaseAuth? _auth;
  StreamSubscription<firebase_auth.User?>? _authSubscription;
  UserModel? _user;
  bool _isLoading = false;

  UserProvider() {
    _bindFirebaseUser();
  }

  UserModel? get user => _user;
  bool get isLoggedIn => _user != null;
  bool get isLoading => _isLoading;

  Future<void> registerWithEmail({
    required String fullName,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final auth = _firebaseAuth;
      final credential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await credential.user?.updateDisplayName(fullName);
      await credential.user?.reload();
      if (auth.currentUser != null) {
        await _syncUserDocument(auth.currentUser!, fullName: fullName);
      }
      _setFirebaseUser(auth.currentUser);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    try {
      final auth = _firebaseAuth;
      await auth.signInWithEmailAndPassword(email: email, password: password);
      if (auth.currentUser != null) {
        await _syncUserDocument(auth.currentUser!);
      }
      _setFirebaseUser(auth.currentUser);
    } finally {
      _setLoading(false);
    }
  }

  Future<void> sendPasswordReset(String email) async {
    await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> logout() async {
    if (Firebase.apps.isNotEmpty) {
      await _firebaseAuth.signOut();
    }
    _user = null;
    notifyListeners();
  }

  void updateProfile(String fullName, String email) {
    if (_user != null) {
      _user = UserModel(id: _user!.id, fullName: fullName, email: email);
      unawaited(_saveUserModel(_user!));
      notifyListeners();
    }
  }

  firebase_auth.FirebaseAuth get _firebaseAuth {
    if (Firebase.apps.isEmpty) {
      throw firebase_auth.FirebaseAuthException(
        code: 'firebase-not-initialized',
        message: 'Firebase is not initialized for this platform.',
      );
    }

    final auth = _auth ?? firebase_auth.FirebaseAuth.instance;
    _auth ??= auth;
    return auth;
  }

  void _bindFirebaseUser() {
    if (Firebase.apps.isEmpty) return;

    final auth = _firebaseAuth;
    _setFirebaseUser(auth.currentUser, notify: false);
    _authSubscription = auth.authStateChanges().listen(_setFirebaseUser);
  }

  void _setFirebaseUser(
    firebase_auth.User? firebaseUser, {
    bool notify = true,
  }) {
    if (firebaseUser == null) {
      _user = null;
    } else {
      final name = firebaseUser.displayName?.trim();
      _user = UserModel(
        id: firebaseUser.uid,
        fullName: name == null || name.isEmpty ? 'Kali Fashion User' : name,
        email: firebaseUser.email ?? '',
      );
      unawaited(_syncUserDocument(firebaseUser, notify: notify));
    }

    if (notify) notifyListeners();
  }

  Future<void> _syncUserDocument(
    firebase_auth.User firebaseUser, {
    String? fullName,
    bool notify = true,
  }) async {
    if (Firebase.apps.isEmpty) return;

    final doc = FirebaseFirestore.instance
        .collection('users')
        .doc(firebaseUser.uid);
    final snapshot = await doc.get();
    final remoteData = snapshot.data();
    final remoteName = remoteData?['fullName'] as String?;
    final authName = firebaseUser.displayName?.trim();
    final resolvedName = fullName?.trim().isNotEmpty == true
        ? fullName!.trim()
        : authName != null && authName.isNotEmpty
        ? authName
        : remoteName?.trim().isNotEmpty == true
        ? remoteName!.trim()
        : 'Kali Fashion User';

    final user = UserModel(
      id: firebaseUser.uid,
      fullName: resolvedName,
      email: firebaseUser.email ?? remoteData?['email'] as String? ?? '',
    );

    final data = {
      ...user.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    };
    if (!snapshot.exists) {
      data['createdAt'] = FieldValue.serverTimestamp();
    }

    await doc.set(data, SetOptions(merge: true));
    _user = user;
    if (notify) notifyListeners();
  }

  Future<void> _saveUserModel(UserModel user) async {
    if (Firebase.apps.isEmpty) return;

    await FirebaseFirestore.instance.collection('users').doc(user.id).set({
      ...user.toFirestore(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void _setLoading(bool value) {
    if (_isLoading == value) return;
    _isLoading = value;
    notifyListeners();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
