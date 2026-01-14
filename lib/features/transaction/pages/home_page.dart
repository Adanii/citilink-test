import 'package:expenses_tracker/core/models/transaction_model.dart';
import 'package:expenses_tracker/features/transaction/pages/add_transaction_page.dart';
import 'package:expenses_tracker/utils/widgets/balance_container.dart';
import 'package:expenses_tracker/utils/widgets/transaction_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/transaction_provider.dart';

class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Expense Tracker',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: transactionAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(
          child: Text(
            error.toString(),
            style: const TextStyle(color: Colors.red),
          ),
        ),
        data: (transactions) {
          if (transactions.isEmpty) {
            return Column(
              children: [
                BalanceContainer(balance: 'Rp 0'),
                const Expanded(
                  child: Center(
                    child: Text(
                      'No transactions yet',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ),
                ),
              ],
            );
          }

          final balance = calculateBalance(transactions);

          return Column(
            children: [
              BalanceContainer(balance: balance),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = transactions[index];
                    return TransactionItem(transaction: transaction);
                  },
                ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'addTransaction',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddTransactionPage()),
              );
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ],
      ),
    );
  }
}

String formatCurrency(String amount) {
  final numericAmount = double.tryParse(amount) ?? 0;
  return 'Rp ${numericAmount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}';
}

String calculateBalance(List<TransactionModel> transactions) {
  double total = 0;
  for (final transaction in transactions) {
    final amount = double.tryParse(transaction.amount) ?? 0;
    if (transaction.type == 'expense') {
      total -= amount;
    } else {
      total += amount;
    }
  }
  return formatCurrency(total.abs().toString());
}
