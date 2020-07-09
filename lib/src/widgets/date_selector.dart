import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../util/util';

class DateSelector extends StatefulWidget {
  final DateTime currentDate;
  final Function dateSelected;
  final bool isEnabled;
  final bool showNextPreviouslabels;
  final bool showDatePicker;
  final bool showDayLabel;
  final Color buttonColor;
  final Color dateColor;

  DateSelector({
    this.currentDate,
    this.dateSelected,
    this.isEnabled = true,
    this.showNextPreviouslabels = true,
    this.showDatePicker = true,
    this.showDayLabel = true,
    this.buttonColor = Colors.white,
    this.dateColor = Colors.grey,
  });

  @override
  _DateSelectorState createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  DateTime dateSelected;
  Color _buttonColor;
  Color _dateColor;

  @override
  void initState() {
    super.initState();
    dateSelected =
        widget.currentDate != null ? widget.currentDate : DateTime.now();
    _buttonColor = widget.buttonColor;
    _dateColor = widget.dateColor;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        widget.showDayLabel
            ? Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    areDatesEqual(dateSelected, DateTime.now())
                        ? 'TODAY'
                        : areDatesEqual(
                            dateSelected,
                            DateTime.now().subtract(
                              Duration(days: 1),
                            ),
                          )
                            ? 'YESTERDAY'
                            : 'PAST',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                    ),
                  ),
                ),
              )
            : Container(),
        Expanded(
          flex: 2,
          child: FittedBox(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _previousButton(),
                ),
                _date(),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _nextButton(),
                ),
                widget.showDatePicker
                    ? Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _datePicker(),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _previousButton() {
    return InkWell(
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
            color: widget.isEnabled ? _buttonColor : Colors.grey,
          ),
          widget.showNextPreviouslabels
              ? Text(
                  'Previous',
                  style: TextStyle(
                    // fontSize: 10,
                    color: widget.isEnabled ? _buttonColor : Colors.grey,
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget _date() {
    return Text(
      '${DateFormat('dd-MM-yyyy').format(dateSelected)}',
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: _dateColor,
      ),
    );
  }

  Widget _nextButton() {
    return InkWell(
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
          widget.showNextPreviouslabels
              ? Text(
                  'Next',
                  style: TextStyle(
                    // fontSize: 10,
                    color: widget.isEnabled ? _buttonColor : Colors.grey,
                  ),
                )
              : Container(),
          Icon(
            Icons.arrow_right,
            color: widget.isEnabled ? _buttonColor : Colors.grey,
          )
        ],
      ),
    );
  }

  Widget _datePicker() {
    return InkWell(
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
        color: widget.isEnabled ? _buttonColor : Colors.grey,
      ),
    );
  }
}
