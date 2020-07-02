import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/transaction.dart';
import '../providers/app_provider.dart';
import '../widgets/date_selector.dart';
import '../widgets/radio_selection.dart';
import '../components/custom_button.dart';

class TransactionDetailsDialog extends StatefulWidget {
  final Transaction transaction;

  TransactionDetailsDialog(this.transaction);

  @override
  _TransactionDetailsDialogState createState() =>
      _TransactionDetailsDialogState();
}

class _TransactionDetailsDialogState extends State<TransactionDetailsDialog> {
  GlobalKey<FormState> _formKey = GlobalKey();
  TextEditingController amountFieldController, descriptionFieldController;
  bool isEditingEnabled = false;
  DateTime dateSelected;
  int valueSelected;

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

    valueSelected = widget.transaction.type == TransactionType.expense ? 0 : 1;
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
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Column(
          children: <Widget>[
            isEditingEnabled
                ? Container(
                    margin: EdgeInsets.all(5.0),
                    child: _helpText('Tap \'Save\' to save the Transaction.'),
                  )
                : Container(
                    margin: EdgeInsets.all(5.0),
                    child: _helpText('Tap \'Edit\' to edit the Transaction.'),
                  ),
            _form(),
          ],
        ),
      ),
    );
  }

  Form _form() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              _customizedOptionSelector(),
              Expanded(
                child: _editSaveButton(),
              ),
            ],
          ),
          SizedBox(height: 5.0),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _customizedTextFormField(
              label: 'Amount',
              textEditingController: amountFieldController,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: _customizedTextFormField(
              label: 'Description',
              textEditingController: descriptionFieldController,
            ),
          ),
          _customizedDateSelector(),
        ],
      ),
    );
  }

  Widget _editSaveButton() {
    return CustomButton(
      icon: Icon(isEditingEnabled ? Icons.save : Icons.edit),
      child: Text(isEditingEnabled ? 'Save' : 'Edit'),
      onPressed: () {
        setState(() {
          isEditingEnabled = !isEditingEnabled;
          if (isEditingEnabled == false) {
            _onSaved();
          }
        });
      },
    );
  }

  Widget _customizedOptionSelector() {
    return Container(
      padding: EdgeInsets.all(5.0),
      margin: EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.white,
          width: isEditingEnabled ? 0.3 : 0.1,
        ),
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: OptionSelector(
        initialValue: valueSelected,
        isEnabled: isEditingEnabled,
        valueSelected: (value) {
          setState(() {
            valueSelected = value;
          });
        },
      ),
    );
  }

  Widget _customizedDateSelector() {
    return Container(
      margin: EdgeInsets.all(5.0),
      padding: EdgeInsets.all(8.0),
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

      TransactionType transactionType =
          valueSelected == 0 ? TransactionType.expense : TransactionType.income;

      Transaction transaction = transactionType == TransactionType.income
          ? Transaction.income(
              amount,
              description: description,
              date: dateSelected,
              id: widget.transaction.id,
            )
          : Transaction.expense(
              amount,
              description: description,
              date: dateSelected,
              id: widget.transaction.id,
            );

      appProvder.updateTransaction(
        original: widget.transaction,
        replacement: transaction,
      );

      Navigator.pop(context);
    }
  }

  Text _helpText(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 10.0,
      ),
    );
  }
}
