import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import '../models/transationModel.dart';
import '../provider/transationProvider.dart';

class AddTransactionForm extends ConsumerStatefulWidget {
  final TransactionModel? transaction; // null = Add, not null = Edit

  const AddTransactionForm({super.key, this.transaction});

  @override
  ConsumerState<AddTransactionForm> createState() =>
      _AddTransactionFormState();
}

class _AddTransactionFormState extends ConsumerState<AddTransactionForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  @override
  void initState() {
    super.initState();

    // Prefill the form if editing
    if (widget.transaction != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _formKey.currentState?.patchValue({
          'title': widget.transaction!.title,
          'description': widget.transaction!.description,
          'amount': widget.transaction!.amount.toString(),
          'type': widget.transaction!.type,
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
        Text(widget.transaction == null ? "Add Transaction" : "Edit Transaction"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: FormBuilder(
          key: _formKey,
          child: Column(
            children: [
              FormBuilderTextField(
                name: 'title',
                decoration: const InputDecoration(labelText: "Title"),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'description',
                decoration: const InputDecoration(labelText: "Description"),
                validator: FormBuilderValidators.required(),
              ),
              FormBuilderTextField(
                name: 'amount',
                decoration: const InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
                validator: FormBuilderValidators.compose([
                  FormBuilderValidators.required(),
                  FormBuilderValidators.numeric(),
                  FormBuilderValidators.min(0.01),
                ]),
              ),
              FormBuilderDropdown(
                name: 'type',
                decoration:
                const InputDecoration(labelText: "Transaction Type"),
                items: ['credit', 'debit']
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                validator: FormBuilderValidators.required(),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.saveAndValidate()) {
                    final form = _formKey.currentState!.value;

                    final transaction = TransactionModel(
                      id: widget.transaction?.id ?? '',
                      title: form['title'],
                      description: form['description'],
                      amount: double.parse(form['amount']),
                      type: form['type'],
                      date: DateTime.now(),
                    );

                    final controller =
                    ref.read(transactionControllerProvider.notifier);

                    if (widget.transaction == null) {
                      // Add new transaction
                      await controller.addTransaction(transaction);
                    } else {
                      // Update existing transaction
                      await controller.updateTransaction(transaction);
                    }

                    if (context.mounted) Navigator.pop(context);
                  }
                },
                child:
                Text(widget.transaction == null ? "Save" : "Update"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
