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
    if (transaction.type == TransactionType.expense) {
      transactions.add(transaction);
      _balance -= transaction.amount;
    }
  }

  void updateTransaction(Transaction original, Transaction replacement) {
    for (int index = 0; index < transactions.length; index++) {
      if (original.id == transactions[index].id) {
        // Add or deduct the balance based on the transaction type.
        if (original.type == TransactionType.income) {
          _balance -= transactions[index].amount;
        } else if (original.type == TransactionType.expense) {
          _balance += transactions[index].amount;
        }

        // Delete the transaction at the given index.
        transactions.removeAt(index);

        // Add the replacement transaction.
        replacement.type == TransactionType.income
            ? addIncome(replacement)
            : addExpense(replacement);

        break;
      }
    }
  }

  void deleteTransaction(Transaction transaction) {
    for (int index = 0; index < transactions.length; index++) {
      if (transactions[index].id == transaction.id) {
        // Update balance.
        transaction.type == TransactionType.income
            ? _balance -= transaction.amount
            : _balance += transaction.amount;

        // Remove transaction.
        transactions.removeAt(index);
      }
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

  /// Returns the list of transactions matching the searchValue with can either be the transaction amount or transaction description.
  List<Transaction> searchedTransactions(String searchValue) {
    List<Transaction> searchedTransactions = [];

    // If the searchValue is empty searchTransactions contains all transactions, otherwise it contains the transactions matching the searchValue. Remember, however, that any changes to the searched transactions are also applied to all transactions, since, search transactions only returns a filtered copy of all transactions.

    if (searchValue.trim().isEmpty) {
      searchedTransactions = sortedTransactions;
    } else {
      // Search for either the transaction amount or by description.
      searchedTransactions = sortedTransactions.where((transaction) {
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
