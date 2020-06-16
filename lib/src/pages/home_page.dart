import 'package:custom_widgets/animated_containers/zoom_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/add_transaction_sheet.dart';
import '../components/app_drawer.dart';
import '../components/transactions_list.dart';
import '../providers/app_provider.dart';
import '../components/bottom_nav_bar.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double topHeight;
  double bottomHeight;

  @override
  Widget build(BuildContext context) {
    topHeight = MediaQuery.of(context).size.height / 4.0;
    bottomHeight = MediaQuery.of(context).size.height - (topHeight + 24);

    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        actions: <Widget>[
          Center(
            child: Text('Welcome Back Mujtaba !'),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundImage: AssetImage('assets/test.jpg'),
            ),
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionSheet(context),
        child: Icon(Icons.add),
        // mini: true,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _top(context),
            Expanded(
              child: Transactionslist(),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(),
    );
  }

  Widget _top(BuildContext context) {
    return Container(
      height: topHeight,
      padding: EdgeInsets.all(18.0),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(child: Consumer<AppProvider>(
            builder: (context, appProvider, child) {
              return Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'BALANCE',
                      style: TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    _balanceAndIncomeExpenseBar(appProvider),
                    appProvider.account.balance < 500
                        ? Container(
                            width: MediaQuery.of(context).size.width / 2.6,
                            child: FittedBox(
                              child: Text(
                                'You are running low on balance!',
                              ),
                            ),
                          )
                        : Container()
                  ],
                ),
              );
            },
          ))
        ],
      ),
    );
  }

  Widget _balanceAndIncomeExpenseBar(AppProvider appProvider) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width / 2.5,
          child: FittedBox(
            child: Row(
              children: <Widget>[
                ZoomIn(
                  duration: 200,
                  child: Text(
                    '\$ ${appProvider.account.balance}',
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
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
        ),
        _totalIncomeExpense(appProvider),
      ],
    );
  }

  Widget _totalIncomeExpense(AppProvider appProvider) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width / 2,
      decoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            width: 0.2,
            color: Colors.white,
          ),
        ),
      ),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Total Expenses',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '\$ ${appProvider.account.totalExpense}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: <Widget>[
                  Text(
                    'Total Income',
                    style: TextStyle(
                      fontSize: 10,
                    ),
                  ),
                  Text(
                    '\$ ${appProvider.account.totalIncome}',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
