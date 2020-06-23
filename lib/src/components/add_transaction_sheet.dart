import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/app_provider.dart';

// void showAddTransactionSheet(BuildContext context) {
//   showBottomSheet(
//     context: context,
//     builder: (context) {
//       return _AddTransactionSheet();
//     },
//   );
// }

class AddTransactionSheet extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AddTransactionSheetState();
}

class _AddTransactionSheetState extends State<AddTransactionSheet> {
  AppProvider _appProvider;
  TextEditingController _amountEditingController, _descriptionEditingController;
  double _amountFieldWidth, _descriptionFieldWidth, optionButtonWidth;

  bool _showError = false;
  FocusNode _amountFocusNode;
  _ErrorType _errorType = _ErrorType.none;

  int selectedValue = 0;

  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _amountEditingController = TextEditingController();
    _descriptionEditingController = TextEditingController();

    _appProvider = Provider.of<AppProvider>(context, listen: false);

    _amountFocusNode = FocusNode();
  }

  @override
  Widget build(BuildContext context) {
    _amountFieldWidth = MediaQuery.of(context).size.width / 3.0;
    optionButtonWidth = MediaQuery.of(context).size.width / 3.4;

    // 2 times the amountFieldWidth.
    _descriptionFieldWidth = _amountFieldWidth * 1.97;

    return Container(
      height: _showError
          ? MediaQuery.of(context).size.height / 5
          : MediaQuery.of(context).size.height / 7,
      // margin: EdgeInsets.all(2.0),
      decoration: BoxDecoration(
        color: Theme.of(context).backgroundColor,
      ),
      child: Stack(
        children: <Widget>[
          _showError
              ? _error(
                  _errorType == _ErrorType.empty
                      ? 'Please Enter an Amount.'
                      : 'Amount Cannot be Zero.',
                )
              : Container(),
          _CustomizedTextFormField(
            width: _amountFieldWidth,

            // Position on top of the keyboard.
            bottom: MediaQuery.of(context).viewInsets.bottomLeft.dx + 5.0,
            label: 'Amount',
            textEditingController: _amountEditingController,
            onSubmitted: _onSubmitted,

            // Error disappears when typing starts.
            onChanged: (String value) {
              setState(() {
                _errorType = _ErrorType.none;
                _showError = false;
              });
            },
            focusNode: _amountFocusNode,
            autoFocus: true,
            keyboardType: TextInputType.number,
          ),
          _CustomizedTextFormField(
            width: _descriptionFieldWidth,

            // Position on top of the keyboard.
            bottom: MediaQuery.of(context).viewInsets.bottomLeft.dx + 5.0,

            // Position after the amountField.
            left: _amountFieldWidth,
            label: 'Description',
            textEditingController: _descriptionEditingController,
            onSubmitted: _onSubmitted,
          ),
          incomeExpenseSelection(),
          dateTimeSelection(),
        ],
      ),
    );
  }

  Positioned incomeExpenseSelection() {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottomLeft.dx + 60,
      child: Container(
        height: 40,
        width: optionButtonWidth * 1.66,
        padding: EdgeInsets.symmetric(horizontal: 5.0),
        margin: EdgeInsets.only(left: 5.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          children: <Widget>[
            selectionOption(
              label: 'Expense',
              position: 0,
              selected: selectedValue,
            ),
            selectionOption(
              label: 'Income',
              position: 1,
              selected: selectedValue,
            ),
          ],
        ),
      ),
    );
  }

  Widget selectionOption({
    String label,
    int selected = 0,
    int position = 0,
  }) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          Radio(
            visualDensity: VisualDensity.compact,
            onChanged: (value) {
              setState(() {
                selectedValue = value;
              });
            },
            value: position,
            groupValue: selected,
          ),
        ],
      ),
    );
  }

  Positioned dateTimeSelection() {
    return Positioned(
      bottom: MediaQuery.of(context).viewInsets.bottomLeft.dx + 60,
      width: MediaQuery.of(context).size.width - (optionButtonWidth * 1.74),
      left: optionButtonWidth * 1.65,
      child: Container(
        height: 40.0,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          border: Border.all(
            width: 0.5,
            color: Colors.grey,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: InkWell(
          onTap: () => showDatePicker(
            context: context,
            firstDate: DateTime(1984),
            lastDate: DateTime.now(),
            initialDate: DateTime.now(),
          ).then((value) {
            if (value != null) {
              setState(() {
                selectedDate = value;
              });
            }
          }),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Icon(Icons.date_range),
              ),
              Text(DateFormat('dd-MM-yyyy').format(selectedDate)),
            ],
          ),
        ),
      ),
    );
  }

  Positioned _error(String error) {
    return Positioned(
      width: MediaQuery.of(context).size.width,
      bottom: MediaQuery.of(context).viewInsets.bottomLeft.dx + 110.0,
      child: Center(
        child: Text(
          error,
          style: TextStyle(color: Colors.red, fontSize: 24.0),
        ),
      ),
    );
  }

  void _onSubmitted() {
    if (_amountEditingController.text.isEmpty) {
      setState(() {
        _errorType = _ErrorType.empty;
        _showError = true;

        // Set focus back to amountField.
        _amountFocusNode.requestFocus();
      });
    } else if (double.parse(_amountEditingController.text) == 0.0) {
      setState(() {
        _errorType = _ErrorType.zeroEntered;
        _showError = true;

        // Set focus back to amountField
        _amountFocusNode.requestFocus();
      });
    } else {
      if (selectedValue == 0) {
        _appProvider.addExpense(
          double.parse(_amountEditingController.text),
          description: _descriptionEditingController.text,
          date: selectedDate,
        );
      } else {
        _appProvider.addIncome(
          double.parse(_amountEditingController.text),
          description: _descriptionEditingController.text,
          date: selectedDate,
        );
      }
      Navigator.pop(context);
    }
  }
}

