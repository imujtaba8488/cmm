import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../widgets/radio_selection.dart';
import '../widgets/date_selector.dart';
import '../providers/app_provider.dart';

class TransactionDetailsPage extends StatefulWidget {
  final Transaction transaction;

  TransactionDetailsPage(this.transaction);

  @override
  _TransactionDetailsPageState createState() => _TransactionDetailsPageState();
}

class _TransactionDetailsPageState extends State<TransactionDetailsPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController amountFieldController, descriptionFieldController;
  bool isEditingEnabled = false;
  DateTime dateSelected;

  @override
  void initState() {
    super.initState();

    amountFieldController = TextEditingController(
      text: '${widget.transaction.amount}',
    );

    descriptionFieldController = TextEditingController(
      text: '${widget.transaction.description}',
    );

    dateSelected = widget.transaction.date;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Theme.of(context).backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height / 2.5,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.white,
            width: (1.5),
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: <Widget>[
            isEditingEnabled
                ? Container(
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      'Tap \'Save\' to save the Transaction.',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.all(5.0),
                    child: Text(
                      'Tap \'Edit\' to edit the Transaction.',
                      style: TextStyle(
                        fontSize: 10.0,
                      ),
                    ),
                  ),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5.0),
                        margin: EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.white,
                              width: isEditingEnabled ? 0.3 : 0.1),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        width: MediaQuery.of(context).size.width / 2.1,
                        child: OptionSelector(
                          isEnabled: isEditingEnabled,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(100.0),
                          border: Border.all(color: Colors.white),
                        ),
                        padding: const EdgeInsets.all(10.0),
                        margin: const EdgeInsets.all(5.0),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              isEditingEnabled = !isEditingEnabled;
                              if (isEditingEnabled == false) {
                                _onSaved();
                              }
                            });
                          },
                          child: Row(
                            children: <Widget>[
                              Text(isEditingEnabled ? 'Save' : 'Edit'),
                              SizedBox(width: 5.0),
                              Icon(isEditingEnabled ? Icons.save : Icons.edit),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5.0),
                  Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: _customizedTextFormField(
                        label: 'Amount',
                        textEditingController: amountFieldController,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: _customizedTextFormField(
                      label: 'Description',
                      textEditingController: descriptionFieldController,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: isEditingEnabled
                          ? Border.all(color: Colors.white, width: 0.3)
                          : Border.all(color: Colors.white, width: 0.1),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        DateSelector(
                          currentDate: widget.transaction.date,
                          isEnabled: isEditingEnabled,
                          dateSelected: (value) {
                            setState(() {
                              dateSelected = value;
                            });
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _customizedTextFormField({
    @required String label,
    @required TextEditingController textEditingController,
  }) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isEditingEnabled ? Colors.white : Colors.grey,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.1),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white, width: 0.3),
        ),
      ),
      controller: textEditingController,
      enabled: isEditingEnabled,
      style: TextStyle(color: isEditingEnabled ? Colors.white : Colors.grey),
    );
  }

  void _onSaved() {
    if (_formKey.currentState.validate()) {
      AppProvider appProvder = Provider.of<AppProvider>(context, listen: false);

      final double amount = double.parse(amountFieldController.text);
      final String description = descriptionFieldController.text;

      Transaction xTransaction =
          widget.transaction.type == TransactionType.income
              ? Transaction.income(
                  amount,
                  description: description,
                  date: dateSelected,
                  id: widget.transaction.id,
                )
              : Transaction.income(
                  amount,
                  description: description,
                  date: dateSelected,
                  id: widget.transaction.id,
                );

      appProvder.updateTransaction(widget.transaction, xTransaction);

      Navigator.pop(context);
    }
  }
}
