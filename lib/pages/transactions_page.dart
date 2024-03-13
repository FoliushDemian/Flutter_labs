import 'package:flutter/material.dart';
import 'package:my_project/logic/models/transaction.dart';
import 'package:my_project/logic/services/transaction_service.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  final TransactionService _service = TransactionService();

  @override
  void initState() {
    super.initState();
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
              final title = _titleController.text;
              final amount = double.tryParse(_amountController.text) ?? 0.0;
              final transaction = Transaction(
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
                }
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('No transactions found'));
                }
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    final transaction = snapshot.data![index];
                    return ListTile(
                      title: Text(transaction.title),
                      subtitle: Text(
                        'Amount: \$${transaction.amount.toStringAsFixed(2)}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          await _service.deleteTransaction(index);
                          setState(() {});
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
