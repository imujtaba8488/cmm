// import 'package:cmm/src/scoped_models/app_provider.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:scoped_model/scoped_model.dart';

// import '../components/confirm_account_delete_dialog.dart';
// import '../components/x_close_button.dart';
// import '../models/account.dart';
// import '../pages/add_transaction_page.dart';
// import '../scoped_models/app_model.dart';
// import '../widgets/go_tab_bar.dart';
// import '../widgets/section.dart';

// class AccountDetailsPage extends StatefulWidget {
//   final Account _account;

//   AccountDetailsPage(this._account);

//   @override
//   State<StatefulWidget> createState() {
//     return _AccountDetailsPageState();
//   }
// }

// class _AccountDetailsPageState extends State<AccountDetailsPage> {
//   AppProvider appProvider;
//   ScrollController scrollController;

//   @override
//   void initState() {
//     super.initState();
//     appProvider = Provider.of<AppProvider>(context, listen: false);
//     scrollController = ScrollController();
//   }

//   @override
//   Widget build(BuildContext context) {
//     // Enclosed within ScopedModel, because when the transaction is added on
//     // the AddTransactionSheet, this rebuilds because of the change in appModel.
//     return Consumer<AppProvider>(
//       builder: (context, provider, child) {
//         return Scaffold(
//           appBar: AppBar(
//             title: Text(
//               '${widget._account.name}',
//               style: TextStyle(
//                 fontWeight: FontWeight.normal,
//                 color: Colors.black,
//               ),
//             ),
//             automaticallyImplyLeading: false,
//             // backgroundColor: Colors.blueGrey.shade700,
//             actions: <Widget>[
//               _buttonPallete(context),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 15.0),
//                 child: VerticalDivider(color: Colors.yellow),
//               ),
//               Padding(
//                 padding: const EdgeInsets.only(left: 5.0, right: 10.0),
//                 child: XCloseButton(),
//               ),
//             ],
//           ),
//           floatingActionButton: FloatingActionButton(
//             child: Icon(Icons.add),
//             onPressed: () => showDialog(
//               context: context,
//               builder: (context) {
//                 return AddTransactionPage.expenseMode(
//                   optionSelected: widget._account.name,
//                   showAddAccountButton: false,
//                 );
//               },
//             ),
//           ),
//           body: ListView(
//             controller: scrollController,
//             children: <Widget>[
//               GoTabBar(
//                 height: MediaQuery.of(context).size.height / 2.0,
//                 tabHeight: 20.0,
//                 marginAround: EdgeInsets.all(2.0),
//                 tabBarMargin: EdgeInsets.only(bottom: 2.0),
//                 disableShadow: true,
//                 tabs: [
//                   GoTab(
//                     title: Text('Overview'),
//                     // icon: Icon(Icons.trending_up, color: Colors.black, size: 14,),
//                     icon: Icon(
//                       Icons.insert_chart,
//                     ),
//                     // child: IEBSpecificChart(widget._account),
//                   ),
//                   GoTab(
//                     title: Text('Forecast'),
//                     icon: Icon(Icons.trending_up),
//                   ),
//                 ],
//               ),
//               Section(
//                 title: 'Summary',
//                 child: DetailsTable(widget._account),
//               ),
//               Section(
//                 title: 'Transactions',
//                 child: _transactionList(),
//               ),
//             ],
//           ),
//         );
//       },
//     );
//   }

//   Widget _transactionList() {
//     return Container(
//       // margin: EdgeInsets.all(8.0),

//       // Height here is very important. It controls how much space will the list
//       // eventually hold. Also, an important thing to note here is that it
//       // controls scrolling of list in such a way, so that only the account name
//       // remains visible along the top - recall: like something you have on your
//       // new Samsung Phone.
//       height: MediaQuery.of(context).size.height / 1.3,
//       // child: ListView.builder(
//       //   itemBuilder: (context, index) {
//       //     return InkWell(
//       //       onTap: () => showDialog(
//       //           context: context,
//       //           builder: (context) {
//       //             return TransactionDetails(
//       //               widget._account.transactions[index],
//       //             );
//       //           }),
//       //       child: TransactionListItem(
//       //         transaction: widget._account.transactions[index],
//       //         onDismissed: (dismissDirection) {
//       //           if (dismissDirection == DismissDirection.startToEnd) {
//       //             setState(() {
//       //               _appModel.deleteTransaction(widget._account, index);
//       //             });
//       //           } else {
//       //             print('todo'); //temp:
//       //           }
//       //         },
//       //       ),
//       //     );
//       //   },
//       //   itemCount: widget._account.transactions.length,
//       // ),
//     );
//   }

//   Widget _buttonPallete(BuildContext context) {
//     return Row(
//       children: <Widget>[
//         Padding(
//           padding: const EdgeInsets.only(right: 15.0),
//           child: Icon(
//             Icons.edit,
//             // color: Colors.lightGreenAccent,
//             color: Colors.white,
//             // size: 24,
//           ),
//         ),
//         Padding(
//           padding: const EdgeInsets.only(right: 10.0),
//           child: InkWell(
//             onTap: () {
//               showDialog(
//                 context: context,
//                 builder: (context) {
//                   return ConfirmAccountDeleteDialog(widget._account);
//                 },
//               ).then((onValue) {
//                 if (onValue) {
//                   Navigator.pop(context);
//                 }
//               });
//             },
//             child: Icon(
//               Icons.delete,
//               color: Colors.white,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }

// class DetailsTable extends StatelessWidget {
//   final Account account;

//   DetailsTable(this.account);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 20.0),
//         child: Table(
//           border: TableBorder(
//             horizontalInside: BorderSide(
//               width: 0.5,
//               color: Colors.blueGrey.shade100,
//             ),
//             bottom: BorderSide(
//               width: 0.5,
//               color: Colors.blueGrey.shade100,
//             ),
//           ),
//           children: [
//             _singleItemTableRow(
//               'Current Balance',
//               '${account.balance}',
//               dataColor: Colors.blue,
//             ),
//             _singleItemTableRow(
//               'Total Income',
//               '${account.totalIncome}',
//             ),
//             _singleItemTableRow(
//               'Total Expenses',
//               '${account.totalExpenses}',
//               dataColor: Colors.red,
//             ),
//             _singleItemTableRow(
//               'Total Transactions',
//               '${account.totalTransactions}',
//             ),
//             _singleItemTableRow(
//               'Income Transactions',
//               '${account.incomeTransactionsCount}',
//             ),
//             _singleItemTableRow(
//               'Expense Transactions',
//               '${account.expenseTransactionsCount}',
//               dataColor: Colors.red,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   TableRow _singleItemTableRow(
//     final String label,
//     final String data, {
//     final Color dataColor,
//   }) {
//     return TableRow(
//       children: [
//         Padding(
//           padding: const EdgeInsets.only(
//             top: 8.0,
//             right: 8.0,
//             bottom: 8.0,
//           ),
//           child: Text(
//             label,
//             style: TextStyle(
//               fontSize: 16.0,
//             ),
//           ),
//         ),
//         Container(
//           alignment: Alignment.centerRight,
//           padding: const EdgeInsets.only(
//             top: 8.0,
//             right: 8.0,
//             bottom: 8.0,
//           ),
//           child: Text(
//             data,
//             style: TextStyle(
//               color: dataColor,
//               fontSize: 16.0,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
