import 'package:expenses_tracker/core/api/api_service.dart';
import 'package:expenses_tracker/core/models/transaction_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';

//Provider ApiService (Dependency Injection)
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

//Provider Get Transaction
final transactionListProvider = FutureProvider<List<TransactionModel>>((ref) {
  final apiService = ref.read(apiServiceProvider);
  return apiService.fetchTransactions();
});

// StateNotifier POST Transaction
class TransactionNotifier extends StateNotifier<AsyncValue<void>> {
  final ApiService apiService;

  TransactionNotifier(this.apiService) : super(const AsyncValue.data(null));

  Future<void> addTransaction(TransactionModel transaction) async {
    state = const AsyncValue.loading();

    try {
      await apiService.addTransaction(transaction);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }

  Future<void> deleteTransaction(String id) async {
    state = const AsyncValue.loading();

    try {
      await apiService.deleteTransaction(id);

      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, AsyncValue<void>>((ref) {
      final apiService = ref.read(apiServiceProvider);
      return TransactionNotifier(apiService);
    });
