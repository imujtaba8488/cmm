import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../util/util';

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
                  border: Border(
                    bottom: BorderSide(width: 0.3, color: Colors.white),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
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
                    'EXPENSE',
                    style: TextStyle(
                      fontSize: 8,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${appProvider.currency}',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${appProvider.account.totalExpensesFor(dateSelected)}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
                  Row(
                    children: <Widget>[
                      Text(
                        '${appProvider.currency}',
                        style: TextStyle(
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${appProvider.account.totalIncomeFor(dateSelected)}',
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
