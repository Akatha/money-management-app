import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/transationModel.dart';

// Transactions per user
final transactionsProvider = FutureProvider.family<List<TransactionModel>, String>((ref, userId) async {
  final snapshot = await FirebaseFirestore.instance
      .collection('transactions')
      .where('userId', isEqualTo: userId)
      .get();

  final transactions = snapshot.docs
      .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
      .toList();

  transactions.sort((a, b) => b.date.compareTo(a.date));
  return transactions;
});

// Balance per user
final balanceProvider = FutureProvider.family<double, String>((ref, userId) async {
  final transactions = await ref.watch(transactionsProvider(userId).future);
  double balance = 0;
  for (var t in transactions) {
    balance += t.type == 'credit' ? t.amount : -t.amount;
  }
  return balance;
});
