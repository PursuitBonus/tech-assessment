import 'package:flutter_bloc/flutter_bloc.dart';

import '../models/transaction_item.dart';

class WalletState {
  final double balance;
  final List<TransactionItem> transactions;

  WalletState({
    required this.balance,
    this.transactions = const [],
  });

  WalletState copyWith({
    double? balance,
    List<TransactionItem>? transactions,
  }) {
    return WalletState(
      balance: balance ?? this.balance,
      transactions: transactions ?? this.transactions,
    );
  }
}

class WalletCubit extends Cubit<WalletState> {
  WalletCubit() : super(WalletState(balance: 10.0)); // balance from 2 sold items at 5 EUR

  void withdraw(double amount) {
    if (amount > state.balance) return;

    final tx = TransactionItem(
      id: 'withdraw-${DateTime.now().millisecondsSinceEpoch}',
      description: 'Withdrawal',
      amount: -amount,
      date: DateTime.now(),
    );

    emit(state.copyWith(
      balance: state.balance - amount,
      transactions: [tx, ...state.transactions],
    ));
  }

  void deposit(double amount) {
    emit(state.copyWith(balance: state.balance + amount));
  }

  void reset() {
    emit(WalletState(balance: 0.0));
  }

  void addTransaction(TransactionItem tx) {
    emit(WalletState(
      balance: state.balance + tx.amount,
      transactions: [...state.transactions, tx],
    ));
  }
}
