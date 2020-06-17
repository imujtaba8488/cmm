import 'package:cmm/src/currency_drop_down/countries.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/add_transaction_sheet.dart';
import '../components/transactions_list.dart';
import '../providers/app_provider.dart';
import '../components/bottom_nav_bar.dart';
import '../currency_drop_down/currency_drop_down.dart';
import '../widgets/basic_dialog.dart';

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
      appBar: AppBar(
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/test.jpg'),
          ),
        ),
        title: Text(
          'Welcome Back Mujtaba !',
          style: TextStyle(
            fontSize: 12,
          ),
        ),
        actions: <Widget>[
          // Consumer<AppProvider>(
          //   builder: (context, appProvider, child) {
          //     return CurrencyDropDown(
          //       onSelected: (value) => appProvider.currency = value,
          //     );
          //   },
          // ),

          InkWell(
            child: Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                return Container(
                  width: 50,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(50.0),
                  ),
                  padding: EdgeInsets.all(10.0),
                  margin: EdgeInsets.all(10.0),
                  child: Center(
                    child: Text('${appProvider.currency}'),
                  ),
                );
              },
            ),
            onTap: () => showDialog(
              context: context,
              builder: (context) => BasicDialog(
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Search',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemBuilder: (context, index) {
                          return Consumer<AppProvider>(
                            builder: (context, appProvider, child) {
                              return InkWell(
                                onTap: () {
                                  appProvider.currency =
                                      currencyCodesSorted()[index];
                                  Navigator.pop(context);
                                },
                                child: Column(
                                  children: <Widget>[
                                    Text(currencyCodesSorted()[index]),
                                    Divider(
                                      color: Colors.white,
                                    )
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        itemCount: currencyCodesSorted().length,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
        shape: RoundedRectangleBorder(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionSheet(context),
        child: Icon(Icons.add),
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
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  _balanceAndIncomeExpenseBar(appProvider),
                  _totalIncomeExpense(appProvider),
                ],
              ),
              appProvider.account.balance < 500
                  ? Container(
                      width: MediaQuery.of(context).size.width / 2.6,
                      child: FittedBox(
                        child: Text(
                          'You are running low on balance!',
                        ),
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
    );
  }

  Widget _balanceAndIncomeExpenseBar(AppProvider appProvider) {
    return Container(
      width: MediaQuery.of(context).size.width / 2.5,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'BALANCE',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          FittedBox(
            child: Row(
              children: <Widget>[
                Text(
                  '${appProvider.currency}',
                  style: TextStyle(
                    fontSize: 12,
                  ),
                ),
                Text(
                  ' ${appProvider.account.balance}',
                  style: TextStyle(
                    fontSize: 25,
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
  }

  Widget _totalIncomeExpense(AppProvider appProvider) {
    return Container(
      width: MediaQuery.of(context).size.width / 3.0,
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: FittedBox(
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
            ),
          )
        ],
      ),
    );
  }
}
