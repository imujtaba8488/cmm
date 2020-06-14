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

  void updateTransaction(Transaction original, Transaction replacement) {
    transactions.forEach((transaction) {
      if (original.id == transaction.id) {
        int indexOf = transactions.indexOf(transaction);

        _balance -= transaction.amount;

        transactions.removeAt(indexOf);

        replacement.type == TransactionType.income
            ? addIncome(
                replacement,
              )
            : addExpense(replacement);
      }
    });
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

  List<Transaction> get sortedTransactions {
    List<Transaction> xTransactions = List.of(transactions);

    xTransactions.sort((t1, t2) {
      return t1.date.compareTo(t2.date);
    });

    return xTransactions.reversed.toList();
  }

  double totalExpensesFor(DateTime date) {
    double total = 0.0;

    transactionsFor(date).forEach((transaction) {
      if (transaction.type == TransactionType.expense) {
        total += transaction.amount;
      }
    });

    return total;
  }

  double totalIncomeFor(DateTime date) {
    double total = 0.0;

    transactionsFor(date).forEach((transaction) {
      if (transaction.type == TransactionType.income) {
        total += transaction.amount;
      }
    });

    return total;
  }

  List<Transaction> transactionsFor(DateTime date) {
    List<Transaction> xTransactions = [];

    if (date.day <= DateTime.now().day &&
        date.month <= DateTime.now().month &&
        date.year <= DateTime.now().year) {
      transactions.forEach((transaction) {
        if (transaction.date.day == date.day &&
            transaction.date.month == date.month &&
            transaction.date.year == date.year) {
          xTransactions.add(transaction);
        }
      });
    }

    return xTransactions;
  }
}
