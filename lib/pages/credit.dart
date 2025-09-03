import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';


import '../provider/transationProvider.dart';



class Credit extends ConsumerWidget {
  final String filterType;

  const Credit({super.key, required this.filterType});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(title: Center(child: const Text("Credits")),
      backgroundColor: Colors.amber,),
      backgroundColor: Colors.amber.shade200,
      body: transactionsAsync.when(
        data: (transactions) {
          final credits =
          transactions.where((t) => t.type == filterType).toList();

          if (credits.isEmpty) {
            return const Center(child: Text("No credit transactions"));
          }

          credits.sort((a, b) => b.date.compareTo(a.date));

          return ListView.builder(
            itemCount: credits.length,
            itemBuilder: (context, index) {
              final tx = credits[index];
              final formattedDate =
              DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);

              return Card(
                color: Colors.amber.shade50,
                child: ListTile(
                  title: Text(tx.title),
                  subtitle: Text("${tx.description}\n$formattedDate"),
                  trailing: Text(
                    "+ ${tx.amount}",
                    style: const TextStyle(
                        color: Colors.green, fontWeight: FontWeight.bold),
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
