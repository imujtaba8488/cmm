part of 'go_family.dart';

/// Determines the state i.e. fold-unfold of the section from events outside 
/// this widget.
enum DefaultFoldState {
  fold,
  unfold,
  none,
}

/// Observe: A general-purpose widget, hence, add more features as you go.
///
/// Problem ->  When Section is put within a ListView, it flickers when clicking
/// the content area. This is probably because the ListView rebuilds everytime
/// it receives a click. How should you get around this??? Observe: This 
/// happened because the Section was wrapped inside a RefreshIndicator.
/// 
/// A GoSection organizes your widgets into a section with a header and content.
/// Header defines the contents of the section and the content shows the 
/// contents of the section.
class GoSection extends StatefulWidget {
  /// Typically contains title and fold-unfold button. More buttons can be 
  /// added.
  final GoTitledBar header;

  /// Contents / widget(s) to be shown within the GoSection.
  final Widget content;

  /// Determines whether the section is foldable or not.
  final bool isfoldable;

  final isEnabled;

  /// Controls folding-unfolding from events outside this widget. For example, 
  /// when folding-unfolding using a GoSectionGroup.
  final DefaultFoldState defaultFoldState;

  /// Notifies the listener when the folding-unfolding takes place.
  final FoldListener foldListener;

  final Icon foldButtonIcon, unfoldButtonIcon;

  GoSection({
    @required this.header,
    this.content,
    this.isfoldable = true,
    this.isEnabled = true,
    this.defaultFoldState = DefaultFoldState.none,
    this.foldListener,
    this.foldButtonIcon,
    this.unfoldButtonIcon,
  });

  @override
  State<StatefulWidget> createState() => GoSectionState();

  /// Returns a copy of this Section, with the specific properties altered.
  Widget alteredCopy({
    GoTitledBar header,
    Widget content,
    bool isfoldable,
    bool isEnabled,
    DefaultFoldState defaultFoldState,
    FoldListener foldListener,
    Icon foldButtonIcon,
    Icon unfoldButtonIcon,
  }) =>
      GoSection(
        header: header ?? this.header,
        content: content ?? this.content,
        isfoldable: isfoldable ?? this.isfoldable,
        isEnabled: isEnabled ?? this.isEnabled,
        defaultFoldState: defaultFoldState ?? this.defaultFoldState,
        foldListener: foldListener ?? this.foldListener,
        foldButtonIcon: foldButtonIcon ?? this.foldButtonIcon,
        unfoldButtonIcon: unfoldButtonIcon ?? this.unfoldButtonIcon,
      );
}

class GoSectionState extends State<GoSection> {
  bool isfolded;
  DefaultFoldState defaultFoldState;

  @override
  void initState() {
    super.initState();
    isfolded = false;
    defaultFoldState = widget.defaultFoldState;
  }

  @override 
  void didUpdateWidget(GoSection oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Rebuild when defaultFoldState changes.
    setState(() {
      defaultFoldState = widget.defaultFoldState;
      isfolded = defaultFoldState == DefaultFoldState.fold;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.isEnabled
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _customizedHeader(),
              _content(),
            ],
          )
        : Container();
  }

  /// The header to show within the section.
  Widget _customizedHeader() {
    return GoTitledBar(
      height: widget.header.height,
      leadingIcon: widget.header?.leadingIcon,
      title: widget.header.title,
      decoration: widget.header.decoration,
      padding: widget.header.padding,
      margin: widget.header.margin,
      buttonBar: GoButtonBar(
        height: widget.header?.buttonBar?.height ?? widget.header.height,
        decoration: widget.header?.buttonBar?.decoration,
        buttons: [
          // Mind the spread-op. Notice the '?' operator after the spread-op.
          ...?widget?.header?.buttonBar?.buttons,

          // Show only when the section is foldable.
          if (widget.isfoldable)
            GoIconButton(
              icon: isfolded
                  ? Icon(
                      widget?.unfoldButtonIcon?.icon ??
                          Icons.keyboard_arrow_down,
                      color: widget?.unfoldButtonIcon?.color,
                      size: widget?.unfoldButtonIcon?.size,
                    )
                  : Icon(
                      widget?.foldButtonIcon?.icon ?? Icons.keyboard_arrow_up,
                      color: widget?.foldButtonIcon?.color,
                      size: widget?.foldButtonIcon?.size,
                    ),
              onPressed: _foldUnfold,
            ),
        ],
      ),
    );
  }

  /// The contents to show within the section.
  Widget _content() {
    return FoldableContainer(
      requestFold: isfolded,
      margin: _contentMargin(),
      decoration: _contentDecoration(),

      // Show widget when available else show the 'No Contents' message.
      // Has to be put inside a row, to maintain the section content area.
      // child: widget?.content ?? GoMessage()

      child: Row(
        children: [Flexible(child: widget?.content ?? GoMessage())],
      ),
    );
  }

  // Inverts the fold state, i.e. when folded, it unfolds and vice-versa.
  void _foldUnfold() => setState(() {
        // Invert.
        isfolded = !isfolded;

        // Notify listeners.
        isfolded
            ? widget?.foldListener?._hasFolded(widget)
            : widget?.foldListener?._hasUnfolded(widget);
      });

  /// Review: Add detailed doc
  BoxDecoration _contentDecoration() {
    if (widget.content is Container) {
      Container container = widget.content as Container;
      return container.decoration;
    }
    return null;
  }

  EdgeInsets _contentMargin() {
    if (widget.content is Container) {
      Container container = widget.content as Container;
      return container.margin;
    }
    return null;
  }
}

