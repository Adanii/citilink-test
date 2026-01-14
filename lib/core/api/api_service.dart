import 'dart:convert';
import 'package:expenses_tracker/core/models/transaction_model.dart';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiService {
  final String _baseUrl = dotenv.env['BASE_URL']!;

  //   GET FUNCTION
  Future<List<TransactionModel>> fetchTransactions() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));

      if (response.statusCode == 200) {
        final List<dynamic> decoded = jsonDecode(response.body);

        final transactions =
            decoded.map((json) => TransactionModel.fromJson(json)).toList()
              ..sort((a, b) => b.date.compareTo(a.date));

        return transactions;
      } else {
        throw Exception('Failed to load transactions');
      }
    } catch (e, stackTrace) {
      debugPrint('ERROR: $e');
      debugPrint('STACKTRACE:\n$stackTrace');
      rethrow;
    }
  }

  // POST FUNCTION
  Future<TransactionModel> addTransaction(TransactionModel transaction) async {
    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(transaction.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return TransactionModel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to add transaction');
    }
  }

  // DELETE FUNCTION
  Future<void> deleteTransaction(String id) async {
    final response = await http.delete(Uri.parse('$_baseUrl/$id'));

    if (response.statusCode != 200) {
      throw Exception('Failed to delete transaction');
    }
  }
}
