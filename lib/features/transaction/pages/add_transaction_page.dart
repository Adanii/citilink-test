import 'package:expenses_tracker/core/models/transaction_model.dart';
import 'package:expenses_tracker/features/transaction/providers/transaction_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AddTransactionPage extends ConsumerStatefulWidget {
  const AddTransactionPage({super.key});

  @override
  ConsumerState<AddTransactionPage> createState() => _AddTransactionPageState();
}

class _AddTransactionPageState extends ConsumerState<AddTransactionPage> {
  final formKey = GlobalKey<FormState>();
  late final ProviderSubscription<AsyncValue<void>> _listener;
  String type = 'expense';
  String amount = '';
  String category = '';
  final TextEditingController amountController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _listener = ref.listenManual<AsyncValue<void>>(
      transactionNotifierProvider,
      (previous, next) {
        next.whenOrNull(
          data: (_) {
            ref.invalidate(transactionListProvider);

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Transaction added successfully')),
            );

            Navigator.pop(context);
          },
          error: (e, _) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(e.toString())));
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _listener.close();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final submitState = ref.watch(transactionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Add Transaction",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: AnimatedPadding(
        padding: const EdgeInsets.all(16),
        duration: const Duration(milliseconds: 300),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                initialValue: type,
                items: const [
                  DropdownMenuItem(value: 'expense', child: Text('Expense')),
                  DropdownMenuItem(value: 'Income', child: Text('Income')),
                ],
                onChanged: (value) => setState(() => type = value!),
                decoration: const InputDecoration(
                  labelText: 'Type',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                  border: OutlineInputBorder(),
                  prefixText: 'Rp ',
                ),
                keyboardType: TextInputType.number,
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter amount' : null,
                onSaved: (value) =>
                    amount = value!.replaceAll(RegExp(r'[^0-9]'), ''),
                onChanged: (value) {
                  final cleanedValue = value.replaceAll(RegExp(r'[^0-9]'), '');
                  if (cleanedValue.isEmpty) {
                    amountController.text = '';
                    amountController.selection = TextSelection.fromPosition(
                      TextPosition(offset: amountController.text.length),
                    );
                    return;
                  }
                  final numericValue = int.tryParse(cleanedValue) ?? 0;
                  final formattedValue = numericValue
                      .toString()
                      .replaceAllMapped(
                        RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
                        (Match m) => '${m[1]}.',
                      );
                  amountController.text = formattedValue;
                  amountController.selection = TextSelection.fromPosition(
                    TextPosition(offset: formattedValue.length),
                  );
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter category' : null,
                onSaved: (value) => category = value!,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: submitState.isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                        ),
                        child: const Text(
                          'Save',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submit() {
    if (!formKey.currentState!.validate()) return;

    formKey.currentState!.save();

    final transaction = TransactionModel(
      id: '',
      type: type,
      amount: amount,
      category: category,
      date: DateTime.now().toIso8601String().split('T').first,
    );

    ref.read(transactionNotifierProvider.notifier).addTransaction(transaction);
  }
}
