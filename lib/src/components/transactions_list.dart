import 'package:cmm/src/models/transaction.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../scoped_models/app_provider.dart';

class Transactionslist extends StatefulWidget {
  @override
  _TransactionslistState createState() => _TransactionslistState();
}

class _TransactionslistState extends State<Transactionslist> {
  DateTime dateSelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          padding: EdgeInsets.all(1.0),
          decoration: BoxDecoration(
            // color: Theme.of(context).backgroundColor,
            color: Colors.white,
            border: Border.all(width: 0.3, color: Colors.white),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              TransactionBar(
                dateChanged: (value) {
                  setState(() {
                    dateSelected = value;
                  });
                },
              ),
              Expanded(
                child: ListView.builder(
                  itemBuilder: listBuilder,
                  itemCount: appProvider.account.transactions.length,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget listBuilder(BuildContext context, int index) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return areDatesEqual(
          appProvider.account.sortedTransactions[index].date,
          dateSelected,
        )
            ? TransactionListItem(
                transaction: appProvider.account.sortedTransactions[index],
              )
            : Container();
      },
    );
  }
}

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  TransactionListItem({@required this.transaction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Dismissible(
        key: Key('${transaction.id}'),
        child: Card(
          elevation: 10,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: transaction.type == TransactionType.income
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                      )
                    ]),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(children: <Widget>[
                      Text(
                        'Expense',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        size: 16,
                      ),
                    ]),
                  ),
            title: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  Text(
                    '\$ ${transaction.amount}',
                    style: TextStyle(
                      color: transaction.type == TransactionType.income
                          ? Colors.blue
                          : Colors.red,
                    ),
                  ),
                ],
              ),
            ),
            trailing: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                transaction.description,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontFamily: 'Saira',
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TransactionBar extends StatefulWidget {
  final Function dateChanged;

  TransactionBar({this.dateChanged});

  @override
  _TransactionBarState createState() => _TransactionBarState();
}

class _TransactionBarState extends State<TransactionBar> {
  DateTime dateSelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          decoration: BoxDecoration(
            color: Theme.of(context).backgroundColor,
          ),
          child: Column(
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  border: BorderDirectional(
                    top: BorderSide(color: Colors.grey[800]),
                    bottom: BorderSide(color: Colors.grey[800]),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                        alignment: Alignment.centerLeft,
                        child: Text(
                          areDatesEqual(dateSelected, DateTime.now())
                              ? 'TODAY'
                              : areDatesEqual(
                                  dateSelected,
                                  DateTime.now().subtract(
                                    Duration(days: 1),
                                  ),
                                )
                                  ? 'YESTERDAY'
                                  : 'PAST',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Icon(Icons.arrow_left),
                            Text(
                              'Previous',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            dateSelected = dateSelected.subtract(
                              Duration(days: 1),
                            );
                          });

                          widget.dateChanged(dateSelected);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${DateFormat('dd-MM-yyyy').format(dateSelected)}',
                        style: TextStyle(
                          // fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Next',
                              style: TextStyle(
                                fontSize: 10,
                              ),
                            ),
                            Icon(Icons.arrow_right)
                          ],
                        ),
                        onTap: () {
                          if (dateSelected.day <= DateTime.now().day - 1 &&
                              dateSelected.month <= DateTime.now().month &&
                              dateSelected.year <= DateTime.now().year) {
                            setState(() {
                              dateSelected = dateSelected.add(
                                Duration(days: 1),
                              );

                              widget.dateChanged(dateSelected);
                            });
                          }
                        },
                        onDoubleTap: () {
                          setState(() {
                            dateSelected = DateTime.now();
                          });

                          widget.dateChanged(dateSelected);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: InkWell(
                        child: Icon(Icons.date_range),
                        onTap: () => showDatePicker(
                          context: context,
                          firstDate: DateTime(1984),
                          lastDate: DateTime.now(),
                          initialDate: DateTime.now(),
                        ).then((date) {
                          if (date != null) {
                            setState(() {
                              dateSelected = date;
                            });

                            widget.dateChanged(dateSelected);
                          }
                        }),
                      ),
                    ),
                  ],
                ),
              ),
              _incomeExpenseForDate(appProvider),
            ],
          ),
        );
      },
    );
  }

  Widget _incomeExpenseForDate(AppProvider appProvider) {
    return Container(
      decoration: BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: Colors.grey),
        ),
      ),
      padding: EdgeInsets.all(5.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'EXPENSES',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    '${appProvider.account.totalExpensesFor(dateSelected)}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
          Row(
            children: <Widget>[
              Column(
                children: <Widget>[
                  Text(
                    'INCOME',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    '${appProvider.account.totalIncomeFor(dateSelected)}',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              )
            ],
          ),
        ],
      ),
    );
  }
}

bool areDatesEqual(DateTime date1, DateTime date2) {
  return date1.day == date2.day &&
      date1.month == date2.month &&
      date1.year == date2.year;
}
