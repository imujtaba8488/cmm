part of 'go_family.dart';

/// 1. Can make sections draggable within a SectionGroup. Review:
///
/// Groups the sections together and add options to control all these sections
/// as a whole.
class GoSectionGroup extends StatefulWidget {
  /// Bar along the top of the group, typically shows a title and collapse-expand button.
  final GoTitledBar groupBar;

  /// Margin around the entire group.
  final EdgeInsets margin;

  /// Padding within the entire group.
  final EdgeInsets padding;

  /// Color of the [groupBar] when collapsed.
  final Color collapsedGroupBarColor;

  /// Determines whether the section is collapsable or not.
  final bool isCollapsable;
  final Icon collapseButtonIcon, expandButtonIcon;

  /// Overrides the properties of all the sections within the group as a whole.
  final DecorationOverride overrides;

  /// List of sections within the section group.
  final List<GoSection> sections; 

  GoSectionGroup({
    this.groupBar,
    this.margin,
    this.padding,
    this.collapsedGroupBarColor,  
    this.isCollapsable = true,
    this.collapseButtonIcon,
    this.expandButtonIcon,
    this.overrides,
    this.sections = const <GoSection>[],
  });

  @override
  State<StatefulWidget> createState() {
    return _GoSectionGroupState();
  }
}

class _GoSectionGroupState extends State<GoSectionGroup>
    implements FoldListener {
  bool isCollapsed = false;

  /// List of sections that get collapsed and expanded with time. Collapsed ones
  /// are added to the [sectionsCollapsed] and expanded ones to 
  /// [sectionsExpanded]. If a section was previously in collapsed or expanded 
  /// it is removed from that list accordingly.
  List<GoSection> sectionsCollapsed = [], sectionsExpanded = [];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        widget.isCollapsable
            ? GoTitledBar(
                leadingIcon: widget?.groupBar?.leadingIcon,
                decoration: widget?.groupBar?.decoration,
                title: widget?.groupBar?.title ?? Text('Go Section Group'),
                height: widget?.groupBar?.height,
                padding: widget?.groupBar?.padding,
                margin: widget?.groupBar?.margin,
                buttonBar: GoButtonBar(
                  buttons: [
                    // Notice the '?' operator after the spread-op. It's in 
                    // response to the error message 'The getter iterator was 
                    // called on null'
                    ...?widget?.groupBar?.buttonBar?.buttons,
                    GoIconButton(
                      icon: isCollapsed
                          ? widget.expandButtonIcon ??
                              Icon(
                                Icons.keyboard_arrow_down,
                                color: Colors.white,
                              )
                          : widget.collapseButtonIcon ??
                              Icon(
                                Icons.keyboard_arrow_up,
                                color: Colors.white,
                              ),
                      onPressed: isCollapsed ? _expand : _collapse,
                    ),
                  ],
                ),
              )
            : Container(),

        // Show collapsable sections only when collapsable.
        if (widget.isCollapsable)
          Flexible(
            child: ListView(
              // itemExtent: _collapsableSections,
              children: _collapsableSections,
            ),
          )
        else
          ...widget.sections
      ],
    );
  }

  /// Registers the group as [Foldable] for all the sections provided by the user.
  List<GoSection> get _collapsableSections {
    List<GoSection> cSections = [];

    widget.sections.forEach((section) {
      cSections.add(
        section.alteredCopy(
          header: section.header.alteredCopy(
            height: widget.overrides.height,
            decoration: widget.overrides.decoration,
            title: Text(
              section.header.title.data,
              style: widget.overrides.textStyle,
            ),
          ),
          foldListener: this,
          defaultFoldState:
              isCollapsed ? DefaultFoldState.fold : DefaultFoldState.unfold,
        ),
        // section,
      );
    });

    return cSections;
  }

  /// Folds all sections within a section group.
  void _collapse() {
    setState(() {
      isCollapsed = true;
      sectionsExpanded.clear();
    });
  }

  /// Unfolds all sections within a section group.
  void _expand() {
    setState(() {
      isCollapsed = false;
      sectionsCollapsed.clear();
    });
  }

  /// Fired when a section within the group has collapsed. Objects of this class listen to the change in the fold-  status of Section.
  void _hasFolded(GoSection section) {
    if (sectionsExpanded.contains(section)) sectionsExpanded.remove(section);

    sectionsCollapsed.add(section);

    if (sectionsCollapsed.length == _collapsableSections.length) _collapse();
  }

  /// Fired when a section within the group has expanded.
  void _hasUnfolded(GoSection section) {
    if (sectionsCollapsed.contains(section)) sectionsCollapsed.remove(section);

    sectionsExpanded.add(section);

    if (sectionsExpanded.length == _collapsableSections.length) _expand();
  }
}
