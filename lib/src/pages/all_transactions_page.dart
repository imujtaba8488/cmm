import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/add_transaction_form.dart';
import '../components/transaction_list_item.dart';
import '../providers/app_provider.dart';
import '../util/util';
import '../components/add_transaction_prompt.dart';
import '../models/transaction.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      // backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text('All Transactions'),
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
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return appProvider.account.sortedTransactions.length > 0
              ? Container(
                  margin: const EdgeInsets.all(1.0),
                  child: ListView.builder(
                    itemBuilder: _buildList,
                    itemCount: appProvider.account.transactions.length,
                  ),
                )
              : AddTransactionPrompt();
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, int index) {
    // ! *** MUJTABA, WELL DONE! ***
    // * Requirement: Group List as per the transaction date.
    // ! Solution: Cleverly done! If index is 0, the first date is displayed. If index is greater than 0, than the date at the current index is compared with (index - 1) and if similar a Container is displayed and if not, the date separator is displayed, hence, grouping the transactions as per the transaction date.
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            index == 0
                ? _dateSeperator(index, appProvider)
                : areDatesEqual(
                        appProvider.account.sortedTransactions[index].date,
                        appProvider.account.sortedTransactions[index - 1].date)
                    ? Container()
                    : _dateSeperator(index, appProvider),
            TransactionListItem(
              transaction: appProvider.account.sortedTransactions[index],
              notifyTransactionDeleted: _onItemDeleted,
            )
          ],
        );
      },
    );
  }

  Widget _dateSeperator(int index, AppProvider appProvider) {
    DateFormat df = DateFormat('EEEE | dd MMMM, yyyy');

    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.white,
            width: 0.3,
          ),
        ),
      ),
      child: Row(
        children: <Widget>[
          Text(
            // '${DateFormat('dd-MM-yy').format(appProvider.account.sortedTransactions[index].date)}',
            '${df.format(appProvider.account.sortedTransactions[index].date)}',
            style: TextStyle(
              color: Colors.blue,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  void _onItemDeleted(Transaction transaction) {
    AppProvider appProvider = Provider.of<AppProvider>(context, listen: false);

    _scaffoldKey.currentState.showSnackBar(
      SnackBar(
        content: Text(
          '${transaction.type == TransactionType.income ? 'Income' : 'Expense'} transaction of amount ${appProvider.currency} ${transaction.amount} deleted',
        ),
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
