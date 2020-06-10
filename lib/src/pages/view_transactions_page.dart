// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// import '../models/account.dart';
// import '../components/account_selector.dart';
// import '../scoped_models/app_model.dart';
// import '../pages/add_transaction_page.dart';

// class ViewTransactionsPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return ViewTransactionsPageState();
//   }
// }

// class ViewTransactionsPageState extends State<ViewTransactionsPage> {
//   AppModel _appModel;
//   Account _accountSelected;
//   String _accountOptionSelected;

//   @override
//   void initState() {
//     super.initState();
//     _appModel = ScopedModel.of(context);

//     // Select First account, if one is available.
//     if (_appModel.accounts.length > 0) {
//       _accountSelected = _appModel.accounts.first;
//     }

//     _accountOptionSelected = _accountSelected?.name;
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         child: Icon(Icons.add),
//         onPressed: () => showDialog(
//             context: context,
//             builder: (context) {
//               return AddTransactionPage.expenseMode();
//             }),
//       ),
//       appBar: AppBar(
//         title: Text('View Transactions'),
//       ),
//       body: Column(
//         children: <Widget>[
//           Container(
//             //padding is temp:
//             padding: EdgeInsets.all(15.0),
//             child: AccountSelector(
//               accounts: _appModel.accounts,
//               optionSelected: _accountOptionSelected,
//               onAddAccountPressed: _addAccountPressed,
//               showAddAccountButton: false,
//               onChanged: (value) {
//                 setState(() {
//                   _accountSelected = _appModel.getAccount(value);
//                   _accountOptionSelected = value;
//                 });
//               },
//             ),
//           ),

//           // Show msg when no transaction exists.
//           _accountSelected != null
//               ? _accountSelected.totalTransactions > 0
//                   ? Expanded(
//                       child: _transactionList(),
//                     )
//                   : Center(
//                       child: Text('No Transactions!'),
//                     )
//               : Container(),
//         ],
//       ),
//     );
//   }

//   Widget _transactionList() {
//     return ListView.builder(
//       itemBuilder: _transaction,
//       itemCount: _accountSelected.totalTransactions,
//     );
//   }

//   Widget _transaction(BuildContext context, int index) {
//     return Dismissible(
//       // Review: Replace key with accountId later on.
//       key: Key('${_accountSelected.transactions[index].time}'),
//       direction: DismissDirection.startToEnd,
//       onDismissed: (dismissDirection) {
//         if (dismissDirection == DismissDirection.startToEnd) {
//           setState(() {
//             _appModel.deleteTransaction(_accountSelected, index);
//           });
//         } else {
//           print('todo'); //temp:
//         }
//       },
//       child: ListTile(
//         leading: Text('${_accountSelected.transactions[index].date}'),
//         title: Text(
//           '${_accountSelected.transactions[index].amount}',
//           style: TextStyle(
//             fontSize: 18,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         subtitle: Text('${_accountSelected.transactions[index].description}'),
//         trailing: Text('${_accountSelected.transactions[index].typeAsString}'),
//       ),
//     );
//   }

//   void _addAccountPressed() {
//     // Though this page doesn't display 'Add Account' button in the Account-
//     // Selector dropdown. However, if there are no accounts to display, an
//     // AddAccount option is displayed. This function is then invoked.
//     Navigator.pushNamed(context, 'add_account_page').then((value) {
//       if (value) {
//         setState(() {
//           _accountSelected = _appModel.accounts.last;
//           _accountOptionSelected = _appModel.accounts.last.name;
//         });
//       }
//     });
//   }
// }
