import 'package:flutter/material.dart';

import '../models/account.dart';
import '../models/cloud.dart';
import '../models/transaction.dart';

class AppProvider extends ChangeNotifier {
  final Account account;
  final Cloud _cloud;
  String _currency;
  double _lowBalanceThreshold;
  static int dummyID = 0;

  AppProvider() : account = Account(), _cloud = Cloud() {
    _currency = 'USD';
    _lowBalanceThreshold = 0.0;

    _loadData();
  }

  void _loadData() async {
    List<Transaction> cloudTransactions =
        await _cloud.readAllTransaction('mujtaba');

    if (cloudTransactions != null) {
      cloudTransactions.forEach((transaction) {
        account.addTransaction(transaction);
      });
    }

    notifyListeners();
  }

  void addIncome(
    double amount, {
    String description,
    DateTime date,
  }) async {
    // The firebase documentID is used as the ID for the transaction. Now, the firebase documentID is not instantly available, since adding the transaction to the firebase can take time, depending on the Internet connection, and the documentID is only available once the transaction has been added to the firebase db. But, to users the transaction should appear as soon as they add it. Hence, a dummyID is provided until a firebase documentID is recieved. Once the documentID received the transaction is updated behind the scenes to contain the received documentID.

    // Note about dummyID: As the app starts dummyID is going to start with 0 and increment accordingly. The previously added transactions by that time would have update with the firestore documentID, therefore, the current transactions with dummyIDs will not have any impact on the previous transactions.

    // Instantly add the transaction to the account, so that it is reflectly immediately to the app user.
    Transaction incomeTransactionWithDummyID = Transaction.income(
      amount,
      id: dummyID.toString(),
      description: description,
      date: date,
    );

    account.addIncome(incomeTransactionWithDummyID);

    dummyID++;

    notifyListeners();

    // Behind the scenes update the firestore db i.e. add transaction to the firestore db and fetch the documentID.
    String firebaseDocumentID = await _cloud.addTransaction(
      'mujtaba',
      incomeTransactionWithDummyID,
    );

    Transaction incomeTransactionWithFirebaseId = Transaction.income(
      amount,
      id: firebaseDocumentID,
      description: description,
      date: date,
    );

    // Once documentID is received update the transaction. This too happens behind the scenes.
    updateTransaction(
      original: incomeTransactionWithDummyID,
      replacement: incomeTransactionWithFirebaseId,
    );
  }

  void addExpense(
    double amount, {
    String description,
    DateTime date,
  }) async {
    // Note: Consult addIncome() for a more verbose explanation.

    // Instantly add the transaction to the account, so that it is reflectly immediately to the app user.
    Transaction expenseTransactionWithDummyID = Transaction.expense(
      amount,
      id: dummyID.toString(),
      description: description,
      date: date,
    );

    account.addExpense(expenseTransactionWithDummyID);

    dummyID++;

    notifyListeners();

    // Behind the scenes update the firestore db i.e. add transaction to the firestore db and fetch the documentID.
    String firebaseDocumentID = await _cloud.addTransaction(
      'mujtaba',
      expenseTransactionWithDummyID,
    );

    Transaction expenseTransactionWithFirebaseId = Transaction.expense(
      amount,
      id: firebaseDocumentID,
      description: description,
      date: date,
    );

    // Once documentID is received update the transaction. This too happens behind the scenes.
    updateTransaction(
      original: expenseTransactionWithDummyID,
      replacement: expenseTransactionWithFirebaseId,
    );
  }

  void updateTransaction({
    Transaction original,
    Transaction replacement,
  }) async {
    account.updateTransaction(original, replacement);
    notifyListeners();

    // Update in firestore db, behind the scenes.
    _cloud.updateTransaction('mujtaba', replacement);
  }

  void deleteTransaction(Transaction transaction) {
    account.deleteTransaction(transaction);
    notifyListeners();

    // Delete in firestore.
    _cloud.deleteTransaction('mujtaba', transaction);
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
