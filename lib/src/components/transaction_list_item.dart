import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../components/transaction_details_dialog.dart';
import '../providers/app_provider.dart';

class TransactionListItem extends StatelessWidget {
  final Transaction transaction;

  TransactionListItem({@required this.transaction});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => showDialog(
        context: context,
        builder: (context) {
          return TransactionDetailsDialog(transaction);
        },
      ),
      child: Dismissible(
        key: Key('${transaction.id}'),
        child: Card(
          elevation: 10,
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            leading: transaction.type == TransactionType.income
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                    ),
                    padding: EdgeInsets.all(10),
                    child: Column(children: <Widget>[
                      Text(
                        'Income',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_upward,
                        size: 16,
                      )
                    ]),
                  )
                : Container(
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(4.0),
                        bottomLeft: Radius.circular(4.0),
                      ),
                    ),
                    padding: EdgeInsets.all(8),
                    child: Column(children: <Widget>[
                      Text(
                        'Expense',
                        style: TextStyle(
                          fontSize: 10.0,
                        ),
                      ),
                      Icon(
                        Icons.arrow_downward,
                        size: 16,
                      ),
                    ]),
                  ),
            title: Padding(
              padding: EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Amount',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                    ),
                  ),
                  FittedBox(child: Consumer<AppProvider>(
                      builder: (context, appProvider, child) {
                    return Row(
                      children: <Widget>[
                        Text(
                          '${appProvider.currency}',
                          style: TextStyle(
                            color: transaction.type == TransactionType.income
                                ? Colors.blue
                                : Colors.red,
                            fontSize: 10.0,
                          ),
                        ),
                        SizedBox(width: 5.0),
                        Text(
                          '${transaction.amount}',
                          style: TextStyle(
                            color: transaction.type == TransactionType.income
                                ? Colors.blue
                                : Colors.red,
                          ),
                        ),
                      ],
                    );
                  })),
                ],
              ),
            ),
            trailing: Container(
              width: MediaQuery.of(context).size.width / 2.0,
              padding: const EdgeInsets.all(8.0),
              child: Text(
                transaction.description,
                style: TextStyle(
                  color: Colors.blueGrey,
                  fontSize: 12,
                  fontFamily: 'Saira',
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
