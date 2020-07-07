import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/app_dialog.dart';
import '../providers/app_provider.dart';

class SetLowBalanceThresholdDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          TextFormField(
            autofocus: true,
            decoration: InputDecoration(
              labelText: 'Low Balance Threshold',
              labelStyle: TextStyle(
                color: Colors.green,
              ),
            ),
            style: TextStyle(
              color: Colors.white,
            ),
            keyboardType: TextInputType.number,
            onFieldSubmitted: (value) {
              AppProvider appProvider =
                  Provider.of<AppProvider>(context, listen: false);

              appProvider.lowBalanceThreshold = double.parse(value);

              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
