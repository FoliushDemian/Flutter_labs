import 'package:flutter/material.dart';
import 'package:my_project/logic/models/transaction.dart';
import 'package:my_project/logic/services/transaction_service.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final TransactionService _service = TransactionService();

  List<Transaction> _transactionList = [];
  Future<void> _loadTransactionList() async {
    final data = await _service.loadTransactionList();
    setState(() => _transactionList = data);
  }

  @override
  void initState() {
    super.initState();
    _loadTransactionList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transactions'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _idController,
              decoration: const InputDecoration(labelText: 'id'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              final id = _idController.text;
              final title = _titleController.text;
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final transaction = Transaction(
                  id: int.parse(id),
                title: title,
                amount: amount,
              );
              await _service.addTransaction(transaction);
              _titleController.clear();
              _amountController.clear();
              setState(() {});
            },
            child: const Text('Add Transaction'),
          ),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: _service.loadTransactionList(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      final item = snapshot.data![index];
                      return ListTile(
                        title: Text('title: ${item.title}, '
                            ' amount: ${item.amount}'),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () async {
                                await _service
                                    .deleteTransaction(item.id);
                                setState(() {});
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No data available'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

