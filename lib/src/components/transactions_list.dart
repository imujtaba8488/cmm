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
            border: Border.all(width: 0.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).backgroundColor,
                  borderRadius: BorderRadius.only(
                      // topLeft: Radius.circular(15.0),
                      // topRight: Radius.circular(15.0),
                      ),
                ),
                child: Column(
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(color: Colors.grey[800]),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
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
                                if (dateSelected.day <=
                                        DateTime.now().day - 1 &&
                                    dateSelected.month <=
                                        DateTime.now().month &&
                                    dateSelected.year <= DateTime.now().year) {
                                  setState(() {
                                    dateSelected = dateSelected.add(
                                      Duration(days: 1),
                                    );
                                  });
                                }
                              },
                              onDoubleTap: () {
                                setState(() {
                                  dateSelected = DateTime.now();
                                });
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
                                }
                              }),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(color: Colors.grey),
                        ),
                      ),
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              Icon(Icons.arrow_upward),
                              Text(
                                'Expenses: ${appProvider.account.totalExpensesFor(dateSelected)}',
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[
                              Icon(Icons.arrow_downward),
                              Text(
                                'Income: ${appProvider.account.totalIncomeFor(dateSelected)}',
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
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
        return appProvider.account.sortedTransactions[index].date.day ==
                    dateSelected.day &&
                appProvider.account.sortedTransactions[index].date.year ==
                    dateSelected.year &&
                appProvider.account.sortedTransactions[index].date.month ==
                    dateSelected.month
            ? Card(
                elevation: 1,
                child: ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: appProvider.account.sortedTransactions[index].type ==
                          TransactionType.income
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
                          '\$ ${appProvider.account.sortedTransactions[index].amount}',
                          style: TextStyle(
                            color: appProvider.account.sortedTransactions[index]
                                        .type ==
                                    TransactionType.income
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
                      appProvider.account.sortedTransactions[index].description,
                      style: TextStyle(
                        color: Colors.blueGrey,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              )
            : Container();
      },
    );
  }
}
