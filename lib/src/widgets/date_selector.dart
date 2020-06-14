import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateSelector extends StatefulWidget {
  final DateTime currentDate;
  final Function dateSelected;
  final bool isEnabled;

  DateSelector({this.currentDate, this.dateSelected, this.isEnabled = true});

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime dateSelected;

  @override
  void initState() {
    super.initState();
    dateSelected =
        widget.currentDate != null ? widget.currentDate : DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: widget.isEnabled
                  ? () {
                      setState(() {
                        dateSelected = dateSelected.subtract(
                          Duration(days: 1),
                        );
                      });

                      if (widget.dateSelected != null) {
                        widget.dateSelected(dateSelected);
                      }
                    }
                  : null,
              child: Row(
                children: <Widget>[
                  Icon(
                    Icons.arrow_left,
                    color: widget.isEnabled ? Colors.white : Colors.grey,
                  ),
                  Text(
                    'Previous',
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isEnabled ? Colors.white : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '${DateFormat('dd-MM-yyyy').format(dateSelected)}',
              style: TextStyle(
                // fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.isEnabled ? Colors.white : Colors.grey,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: widget.isEnabled
                  ? () {
                      if (dateSelected.day <= DateTime.now().day - 1 &&
                          dateSelected.month <= DateTime.now().month &&
                          dateSelected.year <= DateTime.now().year) {
                        setState(() {
                          dateSelected = dateSelected.add(
                            Duration(days: 1),
                          );

                          if (widget.dateSelected != null) {
                            widget.dateSelected(dateSelected);
                          }
                        });
                      }
                    }
                  : null,
              onDoubleTap: widget.isEnabled
                  ? () {
                      setState(() {
                        dateSelected = DateTime.now();
                      });

                      if (widget.dateSelected != null) {
                        widget.dateSelected(dateSelected);
                      }
                    }
                  : null,
              child: Row(
                children: <Widget>[
                  Text(
                    'Next',
                    style: TextStyle(
                      fontSize: 10,
                      color: widget.isEnabled ? Colors.white : Colors.grey,
                    ),
                  ),
                  Icon(
                    Icons.arrow_right,
                    color: widget.isEnabled ? Colors.white : Colors.grey,
                  )
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: widget.isEnabled
                  ? () {
                      showDatePicker(
                        context: context,
                        firstDate: DateTime(1984),
                        lastDate: DateTime.now(),
                        initialDate: DateTime.now(),
                      ).then((date) {
                        if (date != null) {
                          setState(() {
                            dateSelected = date;
                          });

                          if (widget.dateSelected != null) {
                            widget.dateSelected(dateSelected);
                          }
                        }
                      });
                    }
                  : null,
              child: Icon(
                Icons.date_range,
                color: widget.isEnabled ? Colors.white : Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
