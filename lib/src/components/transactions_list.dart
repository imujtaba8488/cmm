import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/transaction_list_bar.dart';
import '../components/transaction_list_item.dart';
import '../providers/app_provider.dart';
import '../util/util';

class Transactionslist extends StatefulWidget {
  @override
  _TransactionslistState createState() => _TransactionslistState();
}

class _TransactionslistState extends State<Transactionslist> {
  DateTime dateSelected = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(
              width: 0.3,
              color: Colors.white,
            ),
          ),
          child: Column(
            children: <Widget>[
              TransactionBar(
                dateChanged: (value) => setState(() => dateSelected = value),
              ),
              Expanded(
                child:
                    appProvider.account.transactionsFor(dateSelected).length > 0
                        ? ListView.builder(
                            itemBuilder: buildList,
                            itemCount: appProvider.account.transactions.length,
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text(
                                  'No Transactions!',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Press the \'+\' button to add a transaction.',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12.0,
                                  ),
                                ),
                              ],
                            ),
                          ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildList(BuildContext context, int index) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return areDatesEqual(
          appProvider.account.sortedTransactions[index].date,
          dateSelected,
        )
            ? TransactionListItem(
                transaction: appProvider.account.sortedTransactions[index],
              )
            : Container();
      },
    );
  }
}
