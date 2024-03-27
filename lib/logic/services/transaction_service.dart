import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;
import 'package:my_project/logic/models/transaction.dart';
import 'package:my_project/logic/services/transaction_local_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

typedef BalanceUpdateCallback = void Function();

abstract class AbstractTransactionService {
  Future<List<Transaction>> loadTransactionList();

  Future<void> saveTransactionList(List<Transaction> dataList);

  Future<void> addTransaction(Transaction data);

  Future<void> deleteTransaction(int index);
}

class TransactionService implements AbstractTransactionService {
  static const _transactionDataKey = 'transactionData';
  static const currentBalanceKey = 'currentBalance';
  static const String baseUrl = 'http://10.0.2.2:8080/api/transaction';
  TransactionLocalStorage transactionLocalStorage= TransactionLocalStorage();
  TransactionService() {
    _initializeBalance();
  }

  BalanceUpdateCallback? onBalanceUpdated;


  Future<void> updateBalance(double amount) async {
    final prefs = await SharedPreferences.getInstance();
    double currentBalance = prefs.getDouble('currentBalance') ?? 5000.00;
    currentBalance -= amount;
    await prefs.setDouble('currentBalance', currentBalance);
    onBalanceUpdated?.call();
  }


  Future<void> _initializeBalance() async {
    final prefs = await SharedPreferences.getInstance();
    if (prefs.getDouble(currentBalanceKey) == null) {
      await prefs.setDouble(currentBalanceKey, 5000);
    }
  }

  @override
  Future<List<Transaction>> loadTransactionList() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      return transactionLocalStorage.findAll();
    } else {
      final response = await http.get(Uri.parse(baseUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> decodedResponse =
        jsonDecode(response.body) as Map<String, dynamic>;

        if (decodedResponse['_embedded'] != null &&
            decodedResponse['_embedded']['transactions'] != null) {
          final List<dynamic> transactions =
          decodedResponse['_embedded']['transactions'] as List<dynamic>;
          final List<Transaction> transactionDataList = transactions
              .map((dynamic item) =>
              Transaction.fromJson(item as Map<String, dynamic>),)
              .toList();

          await transactionLocalStorage.deleteAll();
          for (var data in transactionDataList) {
            await transactionLocalStorage.post(data);
          }

          return transactionDataList;
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to load transaction data from API');
      }
    }
  }

  @override
  Future<void> addTransaction(Transaction data) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Cannot add data.');
    } else {
      final response = await http.post(
        Uri.parse('$baseUrl/post'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(data.toJson()),
      );

      if (response.statusCode == 200) {
        await transactionLocalStorage.post(data);
      } else {
        throw Exception('Failed to add transaction data to API');
      }
    }
  }

  @override
  Future<void> deleteTransaction(int transactionId) async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      throw Exception('No internet connection. Cannot delete data.');
    } else {
      final response =
      await http.delete(Uri.parse('$baseUrl/delete/$transactionId'));
      if (response.statusCode == 200) {
        await transactionLocalStorage.deleteById(transactionId);
      } else {
        throw Exception('Failed to delete transaction data from API');
      }
    }
  }

  @override
  Future<void> saveTransactionList(List<Transaction> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _transactionDataKey,
      jsonEncode(dataList.map((data) => data.toJson()).toList()),
    );
  }
}
