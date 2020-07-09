import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(18.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      flex: 2,
                      child: BalanceView(),
                    ),
                    Expanded(
                      child: TotalIncomeExpenseView(),
                    ),
                  ],
                ),
                appProvider.account.balance < appProvider.lowBalanceThreshold
                    ? Container(
                        child: Text(
                          'You are running low on balance!',
                          style: TextStyle(fontSize: 12),
                        ),
                      )
                    : Container(),
              ],
            ),
          );
        },
      ),
    );
  }
}

class BalanceView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, widget) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'BALANCE',
                style: TextStyle(color: Colors.grey, fontSize: 18),
              ),
              FittedBox(
                child: Row(
                  children: <Widget>[
                    Text(
                      '${appProvider.currency}',
                      style: TextStyle(color: Colors.grey),
                    ),
                    Text(
                      ' ${appProvider.account.balance}',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    appProvider.account.totalIncomeFor(DateTime.now()) >
                            appProvider.account.totalExpensesFor(
                              DateTime.now(),
                            )
                        ? Padding(
                            padding: EdgeInsets.symmetric(horizontal: 5),
                            child: Icon(Icons.arrow_upward, size: 12),
                          )
                        : Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 5,
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              size: 12,
                            ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class TotalIncomeExpenseView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          padding: EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(
                width: 0.2,
                color: Colors.white,
              ),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Total Expenses',
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
                            '${appProvider.account.totalExpense}',
                            style: TextStyle(
                              // fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FittedBox(
                  child: Column(
                    children: <Widget>[
                      Text(
                        'Total Income',
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
                            '${appProvider.account.totalIncome}',
                            style: TextStyle(
                              // fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
