import 'package:my_project/logic/models/transaction.dart';

abstract class TransactionEvent {}

class LoadTransaction extends TransactionEvent {}

class AddTransaction extends TransactionEvent {
  final Transaction transaction;

  AddTransaction(this.transaction);

  List<Object> get props => [transaction];

}

class DeleteTransaction extends TransactionEvent {
  final int id;

  DeleteTransaction(this.id);
}
