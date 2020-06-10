import 'package:flutter/material.dart';

abstract class NiceCardElement extends StatelessWidget {}

abstract class NiceChip extends StatelessWidget {}

class NiceCard extends StatelessWidget {
  final Function onTap;
  final Color bgColor;
  final BorderRadiusGeometry borderRadius;
  final EdgeInsets margin, padding;
  final List<NiceCardElement> elements;
  final bool enableShadow;

  NiceCard({
    this.onTap,
    this.bgColor = Colors.white,
    this.borderRadius,
    this.margin = const EdgeInsets.all(3.0),
    this.padding = const EdgeInsets.all(3.0),
    this.elements,
    this.enableShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: margin,
        padding: padding,
        decoration: BoxDecoration(
          color: bgColor,
          boxShadow: enableShadow
              ? [
                  BoxShadow(
                    color: Colors.grey.shade600,
                    offset: Offset(0.5, 0.5),
                  )
                ]
              : [],
          borderRadius: borderRadius,
        ),
        child: Column(
          children: _wrappedElements(),
        ),
      ),
    );
  }

  List<Widget> _wrappedElements() {
    List<Widget> wrappedElements = [];

    // Observe the operator '?.' - meaning only run the loop, when elements != null.
    elements?.forEach((element) {
      if (element is BodyElement) {
        wrappedElements.add(
          Expanded(child: element),
        );
      } else {
        wrappedElements.add(element);
      }
    });

    return wrappedElements;
  }
}

// Remember the height of the header is controlled by the size of the leading
/// icon plus a padding of 5px on either size i.e. 10px in total.
class HeaderElement extends NiceCardElement {
  final List<HeaderElementChild> children;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;

  HeaderElement({
    this.children = const <HeaderElementChild>[],
    this.backgroundColor = Colors.orangeAccent,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      child: Row(children: children),
    );
  }
}

class HeaderElementChild extends StatelessWidget {
  final Widget child;
  final bool isExpanded;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;

  HeaderElementChild({
    this.child,
    this.isExpanded = false,
    this.backgroundColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return isExpanded
        ? Expanded(
            child: _fixedHeightChild(),
          )
        : _fixedHeightChild();
  }

  Widget _fixedHeightChild() {
    return Container(
      height: 35.0,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: borderRadius,
      ),
      padding: const EdgeInsets.all(5.0),
      child: Align(
        alignment: Alignment.centerLeft,
        child: child,
      ),
    );
  }
}

class HeaderElementDivider extends HeaderElementChild {
  final double size;

  HeaderElementDivider({this.size = 3.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      width: size,
      color: Colors.white,
    );
  }
}

class BodyElement extends NiceCardElement {
  final Widget child;
  final Color backgroundColor;
  final BorderRadiusGeometry borderRadius;

  BodyElement({
    this.child,
    this.backgroundColor = Colors.cyan,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Container(
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: borderRadius,
          border: Border.fromBorderSide(BorderSide.none),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Only show child when its not null, else show a Container.
            child != null ? child : Container(),
          ],
        ),
      ),
    );
  }
}

class ChipBarElement extends NiceCardElement {
  final List<NiceChip> chips;
  final Color backgroundColor;

  ChipBarElement({
    this.chips = const <NiceChip>[],
    this.backgroundColor = Colors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 25.0,
      color: backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: chips,
      ),
    );
  }
}

class ChipElement extends NiceChip {
  final Widget child;

  ChipElement({
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: child,
      ),
    );
  }
}

class ChipElementDivider extends NiceChip {
  final double size;
  final Color color;

  ChipElementDivider({this.size = 2.0, this.color = Colors.white});

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 30.0,
        width: size,
        padding: EdgeInsets.only(),
        decoration: BoxDecoration(
          color: color,
        ),
        child: Icon(Icons.terrain, size: 2, color: Colors.transparent));
  }
}

class EmptyChipContainer extends NiceChip {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class ElementDivider extends NiceCardElement {
  final bool vertical;
  final double size;
  final Color color;

  ElementDivider({this.vertical = false, this.size = 3.0, this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          right: vertical ? size : 0.0, top: vertical ? 0.0 : size),
      color: color,
    );
  }
}
