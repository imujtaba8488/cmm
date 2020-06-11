import 'package:custom_widgets/animated_containers/zoom_in.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../components/add_transaction_sheet.dart';
import '../scoped_models/app_provider.dart';
import '../components/transactions_list.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  double topHeight;
  double bottomHeight;

  @override
  Widget build(BuildContext context) {
    topHeight = MediaQuery.of(context).size.height / 2.5;
    bottomHeight = MediaQuery.of(context).size.height - (topHeight + 24);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => showAddTransactionSheet(context),
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: <Widget>[
            _top(context),
            Expanded(
              // height: bottomHeight,
              child: Transactionslist(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _top(BuildContext context) {
    return Container(
      height: topHeight,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: const Color(0xFF02072F),
        borderRadius: BorderRadius.only(
            // bottomLeft: Radius.circular(30),
            // bottomRight: Radius.circular(30),
            ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          _avatar(context),
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Balance',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  Consumer<AppProvider>(
                    builder: (context, appProvider, child) {
                      return ZoomIn(
                        duration: 200,
                        child: Text(
                          '\$ ${appProvider.account.balance}',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _avatar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Icon(Icons.menu),
          Row(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5.0),
                child: Text(
                  'Welcome Back Mujtaba!',
                  style: TextStyle(fontSize: 10.0),
                ),
              ),
              CircleAvatar(
                backgroundColor: Colors.white,
                radius: 20,
                backgroundImage: AssetImage('assets/test.jpg'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
