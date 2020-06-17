import 'package:flutter/material.dart';

import '../pages/all_transactions_page.dart';

class BottomNavBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Theme.of(context).backgroundColor,
      shape: CircularNotchedRectangle(),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: 0.3,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            _item(context,
                icon: Icon(Icons.settings),
                label: 'Settings',
                onPressed: () {}),
            _item(context, icon: Icon(Icons.search), label: 'Transactions',
                onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AllTransactionsPage(),
                ),
              );
            }),
            _item(
              context,
              icon: null,
            ),
            _item(
              context,
              icon: Icon(Icons.change_history),
              label: 'Charts',
            ),
            _item(
              context,
              icon: Icon(Icons.access_alarm),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }

  Widget _item(
    BuildContext context, {
    Icon icon,
    String label,
    Function onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width / 6.0,
        padding: EdgeInsets.all(5.0),
        height: 50,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            icon != null ? icon : Container(),
            label != null
                ? FittedBox(
                    child: Text(
                      label,
                      style: TextStyle(fontSize: 10),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
