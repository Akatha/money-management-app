import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transationModel.dart';

// -------------------- CONTROLLER --------------------
class TransactionController extends StateNotifier<List<TransactionModel>> {
  TransactionController() : super([]);

  final _firestore = FirebaseFirestore.instance;

  // Add transaction
  Future<void> addTransaction(TransactionModel transaction) async {
    final docRef = await _firestore.collection('transactions').add(transaction.toMap());
    state = [
      TransactionModel(
        id: docRef.id,
        title: transaction.title,
        description: transaction.description,
        amount: transaction.amount,
        type: transaction.type,
        date: transaction.date,
      ),
      ...state
    ];
  }

  // Update transaction
  Future<void> updateTransaction(TransactionModel transaction) async {
    if (transaction.id.isEmpty) return;
    await _firestore
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toMap());

    state = [
      for (final t in state)
        if (t.id == transaction.id) transaction else t
    ];
  }

  // Delete transaction
  Future<void> deleteTransaction(String id) async {
    await _firestore.collection('transactions').doc(id).delete();
    state = state.where((t) => t.id != id).toList();
  }

  // Load transactions from Firestore
  Future<void> loadTransactions() async {
    final snapshot = await _firestore.collection('transactions').get();
    state = snapshot.docs
        .map((doc) => TransactionModel.fromMap(doc.data(), doc.id))
        .toList();
  }
}

// -------------------- PROVIDERS --------------------

// Controller provider
final transactionControllerProvider =
StateNotifierProvider<TransactionController, List<TransactionModel>>(
        (ref) {
      final controller = TransactionController();
      controller.loadTransactions();
      return controller;
    });

// Transactions provider (AsyncValue)
final transactionsProvider = FutureProvider<List<TransactionModel>>((ref) async {
  final controller = ref.watch(transactionControllerProvider.notifier);
  await controller.loadTransactions();
  return ref.watch(transactionControllerProvider);
});

// Balance provider
final balanceProvider = FutureProvider<double>((ref) async {
  final transactions = await ref.watch(transactionsProvider.future);
  double balance = 0;
  for (var t in transactions) {
    if (t.type == 'credit') {
      balance += t.amount;
    } else {
      balance -= t.amount;
    }
  }
  return balance;
});
