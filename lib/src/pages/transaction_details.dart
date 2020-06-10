// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// import '../models/transaction.dart';
// import '../scoped_models/app_model.dart';
// import '../widgets/icoxtbar.dart';

// class TransactionDetails extends StatelessWidget {
//   final Transaction transaction;

//   TransactionDetails(this.transaction);

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       children: <Widget>[
//         // Background is tapToDismiss, TransactionDetails area is not.
//         _dismissibleBackground(context),
//         Expanded(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               Material(
//                 color: Colors.transparent,
//                 child: Container(
//                   margin: EdgeInsets.symmetric(horizontal: 15.0),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(5.0),
//                   ),
//                   child: Column(
//                     children: <Widget>[
//                       _header(context),
//                       _body(context),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _dismissibleBackground(BuildContext context) {
//     return GestureDetector(
//       onTap: () => Navigator.pop(context),
//       child: Material(
//         color: Colors.transparent,
//       ),
//     );
//   }

//   Widget _header(BuildContext context) {
//     AppModel appModel = ScopedModel.of(context);

//     return Container(
//       decoration: BoxDecoration(
//         color: Theme.of(context).accentColor,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(5.0),
//           topRight: Radius.circular(5.0),
//         ),
//       ),
//       padding: const EdgeInsets.all(15.0),
//       child: Row(
//         children: <Widget>[
//           Expanded(
//             child: _amount(),
//           ),
//           _actionBar(appModel),
//         ],
//       ),
//     );
//   }

//   Widget _amount() {
//     return Row(
//       children: <Widget>[
//         Text(
//           '\$ ',
//           style: TextStyle(
//             fontSize: 24.0,
//             // fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         ),
//         SizedBox(width: 5.0),
//         Text(
//           '${transaction.amount}',
//           style: TextStyle(
//             fontSize: 24.0,
//             // fontWeight: FontWeight.bold,
//             color: Colors.black,
//           ),
//         )
//       ],
//     );
//   }

//   Widget _actionBar(AppModel appModel) {
//     return Row(
//       children: <Widget>[
//         //Todo: later...
//         _actionBarButton(
//           icon: Icon(Icons.repeat),
//           onPressed: () => print('Implement Me!'),
//         ),
//         _actionBarButton(
//           icon: Icon(Icons.delete),
//           onPressed: () => print('Implement Me!'),
//         ),
//       ],
//     );
//   }

//   Widget _actionBarButton({Icon icon, Function onPressed}) {
//     return InkWell(
//       onTap: onPressed,
//       child: Padding(
//         padding: const EdgeInsets.all(5.0),
//         child: Icon(
//           icon.icon,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }

//   Widget _body(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(),
//       padding: const EdgeInsets.all(15.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               transaction.description != null &&
//                       transaction.description.isNotEmpty
//                   ? _description()
//                   : Container(),
//             ],
//           ),
//           transaction.description != null && transaction.description.isNotEmpty
//               ? SizedBox(height: 10.0)
//               : Container(),
//           transaction.description != null && transaction.description.isNotEmpty
//               ? Divider()
//               : Container(),
//           _bottomBar(),
//         ],
//       ),
//     );
//   }

//   Widget _description() {
//     return Text(
//       '${transaction.description}',
//       style: TextStyle(),
//       softWrap: true,
//       textAlign: TextAlign.justify,
//     );
//   }

//   Widget _bottomBar() {
//     return IcoxtBarGroup(
//       items: [
//         IcoxtBar(
//           items: [
//             IcoxtBarItem(
//               icon: Icon(Icons.insert_chart),
//               text: '${transaction.typeAsString}',
//             ),
//             IcoxtBarItem(
//               icon: Icon(Icons.date_range),
//               text: '${transaction.date}',
//             ),
//             IcoxtBarItem(
//               icon: Icon(Icons.timer),
//               text: '${transaction.time}',
//             ),
//           ],
//         ),
//       ],
//     );
//   }
// }
