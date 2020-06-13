import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  final Account account = Account();

  void addIncome(
    double amount, {
    String description,
    DateTime date,
  }) {
    account.addIncome(Transaction.income(
      amount,
      description: description,
      date: date,
    ));
    notifyListeners();
  }

  void addExpense(
    double amount, {
    String description,
    DateTime date,
  }) {
    account.addExpense(Transaction.expense(
      amount,
      description: description,
      date: date,
    ));
    notifyListeners();
  }
}
