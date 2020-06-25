import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/transaction_details_dialog.dart';
import '../models/transaction.dart';
import '../providers/app_provider.dart';
import '../components/confirm_delete_transaction_alert.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;
  final bool showTitles;
  final Function notifyTransactionDeleted;

  TransactionListItem({
    @required this.transaction,
    this.showTitles = true,
    this.notifyTransactionDeleted,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<AppProvider>(builder: (context, appProvider, child) {
      return Dismissible(
        key: Key('${transaction.id}'),
        confirmDismiss: (direction) {
          return showDialog(
            context: context,
            builder: (context) => DeleteTransactionDialog(),
          );
        },
        onDismissed: (direction) {
          appProvider.deleteTransaction(transaction);

          if (notifyTransactionDeleted != null) {
            notifyTransactionDeleted(transaction);
          }
        },
            
        child: InkWell(
          onTap: () => showDialog(
            context: context,
            builder: (context) => TransactionDetailsDialog(transaction),
          ),
          child: Container(
            height: MediaQuery.of(context).size.height / 12,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.blueGrey,
                  blurRadius: 1,
                  // offset: Offset(1, 1),
                )
              ],
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Row(
              children: <Widget>[
                transaction.type == TransactionType.income
                    ? _indicator(
                        'Income',
                        context,
                        icon: Icon(Icons.arrow_upward),
                      )
                    : _indicator(
                        'Expense',
                        context,
                        icon: Icon(Icons.arrow_downward),
                        backgroundColor: Colors.red,
                      ),
                Expanded(
                  child: _amount(appProvider, context),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  flex: 2,
                  child: _description(appProvider),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }

  Widget _amount(AppProvider appProvider, BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTitles
              ? Text(
                  'Amount',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8,
                  ),
                )
              : Container(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  '${appProvider.currency}',
                  style: TextStyle(
                    color: transaction.type == TransactionType.income
                        ? Colors.blue
                        : Colors.red,
                    fontSize: 9.0,
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  child: FittedBox(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '${transaction.amount}',
                          style: TextStyle(
                            color: transaction.type ==
                                    TransactionType.income
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _description(AppProvider appProvider) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          showTitles
              ? Text(
                  'Description',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 8,
                  ),
                )
              : Container(),
          showTitles
              ? Expanded(
                  child: Text(
                    '${transaction.description}',
                    style: TextStyle(
                      color: Colors.blueGrey,
                      fontSize: 12,
                    ),
                  ),
                )
              : Text(
                  '${transaction.description}',
                  style: TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 12,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
        ],
      ),
    );
  }

  Widget _indicator(
    String label,
    BuildContext context, {
    Icon icon,
    Color backgroundColor = Colors.blue,
  }) {
    return Container(
      padding: EdgeInsets.all(5.0),
      width: MediaQuery.of(context).size.width / 10,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(5.0),
          bottomLeft: Radius.circular(5.0),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          FittedBox(child: Text(label)),
          icon != null ? icon : Container(),
        ],
      ),
    );
  }
}
