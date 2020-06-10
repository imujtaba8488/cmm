// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// import '../pages/transaction_details.dart';
// import '../scoped_models/app_model.dart';

// enum DepthSide {
//   up,
//   down,
//   bothUpDown,
//   left,
//   right,
//   bothLeftRight,
//   all,
// }

// class RecentTransactionsList extends StatelessWidget {
//   final DepthSide depthSide;

//   RecentTransactionsList({this.depthSide = DepthSide.up});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       // padding: EdgeInsets.fromLTRB(2.0, 0.0, 2.0, 2.0),
//       child: _contents(context),
//     );
//   }

//   Widget _contents(BuildContext context) {
//     AppModel appModel = ScopedModel.of(context);

//     return appModel.recentTransactions.length > 0
//         ? Container(
//             height: 20.0,
//             decoration: BoxDecoration(
//                 // color: Colors.blueGrey.shade100,
//                 // borderRadius: BorderRadius.circular(2.0),
//                 ),
//             child: ListView.builder(
//               scrollDirection: Axis.horizontal,
//               // itemExtent: MediaQuery.of(context).size.height,
//               itemBuilder: (context, index) => RecentTransactionsTapCard(index),
//               itemCount: appModel.recentTransactions.length,
//               // itemCount: appModel.totalAccounts,
//             ),
//           )

//         // Row only exists, so that the button can be aligned at the center.
//         : Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Text(
//                 'Recent Transactions will appear here, as soon as you add them.',
//                 style: TextStyle(
//                   color: Colors.grey.shade400,
//                   fontSize: 10.0,
//                 ),
//               )
//             ],
//           );
//   }
// }

// class RecentTransactionsTapCard extends StatelessWidget {
//   final int index;

//   RecentTransactionsTapCard(this.index);

//   @override
//   Widget build(BuildContext context) {
//     AppModel appModel = ScopedModel.of(context);

//     return InkWell(
//       onTap: () => showDialog(
//           context: context,
//           builder: (context) {
//             return TransactionDetails(appModel.recentTransactions[index]);
//           }),
//       child: Container(
//         margin: EdgeInsets.all(4.0),
//         padding: EdgeInsets.symmetric(horizontal: 5.0),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(2.0),
//           color: Colors.deepOrange,
//           // color: Colors.yellow,
//           // color: Colors.grey,
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey,
//               // blurRadius: 2.0,
//               // spreadRadius: 50,
//               // offset: Offset(0.5, 0.5),
//             )
//           ],
//         ),
//         child: Center(
//           child: Text(
//             appModel.recentTransactions[index].amount.toString(),
//             style: TextStyle(color: Colors.white, fontSize: 8.0),
//           ),
//         ),
//       ),
//     );
//   }
// }
