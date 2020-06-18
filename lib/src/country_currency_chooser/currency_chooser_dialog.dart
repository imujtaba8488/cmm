import 'package:flutter/material.dart';

import 'countries.dart';
import 'country_utils.dart';
import 'country.dart';

typedef CurrencySelection = void Function(Widget flag, String currencyCode);

class CurrencyChooserDialog extends StatefulWidget {
  final CurrencySelection selectedCurrency;
  final bool showFlags;
  final bool showPullToStartFloatingButton;
  final bool showListDividers;
  final Color backgroundColor;
  final Color interfaceColor;
  final Color borderColor;
  final Color pullToStartFloatingButtonColor;

  CurrencyChooserDialog({
    this.selectedCurrency,
    this.showFlags = true,
    this.showPullToStartFloatingButton = true,
    this.showListDividers = true,
    this.backgroundColor,
    this.interfaceColor = Colors.black,
    this.borderColor = Colors.white,
    this.pullToStartFloatingButtonColor = Colors.green,
  });

  @override
  _CurrencyChooserDialogState createState() => _CurrencyChooserDialogState();
}

class _CurrencyChooserDialogState extends State<CurrencyChooserDialog> {
  double _dialogHeight, _dialogWidth;
  ScrollController _scrollController;
  TextEditingController _searchController;
  List<Country> _countries;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _searchController = TextEditingController();
    _countries = sortedCountryList();
  }

  @override
  Widget build(BuildContext context) {
    _dialogHeight = MediaQuery.of(context).size.height / 2.5;
    _dialogWidth = MediaQuery.of(context).size.width / 1.3;

    return Dialog(
      backgroundColor: widget.backgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5.0),
      ),
      child: Container(
        height: _dialogHeight,
        width: _dialogWidth,
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: widget.borderColor,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Stack(
          children: <Widget>[
            _searchField(),
            _countriesList(),
            widget.showPullToStartFloatingButton
                ? _scrollToInitialPositionButton()
                : Container(),
          ],
        ),
      ),
    );
  }

  Positioned _searchField() {
    return Positioned(
      height: 60,
      width: _dialogWidth - 10,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: TextField(
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.search,
              color: widget.interfaceColor,
            ),

            // Shows the clearText icon when something is typed within the search box.
            suffix: _searchController.text.isEmpty
                ? null
                : InkWell(
                    child: Icon(Icons.clear),
                    onTap: () {
                      setState(() {
                        _countries = sortedCountryList();
                        _searchController.clear();
                      });
                    },
                  ),
            labelText: 'Search',
            labelStyle: TextStyle(
              color: widget.interfaceColor,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.interfaceColor,
                width: 0.5,
              ),
            ),
            border: OutlineInputBorder(
              borderSide: BorderSide(
                color: widget.interfaceColor,
              ),
            ),
          ),
          style: TextStyle(color: widget.interfaceColor),
          controller: _searchController,
          onChanged: _onSearch,
        ),
      ),
    );
  }

  Positioned _countriesList() {
    return Positioned(
      top: 60,
      width: _dialogWidth - 15,
      height: _dialogHeight,
      child: Container(
        margin: EdgeInsets.all(5.0),
        child: ListView.builder(
          itemCount: _countries.length,
          controller: _scrollController,
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                if (widget.selectedCurrency != null) {
                  widget.selectedCurrency(
                    CountryUtils.getDefaultFlagImage(_countries[index]),
                    _countries[index].currencyCode,
                  );
                }

                Navigator.pop(context);
              },
              child: Column(
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      widget.showFlags
                          ? CountryUtils.getDefaultFlagImage(_countries[index])
                          : Container(),
                      SizedBox(width: 5.0),
                      Expanded(
                        flex: 2,
                        child: Text(
                          _countries[index].name,
                          style: TextStyle(
                            fontSize: 12,
                            color: widget.interfaceColor,
                          ),
                        ),
                      ),
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: Text(
                            _countries[index].currencyCode,
                            style: TextStyle(
                              color: widget.interfaceColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  widget.showListDividers
                      ? Divider(color: widget.interfaceColor)
                      : Container(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Positioned _scrollToInitialPositionButton() {
    return Positioned(
      top: _dialogHeight - 40,
      left: _dialogWidth - 40,
      child: InkWell(
        child: Container(
          decoration: BoxDecoration(
            color: widget.pullToStartFloatingButtonColor,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.keyboard_arrow_up),
        ),
        onTap: () {
          _scrollController.animateTo(
            _scrollController.initialScrollOffset,
            curve: Curves.bounceIn,
            duration: Duration(seconds: 1),
          );
        },
      ),
    );
  }

  void _onSearch(String value) {
    setState(() {
      if (value.trim().isEmpty) {
        _countries = sortedCountryList();
      } else {
        // <|IMPORTANT|> set countries list back to initial list, so that the next value is searched within the whole list. For example, say you type 'I', countries will be searched for value of 'I', next say you type 'IN', now the countries will be searched for 'IN' instead of 'I', and so on.
        _countries = sortedCountryList();

        // Search for either the country name or the currency code.
        _countries = _countries.where((country) {
          return country.name.startsWith(value.trim()) ||
              country.name
                  .toLowerCase()
                  .startsWith(value.toLowerCase().trim()) ||
              country.currencyCode.startsWith(value.trim()) ||
              country.currencyCode.toLowerCase().startsWith(value.trim());
        }).toList();
      }
    });
  }
}
