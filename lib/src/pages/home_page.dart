import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/add_transaction_form.dart';
import '../components/bottom_nav_bar.dart';
import '../components/transactions_list.dart';
import '../country_currency_chooser/currency_chooser_dialog.dart';
import '../providers/app_provider.dart';
import '../login/login_dialog.dart';
import '../widgets/basic_dialog.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double topHeight;
  double bottomHeight;
  AppProvider appProvider;

  @override
  void initState() {
    super.initState();

    appProvider = Provider.of<AppProvider>(context, listen: false);

    // context parameter is required to show the LoginDialog.
    tryAutoSignIn(context);
  }

  void tryAutoSignIn(BuildContext context) async {
    final SharedPreferences pref = await SharedPreferences.getInstance();

    bool signedIn = false;

    if (pref.getKeys().length != 0) {
      signedIn = await appProvider.autoSignIn();
    }

    // First wait for the autoSignIn. If autoSignIn fails, show the LoginDialog. This ensures everybody signs in or signs up for the app.

    if (!signedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        await showDialog<String>(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) => LoginDialog(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    topHeight = MediaQuery.of(context).size.height / 4.0;
    bottomHeight = MediaQuery.of(context).size.height - (topHeight + 24);

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => appProvider.isSignedIn
                    ? BasicDialog(
                        child: FlatButton(
                          onPressed: () {
                            appProvider.signOut();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      )
                    : LoginDialog(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage('assets/test.jpg'),
                ),
              ),
            ),
            title: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) => appProvider.isSignedIn
                    ? BasicDialog(
                        child: FlatButton(
                          onPressed: () {
                            appProvider.signOut();
                            Navigator.pop(context);
                          },
                          child: Text(
                            'Sign Out',
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          ),
                        ),
                      )
                    : LoginDialog(),
              ),
              child: Text(
                '${appProvider.user?.firstName ?? 'Guest'} ${appProvider.user?.lastName ?? ''}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            actions: <Widget>[
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
                  builder: (context) {
                    return Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                        return CurrencyChooserDialog(
                          interfaceColor: Colors.white,
                          backgroundColor: Theme.of(context).backgroundColor,
                          selectedCurrency: (flag, value) {
                            appProvider.currency = value;
                          },
                        );
                      },
                    );
                  },
                ),
              )
            ],
            shape: RoundedRectangleBorder(),
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => showModalBottomSheet(
              isScrollControlled: true,
              enableDrag: true,
              backgroundColor: Theme.of(context).backgroundColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15.0),
                  topRight: Radius.circular(15.0),
                ),
              ),
              context: context,
              builder: (context) => AddTransactionForm(),
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                _top(context),
                Expanded(
                  child: Transactionslist(),
                ),
                Container()
              ],
            ),
          ),
          bottomNavigationBar: BottomNavBar(),
        ),
        Consumer<AppProvider>(
          builder: (context, provider, child) {
            return provider.isDataLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container();
          },
        ),
      ],
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
              appProvider.account.balance < appProvider.lowBalanceThreshold
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
                        '${appProvider.account.totalExpense}',
                        style: TextStyle(
                          fontSize: 14,
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
                    style: TextStyle(
                      fontSize: 10,
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
                        '${appProvider.account.totalIncome}',
                        style: TextStyle(
                          fontSize: 14,
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
  }
}
