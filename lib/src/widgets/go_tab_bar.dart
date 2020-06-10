/// Author: IMujtaba Nazki.
/// Version: 1.0
/// Version History: (V1 -> 17.10.2019)
/// Copyright: @IM8488.

import 'package:flutter/material.dart';

/// Note: It is quite possible that a renderflex overflow error might occur, if
/// this widget is placed directly within a column/row/list etc. The solution is
/// to specify its height when placed within such containers.
///
/// While as, the standard approach of creating a tab-bar in Flutter is to wrap
/// a widget within a DefaultTabController (if no custom available), then within
/// the body of widget specify the tabs and tab-views separately. A process,
/// that might not be simple and straight-forward.
///
/// GoTabBar tries to make the process of creating a tab-bar including inserting
/// contents into the individual tabs a breeze.
///
/// GoTabBar contains tabs and tabs contain widgets, as simple as that.
class GoTabBar extends StatefulWidget {
  // List of tabs within the tab bar.
  final List<GoTab> tabs;

  /// Total height that the tab alongwith it's contents should take on the screen.
  final double height;

  /// Height of an individual tab within the tab bar.
  final double tabHeight;

  //...
  final GoTabActionBar defaultActionBar, actionBar;

  /// Duration of the fold or unfold animation. Defaults to 300 millisecond.
  final Duration foldUnfoldDuration;
  final bool disableAnimation, disableActionBar, disableShadow;
  final Color tabBarColor;
  final Color indicatorColor;

  /// Margin around the entire tab-bar including its contents.
  final EdgeInsets marginAround;

  /// Margin around the tab-bar containing the tabs.
  final EdgeInsets tabBarMargin;

  GoTabBar({
    this.tabs = const <GoTab>[],
    this.height,
    this.tabHeight = 24.0,
    this.defaultActionBar = const GoTabActionBar(),
    this.actionBar,
    this.foldUnfoldDuration = const Duration(milliseconds: 300),
    this.disableAnimation = false,
    this.disableActionBar = false,
    this.disableShadow = false,
    this.indicatorColor = Colors.red,
    this.tabBarColor = Colors.deepPurple,
    this.marginAround = const EdgeInsets.all(0.0),
    this.tabBarMargin = const EdgeInsets.all(0.0),
  }) {
    // When ActionBar is disabled, custom action bar cannot be added.
    assert(
      disableActionBar ? actionBar == null : true,
      'Enable ActionBar to add one.',
    );
  }

  @override
  State<StatefulWidget> createState() => _GoTabBarState();
}

class _GoTabBarState extends State<GoTabBar>
    with SingleTickerProviderStateMixin {
  //...
  // Whether the tab-bar is folded.
  bool isfolded = false;
  AnimationController controller;

  /// Fold-unfold animation of the tab-bar contents and tab-bar.
  Animation contentAnimation, tabBarAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: widget.foldUnfoldDuration,
    )..addListener(() {
        setState(() {});
      });

    tabBarAnimation =
        Tween(begin: widget.tabHeight, end: 0.0).animate(controller);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController throws an error if its length is 0.
    return widget.tabs.length > 0
        ? DefaultTabController(
            length: widget.tabs.length,
            child: _tabBarContainer(),
          )
        : Center(
            child: Text(
              'No tabs.',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          );
  }

  /// Returns a custom container wrapping the standard TabBar widget.
  Widget _tabBarContainer() {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Animation initialized here due to constraints.maxHeight availability.
        contentAnimation = Tween(
          begin: widget?.height ?? constraints.maxHeight,
          end: widget?.actionBar?.height ?? widget.defaultActionBar.height,
        ).animate(controller);

        return Container(
          // When animation is disabled, set height to height if given, else set
          // it to maxHeight. However, when animation is enabled, set the height
          // to animations' value.
          height: widget.disableAnimation
              ? widget?.height ?? constraints.maxHeight
              : contentAnimation.value,

          // Get rid of any margin, when folded.
          margin: isfolded ? EdgeInsets.all(0.0) : widget.marginAround,
          decoration: BoxDecoration(
            color: controller.isAnimating ? Colors.grey.shade300 : Colors.white,
            boxShadow: widget.disableShadow
                ? []
                : widget.tabs.isNotEmpty
                    ? [
                        BoxShadow(
                          color: Colors.grey.shade600,
                        )
                      ]
                    : [],
          ),

          // TabBar including its tabs
          child: Column(
            children: <Widget>[
              tabBarAnimation.status == AnimationStatus.completed
                  ? Container()
                  : _tabBarWithTabs(),
              widget.disableActionBar
                  ? Container()
                  : widget.actionBar != null
                      ? widget.actionBar
                      : _defaultActionBar(),

              // TabViews for the TabBar
              Expanded(
                child: !isfolded ? _widgetsAddedToTabs() : Container(),
              )
            ],
          ),
        );
      },
    );
  }

  // Returns a standard TabBar including its tabs, but without tab contents.
  Widget _tabBarWithTabs() {
    return Container(
      margin: isfolded ? const EdgeInsets.all(0.0) : widget.tabBarMargin,
      height:
          widget.disableAnimation ? widget.tabHeight : tabBarAnimation.value,
      color: widget.tabBarColor,
      child: controller.isAnimating
          ? Container()
          : TabBar(
              labelPadding: EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 3.0,
              ),
              indicator: BoxDecoration(
                color: widget.indicatorColor,
              ),
              tabs: widget.tabs,
            ),
    );
  }

  /// Returns a standard (provided by Flutter) TabBarView.
  /// Effectively, packs the widget provided by the user in the GoTab's "child"
  /// field into the tab's tab-view.
  Widget _widgetsAddedToTabs() {
    List<Widget> tabs = [];

    widget.tabs.forEach((tab) {
      tabs.add(
        isfolded
            ? tab.child
            : Padding(
                padding: EdgeInsets.all(2.0),
                child: tab.child,
              ),
      );
    });

    return TabBarView(children: tabs);
  }

  /// The default action-bar to use, if none is provided or is disabled.
  /// Items within the default action-bar are align towards the right and cannot
  /// be customized, unless the items are wrapped inside a row, maybe.
  ///
  /// Note: The last item in the default action-bar is always the fold-unfold
  /// button. Any other custom items are inserted before the fold-unfold button.
  GoTabActionBar _defaultActionBar() {
    return GoTabActionBar(
      backgroundColor: widget.defaultActionBar?.backgroundColor,
      height: widget.defaultActionBar?.height,
      margin: widget.defaultActionBar?.margin,
      padding: widget.defaultActionBar?.padding,
      items: [
        // Mind hte spread-op - inserts the custom items before the fold-unfold button.
        ...widget.defaultActionBar?.items,

        // Last item is always the fold-unfold button.
        GoTabActionBarItem(
          icon: Icon(
            isfolded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
            size: 12.0,
          ),
          onPressed: () => setState(() => isfolded ? _unfold() : _fold()),
          tooltip: isfolded ? 'Tap to Unfold' : 'Tap to Fold',
        ),
      ],
    );
  }

  /// Actions to take when the fold button is pressed.
  void _fold() {
    controller.reset();
    controller.forward().orCancel;
    isfolded = true;
  }

  /// Actions to take when the unfold button is pressed.
  void _unfold() {
    controller.reverse().then((f) {
      // When unfolding, wait for the reverse animation to complete.
      isfolded = false;
    });
  }
}

