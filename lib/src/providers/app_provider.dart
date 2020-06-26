import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  final Account account = Account();
  String _currency = 'USD';
  double _lowBalanceThreshold = 0.0;

  static int transactionId = 0;

  void addIncome(
    double amount, {
    String description,
    DateTime date,
  }) {
    account.addIncome(Transaction.income(
      amount,
      id: transactionId,
      description: description,
      date: date,
    ));

    transactionId++;

    notifyListeners();
  }

  void addExpense(
    double amount, {
    String description,
    DateTime date,
  }) {
    account.addExpense(Transaction.expense(
      amount,
      id: transactionId,
      description: description,
      date: date,
    ));

    transactionId++;

    notifyListeners();
  }

  void updateTransaction({Transaction original, Transaction replacement}) {
    account.updateTransaction(original, replacement);
    notifyListeners();
  }

  void deleteTransaction(Transaction transaction) {
    account.deleteTransaction(transaction);
    notifyListeners();
  }

  set currency(String value) {
    _currency = value;
    notifyListeners();
  }

  String get currency => _currency;

  set lowBalanceThreshold(double value) {
    _lowBalanceThreshold = value;
    notifyListeners();
  }

  double get lowBalanceThreshold => _lowBalanceThreshold;
}
