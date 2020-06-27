class Transaction {
  final String id;
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime date;

  // Maybe the location type needs to be changed later from String to Location.
  // final String location;

  Transaction.income(
    this.amount, {
    this.id,
    this.description,
    // this.location,
    this.date,
  }) : type = TransactionType.income;

  Transaction.expense(
    this.amount, {
    this.id,
    this.description,
    // this.location,
    this.date,
  }) : type = TransactionType.expense;

  Map<String, dynamic> asMap() {
    return {
      'amount': amount,
      'id': id,
      'description': description,
      'type': this.type == TransactionType.income ? 'Income' : 'Expense',
      'date': date.toString(),
    };
  }

  Transaction.fromMap(Map<String, dynamic> transaction)
      : amount = transaction['amount'],
        id = transaction['id'],
        description = transaction['description'],
        type = transaction['type'].contains('Income')
            ? TransactionType.income
            : TransactionType.expense,
        date = DateTime.parse(transaction['date']);
}

enum TransactionType {
  income,
  expense,
}
