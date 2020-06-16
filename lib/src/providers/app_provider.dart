import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  final Account account = Account();

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
}
