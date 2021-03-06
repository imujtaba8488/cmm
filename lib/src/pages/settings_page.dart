import 'package:country_currency_chooser/country_currency_chooser.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';
import '../components/set_low_balance_threshold_dialog.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  AppProvider appProvider;
  Widget flag;

  @override
  void initState() {
    super.initState();

    appProvider = Provider.of<AppProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: Container(
        margin: EdgeInsets.all(1.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
        ),
        child: ListView(
          children: <Widget>[
            _theme(),
            Divider(color: Colors.grey),
            _curreny(),
            Divider(color: Colors.grey),
            _lowBalanceThreshold(),
            Divider(color: Colors.grey),
            _clearAllData(),
            Divider(color: Colors.grey),
            _help(),
            Divider(color: Colors.grey),
            _credits(),
            Divider(color: Colors.grey),
            _donate(),
            Divider(color: Colors.grey)
          ],
        ),
      ),
    );
  }

  Widget _theme() {
    return ListTile(
      title: Text(
        'Theme',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        'Change the App Theme.',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
      trailing: Text(
        'DarkWhite',
        style: TextStyle(
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _help() {
    return ListTile(
      title: Text(
        'Help',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        'Checkout Frequently Asked Questions.',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _curreny() {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (context) => CurrencyChooserDialog(
              backgroundColor: Theme.of(context).backgroundColor,
              interfaceColor: Colors.white,
              selectedCurrency: (fl, value) {
                appProvider.currency = value;
                setState(() {
                  flag = fl;
                });
              },
            ),
          ),
          child: ListTile(
            title: Text(
              'Currency',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            subtitle: Text(
              'Select your currency.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                flag ?? Container(),
                SizedBox(width: 5.0),
                Text(
                  appProvider.currency,
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _credits() {
    return ListTile(
      title: Text(
        'Credits',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        'Who build this app?',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _donate() {
    return ListTile(
      title: Text(
        'Donate',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      subtitle: Text(
        'Make your contribution to support this app.',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    );
  }

  Widget _lowBalanceThreshold() {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) => SetLowBalanceThresholdDialog(),
      ),
      child: ListTile(
        title: Text(
          'Low Balance Threshold',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Show warning when low on balance.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
        trailing: Consumer<AppProvider>(
          builder: (context, value, child) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  '${appProvider.currency} ',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 10,
                  ),
                ),
                Text(
                  '${appProvider.lowBalanceThreshold}',
                  style: TextStyle(
                    color: Colors.green,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _clearAllData() {
    return InkWell(
      child: ListTile(
        title: Text(
          'Clear All Data',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        subtitle: Text(
          'Deletes all the Data. Proceed with Caution.',
          style: TextStyle(
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
