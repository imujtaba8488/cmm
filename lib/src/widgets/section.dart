import 'package:flutter/material.dart';

enum FoldState {
  folded,
  unfolded,
}

enum ActionBarAlignment {
  left,
  center,
  right,
}

/// 'backgroundColor' removed, since you can place it inside a Container to give
/// it a color.
///
/// Research: For fold/unfold animation to work I should know the height of the
/// child Container, which at the moment I am setting to the height of the
/// children of the Section, which are automatically fetched at runtime, so I
/// only specify 'null'. See how this work later.
///
/// Observe: Section widget seems a great widget for general-purpose use. Hence,
/// explore means for improving it.
class Section extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget actionChild;
  final List<Widget> actionChildren;
  final Icon infoIcon;
  final Color titleColor;
  final Color dividerColor;
  final bool showDivider;
  final bool showInfoIcon;
  final FoldState foldState;
  final isfoldable;
  final ActionBarAlignment actionBarAlignment;

  Section({
    @required this.title,
    this.child,
    this.actionChild,
    this.actionChildren,
    this.infoIcon = const Icon(Icons.info_outline),
    this.titleColor,
    this.dividerColor,
    this.showDivider = true,
    this.showInfoIcon = true,
    this.foldState = FoldState.unfolded,
    this.isfoldable = true,
    this.actionBarAlignment = ActionBarAlignment.right,
  });

  @override
  State<StatefulWidget> createState() {
    return SectionState();
  }
}

class SectionState extends State<Section> with SingleTickerProviderStateMixin {
  FoldState isfolded;
  double height;

  @override
  void initState() {
    super.initState();
    isfolded = widget.foldState;
  }

  @override
  Widget build(BuildContext context) {
    // Here '56px' is used to display the Section title, action buttons and
    // the horizontal divider. 'Null' specifies use as much height as the
    // children of this Section require. Review: Is 56.0 enough?
    isfolded == FoldState.folded ? height = 56.0 : height = null;

    return Container(
      height: height,

      // When folded, change color to contrast from unfolded state.
      color: isfolded == FoldState.folded ? Colors.grey.shade100 : null,
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          _header(),
          _divider(),
          _child(),
          _actionChildren(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              widget.title,
              style: TextStyle(
                color:
                    widget.titleColor == null ? Colors.grey : widget.titleColor,
                fontSize: 14.0,
              ),
            ),
            widget.showInfoIcon
                ? Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
                    child: Icon(
                      widget.infoIcon.icon,
                      color: Colors.grey.shade400,
                    ),
                  )
                : Container(),
          ],
        ),

        // Only display the fold/unfold button when specified by the user.
        widget.isfoldable
            ? Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: isfolded == FoldState.folded
                    ? _unfoldButton()
                    : _foldButton(),
              )
            : Container(),
      ],
    );
  }

  Widget _divider() {
    return widget.showDivider
        ? Divider(
            color: widget.dividerColor,
          )
        : Container();
  }

  Widget _child() {
    // Show an empty container when this Section is folded.
    return isfolded == FoldState.folded
        ? Container()
        : widget.child != null ? widget.child : Container();
  }

  Row _actionChildren() {
    List<Widget> children;

    // Initalize the list, only if elements not null.
    if (widget.actionChildren != null) {
      children = [];

      if (widget.actionChildren.length > 0) {
        for (int i = 0; i < widget.actionChildren.length; i++) {
          children.add(
            // Note: Height of each actionChild is fixed to 30px.
            Container(
                height: 30,
                padding: EdgeInsets.all(3.0),
                child: widget.actionChildren[i]),
          );
        }
      }
    }

    // A blank row is returned, either when the Section is folded or no actionChild
    // exists. Research: Like a Container, blank row occupies no space. Does it?
    return isfolded == FoldState.folded
        ? Row()
        : Row(
            mainAxisAlignment:
                widget.actionBarAlignment == ActionBarAlignment.left
                    ? MainAxisAlignment.start
                    : widget.actionBarAlignment == ActionBarAlignment.center
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.end,
            children: children != null ? children : [],
          );
  }

  Widget _foldButton() {
    return _customButton(
      Icon(Icons.keyboard_arrow_up),
      _fold,
      tooltip: 'Tap to fold',
    );
  }

  Widget _unfoldButton() {
    return _customButton(
      Icon(
        Icons.keyboard_arrow_down,
      ),
      _unfold,
      tooltip: 'Tap to Unfold',
    );
  }

  Widget _customButton(
    Icon icon,
    Function onPressed, {
    String text = '',
    String tooltip = '',
  }) {
    bool showTooltip = tooltip.isNotEmpty ? true : false;

    return InkWell(
      onTap: onPressed,
      child: Row(
        children: <Widget>[
          Text(
            text,
            style: TextStyle(
              fontSize: 14.0,
              color: Colors.grey.shade400,
            ),
          ),

          // Wrap within a tooltip only if the tooltip is not empty.
          showTooltip
              ? Tooltip(
                  message: tooltip,
                  child: Icon(
                    icon.icon,
                    color: Colors.grey.shade400,
                  ),
                )
              : Icon(
                  icon.icon,
                  color: Colors.grey.shade400,
                ),
        ],
      ),
    );
  }

  void _fold() {
    setState(() {
      isfolded = FoldState.folded;
    });
  }

  void _unfold() {
    setState(
      () {
        isfolded = FoldState.unfolded;
      },
    );
  }
}
