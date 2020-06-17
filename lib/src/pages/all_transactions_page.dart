import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/transaction_list_item.dart';
import '../providers/app_provider.dart';

class AllTransactionsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('All Transactions'),
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
