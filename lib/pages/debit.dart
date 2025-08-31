import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/transationProvider.dart';
import 'package:intl/intl.dart';

class Debit extends ConsumerWidget {
  final String filterType;

  const Debit({super.key, required this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Debits")),
      body: transactionsAsync.when(
        data: (transactions) {
          // Filter only debit transactions
          final debits =
          transactions.where((t) => t.type == filterType).toList();

          if (debits.isEmpty) {
            return const Center(child: Text("No debit transactions"));
          }

          // Sort by latest first
          debits.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            itemCount: debits.length,
            itemBuilder: (context, index) {
              final tx = debits[index];
              final formattedDate =
              DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);

              return ListTile(
                title: Text(tx.title),
                subtitle: Text("${tx.description}\n$formattedDate"),
                trailing: Text(
                  "- ${tx.amount}",
                  style: const TextStyle(
                      color: Colors.red, fontWeight: FontWeight.bold),
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
