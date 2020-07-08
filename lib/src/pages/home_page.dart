import 'package:country_currency_chooser/country_currency_chooser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../components/add_transaction_form.dart';
import '../components/bottom_nav_bar.dart';
import '../components/custom_button.dart';
import '../components/dashboard.dart';
import '../components/profile_view.dart';
import '../components/transactions_list.dart';
import '../login/login_dialog.dart';
import '../providers/app_provider.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  void initState() {
    super.initState();

    // context parameter is required to show the LoginDialog.
    tryAutoSignIn(context);
  }

  void tryAutoSignIn(BuildContext context) async {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);
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
            title: ProfileView(),
            actions: <Widget>[
              Consumer<AppProvider>(
                builder: (context, pro, child) {
                  return CustomButton(
                    child: Text('${pro.currency}'),
                    onPressed: () => _showCurrencyChooser(context),
                  );
                },
              ),
            ],
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () => _showAddTransactionSheet(context),
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

void _showCurrencyChooser(BuildContext context) {
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

void _showAddTransactionSheet(BuildContext context) {
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
