import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:hive/hive.dart';
import 'package:go_router/go_router.dart';
import 'package:money_management_app/pages/addTransationForm.dart';

import '../provider/transationProvider.dart' as txProvider;

import '../provider/transationProvider.dart' as addForm;
import '../routes/route_enum.dart';
import 'addTransationForm.dart';
import 'credit.dart';
import 'debit.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  String username = '';
  String email = '';

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final doc = await FirebaseFirestore.instance.collection('users').doc(userId).get();

    if (doc.exists) {
      setState(() {
        username = doc.data()?['username'] ?? 'User';
        email = doc.data()?['email'] ?? '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final balanceAsync = ref.watch(addForm.balanceProvider(userId));
    final transactionsAsync = ref.watch(addForm.transactionsProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.amber,
      ),
      backgroundColor: Colors.amber.shade200,
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: const BoxDecoration(color: Colors.blue),
              accountName: Text(username),
              accountEmail: Text(email),
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Text(
                  username.isNotEmpty ? username[0].toUpperCase() : 'U',
                  style: const TextStyle(fontSize: 24, color: Colors.blue),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text("Sign Out"),
              onTap: () async {
                await FirebaseAuth.instance.signOut();
                final box = Hive.box('authBox');
                await box.clear();
                if (context.mounted) {
                  context.goNamed(AppRoute.login.name);
                }
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Available Balance
            balanceAsync.when(
              data: (balance) => Text(
                "Available Balance: RS${balance.toStringAsFixed(2)}",
                style: const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text("Error: $e"),
            ),
            const SizedBox(height: 20),
            const Text(
              "Transaction History",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            // Transactions List
            Expanded(
              child: transactionsAsync.when(
                data: (transactions) {
                  if (transactions.isEmpty) {
                    return const Center(child: Text("No transactions yet"));
                  }

                  return ListView.separated(
                    itemCount: transactions.length,
                    separatorBuilder: (_, __) => const Divider(),
                    itemBuilder: (context, index) {
                      final tx = transactions[index];
                      final formattedDate = DateFormat('dd MMM yyyy, hh:mm a').format(tx.date);

                      return Dismissible(
                        key: Key(tx.id),
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
                            final confirm = await showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                title: const Text("Delete Transaction?"),
                                content: const Text(
                                    "Are you sure you want to delete this transaction?"),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, false),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, true),
                                    child: const Text("Delete"),
                                  ),
                                ],
                              ),
                            );
                            if (confirm == true) {
                              await FirebaseFirestore.instance
                                  .collection('transactions')
                                  .doc(tx.id)
                                  .delete();
                              ref.refresh(addForm.transactionsProvider(userId));
                            }
                            return confirm;
                          } else if (direction == DismissDirection.endToStart) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => AddTransactionForm(transaction: tx),
                              ),
                            ).then((_) => ref.refresh(addForm.transactionsProvider(userId)));
                            return false;
                          }
                          return false;
                        },
                        child: ListTile(
                          leading: Icon(
                            tx.type == "credit" ? Icons.arrow_upward : Icons.arrow_downward,
                            color: tx.type == "credit" ? Colors.green : Colors.red,
                          ),
                          title: Text(tx.title),
                          subtitle: Text("${tx.description}\n$formattedDate"),
                          trailing: Text(
                            tx.type == "credit" ? "+ ${tx.amount}" : "- ${tx.amount}",
                            style: TextStyle(
                              color: tx.type == "credit" ? Colors.green : Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(child: Text("Error: $e")),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "Add"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_upward), label: "Credits"),
          BottomNavigationBarItem(icon: Icon(Icons.arrow_downward), label: "Debits"),
        ],
        onTap: (index) {
          if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const AddTransactionForm()),
            ).then((_) => ref.refresh(addForm.transactionsProvider(userId)));
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Credit(filterType: 'credit')),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Credit(filterType: 'debit')),
            );
          }
        },
      ),
    );
  }
}
