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
import '../components/custom_button.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
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
      WidgetsBinding.instance.addPostFrameCallback(
        (_) async {
          await showDialog<String>(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) => LoginDialog(),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    appProvider.isSignedIn ? SignOutDialog() : LoginDialog(),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  backgroundImage: appProvider.user?.imageUrl == null
                      ? AssetImage('assets/test.jpg')
                      : NetworkImage(appProvider.user?.imageUrl),
                ),
              ),
            ),
            title: InkWell(
              onTap: () => showDialog(
                context: context,
                builder: (context) =>
                    appProvider.isSignedIn ? SignOutDialog() : LoginDialog(),
              ),
              child: Text(
                '${appProvider.user?.firstName} ${appProvider.user?.lastName}',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            actions: <Widget>[
              CustomButton(
                child: Text('${appProvider.currency}'),
                onPressed: () => showCurrencyChooser(context),
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => showAddTransactionSheet(context),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerDocked,
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Column(
              children: <Widget>[
                Expanded(
                  child: Dashboard(),
                ),
                Expanded(
                  flex: 2,
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
}

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
      },
    );
  }
}

class SignOutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    AppProvider appProvider = Provider.of<AppProvider>(context);

    return BasicDialog(
      child: FlatButton(
        onPressed: () {
          appProvider.signOut();
          Navigator.pop(context);

          showDialog(
            context: context,
            builder: (context) => LoginDialog(),
          );
        },
        child: Text(
          'Sign Out',
          style: TextStyle(
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

void showCurrencyChooser(BuildContext context) {
  showDialog(
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
  );
}

void showAddTransactionSheet(BuildContext context) {
  showModalBottomSheet(
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
  );
}
