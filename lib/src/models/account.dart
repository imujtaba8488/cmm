import './transaction.dart';

class Account {
  final String name;
  double _balance = 0.0;
  final List<Transaction> transactions;

  Account({this.name}) : transactions = List();

  void addIncome(Transaction transaction) {
    if (transaction.type == TransactionType.income) {
      transactions.add(transaction);
      _balance += transaction.amount;
    }
  }

  void addExpense(Transaction transaction) {
    if (transaction.type == TransactionType.expense &&
        transaction.amount < _balance) {
      transactions.add(transaction);
      _balance -= transaction.amount;
    }
  }

  double get balance => _balance;

  double get totalIncome {
    double tIncome = 0.0;

    transactions.forEach((transaction) {
      if (transaction.type == TransactionType.income) {
        tIncome += transaction.amount;
      }
    });

    return tIncome;
  }

  double get totalExpense {
    double tExpense = 0.0;

    transactions.forEach((transaction) {
      if (transaction.type == TransactionType.expense) {
        tExpense += transaction.amount;
      }
    });

    return tExpense;
  }

  void deleteTransaction(int id) {
    if (id > 0) {
      for (int i = 0; i < transactions.length; i++) {
        if (transactions[i].id == id) {
          transactions.removeAt(i);
        }
      }
    }
  }

  void updateTransaction(int id, Transaction transaction) {
    if (id > 0) {
      for (int i = 0; i < transactions.length; i++) {
        if (transactions[i].id == id) {
          transactions.removeAt(i);
          transactions.insert(i, transaction);
        }
      }
    }
  }

  List<Transaction> get transactionsLatestFirst {
    return transactions.reversed.toList();
  }
}
