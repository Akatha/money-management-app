import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';

// Firebase auth state stream
final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();
});

// Hive box provider (so you can use it anywhere)
final authBoxProvider = Provider<Box>((ref) {
  return Hive.box('authBox');
});

// StateNotifier to manage login persistence
class AuthController extends StateNotifier<User?> {
  final Box authBox;

  AuthController(this.authBox) : super(null) {
    final uid = authBox.get('uid');
    if (uid != null) {
      state = FirebaseAuth.instance.currentUser;
    }
  }

  Future<void> login(User user) async {
    await authBox.put('uid', user.uid);
    state = user;
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
    await authBox.clear();
    state = null;
  }
}

final authControllerProvider =
StateNotifierProvider<AuthController, User?>((ref) {
  final box = ref.watch(authBoxProvider);
  return AuthController(box);
});
