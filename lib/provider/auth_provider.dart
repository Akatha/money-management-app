import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:hive/hive.dart';

// Stream of the current user


// final box = Hive.box('authBox');
// final isLoggedIn = box.get('isLoggedIn', defaultValue: false);
//
// if (isLoggedIn) {
// // Automatically navigate to Home
// context.pushNamed(AppRoute.home.name);
// } else {
// // Show login page
// context.pushNamed(AppRoute.login.name);
// }
final firebaseAuthStateProvider = StreamProvider<User?>((ref) {
  return FirebaseAuth.instance.authStateChanges();


});
