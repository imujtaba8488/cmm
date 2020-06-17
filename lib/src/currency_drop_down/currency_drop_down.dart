import 'package:flutter/material.dart';

import './countries.dart';

class CurrencyDropDown extends StatefulWidget {
  final Function onSelected;

  CurrencyDropDown({this.onSelected});

  @override
  _CurrencyDropDownState createState() => _CurrencyDropDownState();
}

class _CurrencyDropDownState extends State<CurrencyDropDown> {
  String currency = 'USD';
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      padding: EdgeInsets.zero,
      
      color: Colors.blueGrey[900],
      onSelected: (value) {
        setState(() {
          currency = value;

          if (widget.onSelected != null) {
            widget.onSelected(currency);
          }
        });
      },
      child: Container(
        width: 50,
        decoration: BoxDecoration(
          color: Colors.green,
          border: Border.all(color: Colors.white),
          borderRadius: BorderRadius.circular(50.0),
        ),
        padding: EdgeInsets.all(10.0),
        margin: EdgeInsets.all(10.0),
        child: Center(
          child: Text('$currency'),
        ),
      ),
      itemBuilder: (context) {
        return currencyCodesSorted().map((currency) {
          return PopupMenuItem(
            height: 25,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  child: Text(
                    '$currency',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
            value: currency,
          );
        }).toList();
      },
    );
  }
}
