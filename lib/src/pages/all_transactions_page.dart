import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/add_transaction_form.dart';
import '../components/transaction_list_item.dart';
import '../providers/app_provider.dart';

class AllTransactionsPage extends StatefulWidget {
  @override
  _AllTransactionsPageState createState() => _AllTransactionsPageState();
}

class _AllTransactionsPageState extends State<AllTransactionsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          return ListView.builder(
            itemBuilder: _buildList,
            itemCount: appProvider.account.transactions.length,
          );
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, int index) {
    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        return TransactionListItem(
          transaction: appProvider.account.sortedTransactions[index],
        );
      },
    );
  }
}
