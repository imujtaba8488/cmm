import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/transaction_list_bar.dart';
import '../components/transaction_list_item.dart';
import '../providers/app_provider.dart';
import '../util/util';
import '../components/add_transaction_prompt.dart';
import '../models/transaction.dart';

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
                        : AddTransactionPrompt(),
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
                notifyTransactionDeleted: _onItemDeleted,
              )
            : Container();
      },
    );
  }

  void _onItemDeleted(Transaction transaction) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    Scaffold.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${transaction.type == TransactionType.income ? 'Income' : 'Expense'} transaction of amount ${appProvider.currency} ${transaction.amount} deleted',
        ),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
