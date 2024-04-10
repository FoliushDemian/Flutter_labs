import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/bloc/events/transactions_events.dart';
import 'package:my_project/bloc/states/transaction_states.dart';
import 'package:my_project/logic/services/transaction_service.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionService _transactionService;


  TransactionBloc(this._transactionService) : super(TransactionInitial()) {
    on<LoadTransaction>((event, emit) async {
      emit(TransactionLoading());
      try {
        final data = await _transactionService.loadTransactionList();
        emit(TransactionLoaded(data));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<AddTransaction>((event, emit) async {
      try {
        await _transactionService.addTransaction(event.transaction);
        add(LoadTransaction());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<DeleteTransaction>((event, emit) async {
      try {
        await _transactionService.deleteTransaction(event.id);
        add(LoadTransaction());
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}
