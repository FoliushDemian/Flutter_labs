import 'dart:convert';

import 'package:my_project/logic/models/transaction.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TransactionLocalStorage {
  static const _transactionDataKey = 'transactionData';

  Future<void> post(Transaction data) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Transaction> dataList = await findAll();

    dataList.add(data);
    final List<String> jsonDataList =
    dataList.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList(_transactionDataKey, jsonDataList);
  }

  Future<List<Transaction>> findAll() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? jsonDataList = prefs.getStringList(_transactionDataKey);

    if (jsonDataList == null) return [];
    return jsonDataList
        .map((jsonData) =>
        Transaction.fromJson(jsonDecode(jsonData) as Map<String, dynamic>),)
        .toList();
  }

  Future<void> deleteById(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final List<Transaction> dataList = await findAll();
    dataList.removeWhere((data) => data.id == id);

    final List<String> jsonDataList =
    dataList.map((data) => jsonEncode(data.toJson())).toList();
    await prefs.setStringList(_transactionDataKey, jsonDataList);
  }

  Future<void> deleteAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_transactionDataKey);
  }
}
