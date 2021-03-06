import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/account.dart';
import '../models/cloud.dart';
import '../models/transaction.dart';
import '../models/user.dart';

class AppProvider extends ChangeNotifier {
  final Account account;
  final Cloud _cloud;
  String _currency;
  double _lowBalanceThreshold;
  static int dummyID = 0;
  User user;
  bool isSignedIn;
  bool isDataLoading;

  AppProvider()
      : account = Account(),
        _cloud = Cloud() {
    _currency = 'USD';
    _lowBalanceThreshold = 0.0;
    isSignedIn = false;
    isDataLoading = false;

    _loadData();
  }

  void _loadData() async {
    if (user != null) {
      isDataLoading = true;

      notifyListeners();

      List<Transaction> cloudTransactions =
          await _cloud.readAllTransaction(user.email);

      if (cloudTransactions != null) {
        cloudTransactions.forEach((transaction) {
          account.addTransaction(transaction);
        });
      }

      _currency = user.currency;

      _lowBalanceThreshold = user.lowBalanceThreshold;

      isDataLoading = false;

      notifyListeners();
    }
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
    if (user != null) {
      String firebaseDocumentID = await _cloud.addTransaction(
        user.email,
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
    if (user != null) {
      String firebaseDocumentID = await _cloud.addTransaction(
        user.email,
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
  }

  void updateTransaction({
    Transaction original,
    Transaction replacement,
  }) async {
    account.updateTransaction(original, replacement);
    notifyListeners();

    // Update in firestore db, behind the scenes.
    if (user != null) {
      _cloud.updateTransaction(user.email, replacement);
    }
  }

  void deleteTransaction(Transaction transaction) {
    account.deleteTransaction(transaction);
    notifyListeners();

    // Delete in firestore.
    if (user != null) {
      _cloud.deleteTransaction(user.email, transaction);
    }
  }

  set currency(String value) {
    _currency = value;

    if (user != null) {
      user.currency = _currency;
      _cloud.updateUser(replacementUser: user);
    }

    notifyListeners();
  }

  String get currency => _currency;

  set lowBalanceThreshold(double value) {
    _lowBalanceThreshold = value;

    if (user != null) {
      user.lowBalanceThreshold = _lowBalanceThreshold;
      _cloud.updateUser(replacementUser: user);
    }

    notifyListeners();
  }

  double get lowBalanceThreshold => _lowBalanceThreshold;

  Future<bool> addUser({
    @required String email,
    @required String password,
    String firstName,
    String lastName,
    File imageFile,
  }) async {
    List<User> allUsers = await _cloud.getAllUsers();

    bool userExists = false;

    allUsers.forEach((cloudUser) {
      if (cloudUser.email == email) {
        userExists = true;
      }
    });

    if (!userExists) {
      User userToAdd = User(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        currency: 'USD',
        id: 'temp',
        lowBalanceThreshold: 0.0,
      );

      Map<String, dynamic> result =
          await _cloud.addUser(userToAdd, imageFile: imageFile);

      // Immediately update the user in the background with the id received.
      userToAdd.id = result['id'];

      if (result['imageUrl'] != null) {
        userToAdd.imageUrl = result['imageUrl'];
      }

      _cloud.updateUser(replacementUser: userToAdd);

      return true;
    }

    return false;
  }

  void updateUser(User replacementUser, {File imageFile}) async {
    await _cloud.updateUser(replacementUser: replacementUser, imageFile: imageFile);
    user = replacementUser;

    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    List<User> allUsers = await _cloud.getAllUsers();

    bool signInSuccess = false;

    allUsers.forEach((User userOnCloud) {

      if (userOnCloud.email == email && userOnCloud.password == password) {
        this.user = userOnCloud;
        signInSuccess = true;

        isSignedIn = true;

        pref.setString('email', user.email);
        pref.setString('password', user.password);
      }
    });

    if (signInSuccess) {
      _loadData();
    }

    return signInSuccess;
  }

  void signOut() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    // Reset everything.
    user = null;
    isSignedIn = false;
    currency = 'USD';
    account.reset();
    await pref.clear();

    notifyListeners();
  }

  Future<bool> autoSignIn() async {
    final SharedPreferences pref = await SharedPreferences.getInstance();
    String username = pref.getString('email');
    String password = pref.getString('password');

    return await signIn(username, password);
  }
}