class _CustomizedTextFormField extends StatelessWidget {
  final double _height;
  final double _width;
  final double _top;
  final double _right;
  final double _bottom;
  final double _left;
  final TextEditingController _textEditingController;
  final Function _onSubmitted;
  final Function _onChanged;
  final String _label;
  final FocusNode _focusNode;
  final bool _autoFocus;
  final TextInputType _keyboardType;

  _CustomizedTextFormField({
    double height,
    double width,
    double top,
    double right,
    double bottom,
    double left,
    TextEditingController textEditingController,
    Function onSubmitted,
    Function onChanged,
    String label,
    FocusNode focusNode,
    bool autoFocus = false,
    TextInputType keyboardType,
  })  : _height = height,
        _width = width,
        _top = top,
        _right = right,
        _bottom = bottom,
        _left = left,
        _textEditingController = textEditingController,
        _onSubmitted = onSubmitted,
        _onChanged = onChanged,
        _label = label,
        _focusNode = focusNode,
        _autoFocus = autoFocus,
        _keyboardType = keyboardType;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      height: _height,
      width: _width,
      top: _top,
      right: _right,
      bottom: _bottom,
      left: _left,
      child: Container(
        height: 45,
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        margin: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[400], width: 0.4),
          borderRadius: BorderRadius.circular(5),
        ),
        child: TextField(
          focusNode: _focusNode,
          autofocus: _autoFocus,
          onSubmitted: (value) => _onSubmitted(),
          onChanged: _onChanged,
          controller: _textEditingController,
          keyboardType: _keyboardType,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: _label,
            hintStyle: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
            ),
          ),
          style: TextStyle(
              color: Theme.of(context).textTheme.bodyText1.color,
              fontFamily: 'Saira'),
        ),
      ),
    );
  }
}

enum _ErrorType {
  empty,
  zeroEntered,
  none,
}
