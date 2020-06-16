// import 'package:flutter/material.dart';
// import 'package:scoped_model/scoped_model.dart';

// import '../models/account.dart';
// import '../widgets/confirm_action_dialog.dart';
// import '../widgets/text_section.dart';
// import '../scoped_models/app_model.dart';

// class ConfirmAccountDeleteDialog extends StatelessWidget {
//   final Account account;

//   ConfirmAccountDeleteDialog(this.account);

//   @override
//   Widget build(BuildContext context) {
//     AppModel appModel = ScopedModel.of(context);

//     return ConfirmActionDialog(
//       //...
//       title: TextSection(
//         fontSizeOverride: 16.0,
//         fontWeightOverrride: FontWeight.bold,
//         textAlign: TextAlign.justify,
//         textEntries: [
//           TextEntry(
//             'Delete ',
//             letterSpacing: 1.0,
//             wordSpacing: 5.0,
//           ),
//           TextEntry(
//             '\'${account.name}\'',
//             color: Colors.red,
//             wordSpacing: 2.0,
//           ),
//           TextEntry(
//             ' ?',
//             wordSpacing: 5.0,
//           ),
//         ],
//       ),

//       //...
//       description: TextSection(
//         textAlign: TextAlign.justify,
//         textEntries: [
//           TextEntry(
//             'Warning: ',
//             color: Colors.red,
//             fontSize: 12.0,
//             fontWeight: FontWeight.bold,
//           ),
//           TextEntry(
//             'Account once deleted cannot be recovered. Pressing \'Delete\' will delete this account and all information associated with it. Please ensure that this is the account you want to delete.',
//             color: Colors.grey,
//             fontSize: 12.0,
//           ),
//         ],
//       ),

//       //...
//       actionButtons: <Widget>[
//         RaisedButton(
//           child: Text('Delete'),
//           colorBrightness: Brightness.dark,
//           color: Theme.of(context).buttonTheme.colorScheme.primary,
//           onPressed: () {
//             appModel.deleteAccount(account);
//             Navigator.pop(context, true);
//           },
//         ),
//         RaisedButton(
//           child: Text('Cancel'),
//           colorBrightness: Brightness.dark,
//           color: Theme.of(context).colorScheme.primary,
//           onPressed: () => Navigator.pop(context, false),
//         ),
//       ],
//     );
//   }
// }
