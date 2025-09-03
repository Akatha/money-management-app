import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

final authBoxProvider = Provider<Box>((ref) {
  return Hive.box('authBox');
});

final isLoggedInProvider = Provider<bool>((ref) {
  final box = ref.watch(authBoxProvider);
  return box.get('isLoggedIn', defaultValue: false);
});