// :::::::::::::::::::::::::::::::: GO TAB :::::::::::::::::::::::::::::::::: //

/// Review: The tab which can be added to the GoTabBar.
class GoTab extends StatelessWidget {
  /// Default icon size is 12.0
  final Icon icon;

  /// Default font size is 12.0
  final Text title;

  /// The widget that needs to be displayed in the tab.
  final Widget child;

  // Note: In this class, child argument is only used to store the widget. It
  // gets added to the tab in the GoTabBar class.

  GoTab({
    this.icon = const Icon(Icons.add),
    this.title = const Text('No Title'),
    this.child = const Center(
      child: Text(
        'No Contents.',
        style: TextStyle(
          color: Colors.grey,
          fontSize: 12.0,
        ),
      ),
    ),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Tab(
        child: Row(
          children: <Widget>[
            Tab(
              child: Row(
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Icon(
                      icon.icon,
                      size: icon?.size ?? 12.0,
                      color: icon?.color ?? Colors.white,
                    ),
                  ),

                  // Review: Perhaps, needs to be wrapped within a Text widget
                  // to provide a default fontSize. More precisely with wText.
                  Text(
                    title.data,
                    style: title?.style ?? TextStyle(fontSize: 11.0),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ::::::::::::::::::::::::::: ACTION BAR ::::::::::::::::::::::::::::::::::: //

/// GoTabActionBar represents the area below the tab-bar containing various action buttons.
/// Its default height is set to 14.0
class GoTabActionBar extends StatelessWidget {
  final double height;
  final EdgeInsets margin, padding;
  final List<GoTabActionBarItem> items;
  final Color backgroundColor;

  // What is the utility of a 'const' Constructor ???
  const GoTabActionBar({
    this.height = 14.0,
    this.margin = const EdgeInsets.all(0.0),
    this.padding = const EdgeInsets.all(0.0),
    this.items = const <GoTabActionBarItem>[],
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      margin: margin,
      padding: padding,
      color: backgroundColor != null ? backgroundColor : Colors.grey.shade600,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: items,
      ),
    );
  }
}

// ::::::::::::::::::::::::::: ACTION BAR ITEM :::::::::::::::::::::::::::::: //

class GoTabActionBarItem extends StatelessWidget {
  final Icon icon;
  final Text label;
  final Function onPressed;
  final EdgeInsets itemPadding;
  final String tooltip;

  GoTabActionBarItem({
    this.icon,
    this.label = const Text(''),
    this.onPressed,
    this.itemPadding = const EdgeInsets.symmetric(horizontal: 5.0),
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: itemPadding,
      child: Row(
        children: <Widget>[
          // Review: Perhaps needs a replacement, maybe with wText.
          Text(
            label?.data ?? '',
            style: _textStyle,
          ),
          SizedBox(
            width: 15,
            child: IconButton(
              icon: icon,
              onPressed: onPressed,
              iconSize: 10.0,
              color: Colors.white,
              padding: EdgeInsets.all(0.0),
              alignment: Alignment.centerRight,
              tooltip: tooltip,
            ),
          )
        ],
      ),
    );
  }

  TextStyle get _textStyle {
    return label != null
        ? label.style == null
            ? TextStyle(fontSize: 10.0, color: Colors.white)
            : label.style.copyWith(fontSize: label.style?.fontSize ?? 10.0)
        : null;
  }
}
