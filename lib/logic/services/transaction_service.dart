import 'dart:convert';
import 'package:my_project/logic/models/transaction.dart';
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
    final prefs = await SharedPreferences.getInstance();
    final transactionDataString = prefs.getString(_transactionDataKey);
    if (transactionDataString != null) {
      final List<dynamic> jsonDataList =
          jsonDecode(transactionDataString) as List<dynamic>;
      return jsonDataList
          .map(
            (jsonData) =>
                Transaction.fromJson(jsonData as Map<String, dynamic>),
          )
          .toList();
    }
    return [];
  }

  @override
  Future<void> saveTransactionList(List<Transaction> dataList) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(
      _transactionDataKey,
      jsonEncode(dataList.map((data) => data.toJson()).toList()),
    );
  }

  @override
  Future<void> addTransaction(Transaction data) async {
    final dataList = await loadTransactionList();
    dataList.add(data);
    await saveTransactionList(dataList);
    await updateBalance(data.amount);
  }

  @override
  Future<void> deleteTransaction(int index) async {
    final dataList = await loadTransactionList();
    if (index >= 0 && index < dataList.length) {
      dataList.removeAt(index);
      await saveTransactionList(dataList);
    }
  }
}
