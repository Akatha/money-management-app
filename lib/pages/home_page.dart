import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../provider/auth_provider.dart';
import '../provider/transationProvider.dart';
import 'addTransationForm.dart';
import 'credit.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final balanceAsync = ref.watch(balanceProvider);
    final transactionsAsync = ref.watch(transactionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Expense Tracker")),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber.shade200,

      // Drawer with SignOut
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(color: Colors.blue),
              child: Text(
                "Menu",
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                final box = Hive.box('authBox');
                await box.clear();
                await ref.read(authControllerProvider.notifier).logout();
                if (context.mounted) {
                  context.goNamed('login');
                }
              },
            ),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance
            balanceAsync.when(

              data: (balance) => Text(

                "Available Balance: RS${balance.toStringAsFixed(2)}",
                style: const TextStyle(
                    fontSize: 22, fontWeight: FontWeight.bold, ),
              ),
              loading: () => Center(child: const CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),
            const SizedBox(height: 20),

            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            // Transaction list
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text("No transactions yet"));
                  }

                  transactions.sort((a, b) => b.date.compareTo(a.date));

                  return ListView.builder(

                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final formattedDate =
                      DateFormat('dd MMM yyyy, hh:mm a')
                          .format(transaction.date);

                      return Dismissible(
                        key: Key(transaction.id),
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.only(left: 16),
                          child: const Icon(Icons.delete, color: Colors.white),
                        ),
                        secondaryBackground: Container(
                          color: Colors.blue,
                          alignment: Alignment.centerRight,
                          padding: const EdgeInsets.only(right: 16),
                          child: const Icon(Icons.edit, color: Colors.white),
                        ),
                        confirmDismiss: (direction) async {
                          if (direction == DismissDirection.startToEnd) {
                            // Delete
                            final confirm = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Transaction?"),
                                content: const Text(
                                    "Are you sure you want to delete this transaction?"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Cancel")),
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text("Delete")),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('transactions')
                                  .doc(transaction.id)
                                  .delete();
                              ref.refresh(transactionsProvider);
                            }
                            return confirm;
                          } else if (direction == DismissDirection.endToStart) {
                            // Edit
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionForm(
                                  transaction: transaction,
                                ),
                              ),
                            ).then(
                                    (_) => ref.refresh(transactionsProvider));
                            return false;
                          }
                          return false;
                        },
                        child: Card(
                          color: Colors.amber.shade50,
                          child: ListTile(
                            leading: Icon(
                              transaction.type == "credit"
                                  ? Icons.arrow_upward
                                  : Icons.arrow_downward,
                              color: transaction.type == "credit"
                                  ? Colors.green
                                  : Colors.red,
                            ),
                            title: Text(transaction.title),
                            subtitle: Text(
                              "${transaction.description}\n$formattedDate",
                            ),
                            isThreeLine: true,
                            trailing: Text(
                              transaction.type == "credit"
                                  ? "+ ${transaction.amount}"
                                  : "- ${transaction.amount}",
                              style: TextStyle(
                                color: transaction.type == "credit"
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () =>
                const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: "Add",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_upward, color: Colors.green),
            label: "Credits",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.arrow_downward, color: Colors.red),
            label: "Debits",
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionForm()),
            ).then((_) => ref.refresh(transactionsProvider));
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Credit(filterType: 'credit'),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const Credit(filterType: 'debit'), // or create Debit page
              ),
            );
          }
        },
      ),

    );
  }
}
