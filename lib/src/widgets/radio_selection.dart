import 'package:flutter/material.dart';

class OptionSelector extends StatefulWidget {
  final bool isEnabled;

  OptionSelector({this.isEnabled = true});

  @override
  _OptionSelectorState createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  int selectedValue = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
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
              color: widget.isEnabled ? Colors.white : Colors.grey,
            ),
          ),
          Radio(
            activeColor: Colors.white,
            visualDensity: VisualDensity.compact,
            onChanged: widget.isEnabled
                ? (value) {
                    setState(() {
                      selectedValue = value;
                    });
                  }
                : (value) {},
            value: position,
            groupValue: selected,
          ),
        ],
      ),
    );
  }
}
