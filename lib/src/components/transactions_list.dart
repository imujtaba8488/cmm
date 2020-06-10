import 'package:cmm/src/widgets/go_family/go_family.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../scoped_models/app_provider.dart';

class Transactionslist extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return ListView.builder(
          itemBuilder: listBuilder,
          itemCount: appProvider.account.transactions.length,
        );
      },
    );
  }

  Widget listBuilder(BuildContext context, int index) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            appProvider.account.transactions[index].amount == 5000.0
                ? Container(
                    width: MediaQuery.of(context).size.width,
                    color: Colors.green,
                    padding: EdgeInsets.symmetric(
                      horizontal: 5.0,
                      vertical: 5.0,
                    ),
                    child: Text('Yesterday'),
                  )
                : Container(),
            ListTile(
              title: Text(
                appProvider.account.transactions[index].amount.toString(),
              ),
              subtitle: Text(
                appProvider.account.transactions[index].description,
              ),
              trailing: Text(
                appProvider.account.transactions[index].date.toString(),
              ),
            )
          ],
        );
      },
    );
  }
}
