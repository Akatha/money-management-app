import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/transationProvider.dart';

class Debit extends ConsumerWidget {
  final String filterType;

  const Debit({super.key, required this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid; // get current user
    final transactionsAsync = ref.watch(transactionsProvider(userId)); // pass userId here

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text("Debits")),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber.shade200,
      body: transactionsAsync.when(
        data: (transactions) {
          // Filter only by transaction type
          final debits = transactions.where((t) => t.type == filterType).toList();

          if (debits.isEmpty) {
            return const Center(child: Text("No debit transactions"));
          }

          debits.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            itemCount: debits.length,
            itemBuilder: (context, index) {
              final tx = debits[index];
              final formattedDate =
              DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);

              return Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  title: Text(tx.title),
                  subtitle: Text("${tx.description}\n$formattedDate"),
                  trailing: Text(
                    "- ${tx.amount}",
                    style: const TextStyle(
                        color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
      ),
    );
  }
}
