import '../util/datetime_as_string.dart';

class Transaction {
  final int id;
  final double amount;
  final String description;
  final TransactionType type;
  final DateTime date;

  // Maybe the location type needs to be changed later from String to Location.
  final String location;

  Transaction.income(
    this.amount, {
    this.id,
    this.description,
    this.location,
    this.date,
  }) : type = TransactionType.income;

  Transaction.expense(
    this.amount, {
    this.id,
    this.description,
    this.location,
    this.date,
  }) : type = TransactionType.expense;

  // String get date => DateTimeAsString.dateAsDDMMYY(_timestamp);

  // String get time => DateTimeAsString.time(_timestamp);

  // String get typeAsString => transactionTypeToString(type);

  // @override
  // String toString() {
  //   return '$amount | $date $time | $type';
  // }
}

enum TransactionType {
  income,
  expense,
}
