import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../widgets/date_selector.dart';

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
                child: DateSelector(
                  currentDate: dateSelected,
                  dateSelected: (value) {
                    setState(() {
                      dateSelected = value;
                    });
                  },
                  buttonColor: Colors.green,
                  showNextPreviouslabels: false,
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
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${appProvider.currency}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${appProvider.account.totalExpensesFor(dateSelected)}',
                        style: TextStyle(fontSize: 18),
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
                    style: TextStyle(color: Colors.grey),
                  ),
                  Row(
                    children: <Widget>[
                      Text(
                        '${appProvider.currency}',
                        style: TextStyle(color: Colors.grey),
                      ),
                      SizedBox(width: 5.0),
                      Text(
                        '${appProvider.account.totalIncomeFor(dateSelected)}',
                        style: TextStyle(fontSize: 18),
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
