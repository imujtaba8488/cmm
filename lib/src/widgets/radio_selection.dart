import 'package:flutter/material.dart';

class OptionSelector extends StatefulWidget {
  final bool isEnabled;
  final initialValue;
  final Function valueSelected;

  OptionSelector({
    this.isEnabled = true,
    this.initialValue = 0,
    this.valueSelected,
  });

  @override
  _OptionSelectorState createState() => _OptionSelectorState();
}

class _OptionSelectorState extends State<OptionSelector> {
  int selectedValue;

  @override
  void initState() {
    super.initState();
    selectedValue = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        _option(
          label: 'Expense',
          position: 0,
          selected: selectedValue,
        ),
        _option(
          label: 'Income',
          position: 1,
          selected: selectedValue,
        ),
      ],
    );
  }

  Widget _option({
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

                      if (widget.valueSelected != null) {
                        widget.valueSelected(value);
                      }
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
