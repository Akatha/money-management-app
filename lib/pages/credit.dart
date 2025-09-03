import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../provider/transationProvider.dart';

class Credit extends ConsumerWidget {
  final String filterType; // 'credit' or 'debit'
  const Credit({super.key, required this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final transactionsAsync = ref.watch(transactionsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: Text(filterType == 'credit' ? "Credits" : "Debits"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber.shade200,
      body: transactionsAsync.when(
        data: (transactions) {
          final filteredTx =
          transactions.where((t) => t.type == filterType).toList();
          if (filteredTx.isEmpty) {
            return Center(child: Text("No $filterType transactions"));
          }

          return ListView.separated(
            itemCount: filteredTx.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final tx = filteredTx[index];
              final formattedDate =
              DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);
              return ListTile(
                title: Text(tx.title),
                subtitle: Text("${tx.description}\n$formattedDate"),
                trailing: Text(
                  tx.type == "credit" ? "+ ${tx.amount}" : "- ${tx.amount}",
                  style: TextStyle(
                      color: tx.type == "credit" ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold),
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
