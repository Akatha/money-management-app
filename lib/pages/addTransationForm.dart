import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


import '../models/transationModel.dart';
import '../provider/transationProvider.dart';

class AddTransactionForm extends ConsumerStatefulWidget {
  final TransactionModel? transaction; // For edit

  const AddTransactionForm({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionForm> createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  String type = 'credit';

  @override
  void initState() {
    super.initState();
    if (widget.transaction != null) {
      type = widget.transaction!.type;
    }
  }

  Future<void> saveTransaction() async {
    if (_formKey.currentState!.saveAndValidate()) {
      final map = _formKey.currentState!.value;
      final userId = FirebaseAuth.instance.currentUser!.uid;

      final transaction = TransactionModel(
        id: widget.transaction?.id ?? '',
        title: map['title'],
        description: map['description'],
        amount: double.parse(map['amount'].toString()),
        type: type,
        date: DateTime.now(),
        userId: userId,
      );

      if (widget.transaction != null) {
        // Update
        await FirebaseFirestore.instance
            .collection('transactions')
            .doc(widget.transaction!.id)
            .update(transaction.toMap());
      } else {
        // Add new
        await FirebaseFirestore.instance
            .collection('transactions')
            .add(transaction.toMap());
      }

      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.transaction != null ? 'Edit Transaction' : 'Add Transaction'),
        backgroundColor: Colors.amber,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(labelText: 'Title'),
                initialValue: widget.transaction?.title,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(labelText: 'Description'),
                initialValue: widget.transaction?.description,
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 10),
              FormBuilderTextField(
                name: 'amount',
                decoration: const InputDecoration(labelText: 'Amount'),
                keyboardType: TextInputType.number,
                initialValue: widget.transaction?.amount.toString(),
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                ]),
              ),
              const SizedBox(height: 10),
              DropdownButtonFormField<String>(
                value: type,
                items: const [
                  DropdownMenuItem(value: 'credit', child: Text('Credit')),
                  DropdownMenuItem(value: 'debit', child: Text('Debit')),
                ],
                onChanged: (v) => setState(() => type = v!),
                decoration: const InputDecoration(labelText: 'Type'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveTransaction,
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
