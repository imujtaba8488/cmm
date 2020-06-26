import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  final Account account = Account();
  String _currency = 'USD';

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

  /// Returns the list of transactions matching the searchValue with can either be the transaction amount or transaction description.
  List<Transaction> searchedTransactions(String searchValue) {
    List<Transaction> searchedTransactions = [];

    // If the searchValue is empty searchTransactions contains all transactions, otherwise it contains the transactions matching the searchValue. Remember, however, that any changes to the searched transactions are also applied to all transactions, since, search transactions only returns a filtered copy of all transactions.

    if (searchValue.trim().isEmpty) {
      searchedTransactions = account.sortedTransactions;
    } else {
      // Search for either the transaction amount or by description.
      searchedTransactions = account.sortedTransactions.where((transaction) {
        return transaction.amount.toString().startsWith(searchValue.trim()) ||
            transaction.description.startsWith(searchValue.trim()) ||
            transaction.description
                .toLowerCase()
                .startsWith(searchValue.trim());
      }).toList();
    }

    return searchedTransactions;
  }
}
