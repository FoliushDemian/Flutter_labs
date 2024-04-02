import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/bloc/events/transactions_events.dart';
import 'package:my_project/bloc/states/transaction_states.dart';
import 'package:my_project/bloc/transaction_bloc.dart';
import 'package:my_project/logic/models/transaction.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({super.key});

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  final _idController = TextEditingController();
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  late TransactionBloc _transactionBloc;

  @override
  void initState() {
    super.initState();
    _transactionBloc = context.read<TransactionBloc>();
    _transactionBloc.add(LoadTransaction());
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
              BlocProvider.of<TransactionBloc>(context)
                  .add(AddTransaction(transaction));
              _titleController.clear();
              _amountController.clear();
              setState(() {});
            },
            child: const Text('Add Transaction'),
          ),
          Expanded(
            child: BlocBuilder<TransactionBloc, TransactionState>(
              builder: (context, state) {
                if (state is TransactionLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is TransactionLoaded) {
                  return ListView.builder(
                    itemCount: state.transactions.length,
                    itemBuilder: (context, index) {
                      final item = state.transactions[index];
                      return ListTile(
                        title: Text('title: ${item.title},'
                            ' Amount: ${item.amount}'),
                        trailing: Wrap(
                          spacing: 12,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.delete),
                              onPressed: () => _transactionBloc
                                  .add(DeleteTransaction(item.id)),
                            ),
                          ],
                        ),
                      );
                    },
                  );
                } else if (state is TransactionError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('No data available'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
