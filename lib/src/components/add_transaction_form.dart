import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/date_selector.dart';
import '../widgets/radio_selection.dart';
import '../providers/app_provider.dart';

/// Typically shown within a ModalBottomSheet.
class AddTransactionForm extends StatefulWidget {
  @override
  _AddTransactionFormState createState() => _AddTransactionFormState();
}

class _AddTransactionFormState extends State<AddTransactionForm> {
  int _optionSelected;
  DateTime _dateSelected;
  GlobalKey<FormState> _formKey = GlobalKey();
  FocusNode _focusNode;
  double _amount;
  String _description;
  AppProvider _appProvider;

  @override
  void initState() {
    super.initState();

    _optionSelected = 0;
    _dateSelected = DateTime.now();
    _focusNode = FocusNode();
    _amount = 0.0;
    _description = '';
  }

  @override
  Widget build(BuildContext context) {
    _appProvider = Provider.of<AppProvider>(context, listen: false);

    return Container(
      padding: MediaQuery.of(context).viewInsets,
      margin: EdgeInsets.all(15.0),
      child: Wrap(
        children: <Widget>[
          Form(
            key: _formKey,
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextFormField(
                    validator: (String value) {
                      if (value.isEmpty) {
                        return '*Required';
                      } else if (double.parse(value) == 0.0) {
                        return '*Cannot be zero';
                      } else {
                        return null;
                      }
                    },
                    onFieldSubmitted: (String value) => _onSaved(),
                    onSaved: (String value) => _amount = double.parse(value),
                    focusNode: _focusNode,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 5.0),
                Expanded(
                  flex: 2,
                  child: TextFormField(
                    keyboardType: TextInputType.text,
                    onFieldSubmitted: (String value) => _onSaved(),
                    onSaved: (String value) => _description = value,
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: TextStyle(
                        color: Colors.white,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(),
                      ),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: FittedBox(
                    child: OptionSelector(
                      initialValue: _optionSelected,
                      valueSelected: (int option) {
                        _optionSelected = option;
                      },
                    ),
                  ),
                ),
                FittedBox(
                  child: DateSelector(
                    showNextPreviouslabels: false,
                    dateSelected: (DateTime value) {
                      _dateSelected = value;
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onSaved() {
    if (_formKey.currentState.validate()) {
      _formKey.currentState.save();

      _optionSelected == 0
          ? _appProvider.addExpense(
              _amount,
              description: _description,
              date: _dateSelected,
            )
          : _appProvider.addIncome(
              _amount,
              description: _description,
              date: _dateSelected,
            );

      Navigator.pop(context);
    } else {
      _focusNode.requestFocus();
    }
  }
}
