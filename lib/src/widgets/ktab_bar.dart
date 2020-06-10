/// Dev File Name: KTab_bar.dart.
/// Final File Name:
/// Production File Name:
/// Start Date: October, 2019
/// Completion Date:
/// Author: iMujtaba Nazki.
/// Version: 1.0.0
/// Version History: (V1 -> ???)
/// Copyright: @IM8488 (2019-20).

import 'package:flutter/material.dart';

import '../widgets/go_family/go_family.dart';
import '../animations/foldable_container.dart';
import '../widgets/replacements/replacements.dart';

/// Note: It is quite possible that a renderflex overflow error might occur, if
///
/// this widget is placed directly within a column/row/list etc. The solution
/// is to specify its height when placed within such containers.
///
/// The standard approach for creating a  tab-bar in Flutter is to wrap any
/// widget within a DefaultTabController (if no custom controller is provided),
/// and then within the body of that wrapped widget, tabs and tabviews are
/// specified separately. This process, may seem cumbersome.
///
/// KTabBar (named to be changed later) tries to refine the process of creating
/// a tab-bar including inserting widgets within individual tabs, a breeze.
///
/// The KTabBar (named to be changed later) contains tabs and the tabs contain
/// widgets, as simple as that.

class KTabBar extends StatefulWidget {
  /// List of tabs within the tab bar.
  final List<KTab> tabs;

  final Color indicatorColor;

  KTabBar({
    this.tabs = const <KTab>[],
    this.indicatorColor = Colors.red,
  });

  @override
  State<StatefulWidget> createState() => _KTabBarState();
}

class _KTabBarState extends State<KTabBar> with SingleTickerProviderStateMixin {
  //...
  // Determines whether the tab bar is folded or unfolded.
  bool isfolded = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // DefaultTabController throws an error, if its length is 0. Hence, if no
    // tabs are added to the DefaultTabController, show 'No Tab' message.
    return widget.tabs.length > 0
        ? DefaultTabController(
            length: widget.tabs.length,
            child: Column(
              children: <Widget>[
                _actionBar,
                _tabBarWithTabs,
                Expanded(
                  child: !isfolded ? _widgetsPackedInTabs : Container(),
                ),
              ],
            ),
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

  /// Returns a Standard TabBar including its tabs. However, the tabs within the
  /// returned standard TabBar do not contain the widgets i.e. TabViews are not
  /// specified, at this stage of the TabBar creation.
  Widget get _tabBarWithTabs {
    return Container(
      // The height of the TabBar tabs.
      height: 20.0,
      child: FoldableContainer(
        requestFold: isfolded,
        child: TabBar(
          labelPadding: EdgeInsets.symmetric(
            horizontal: 5.0,
            vertical: 3.0,
          ),
          indicator: BoxDecoration(
            color: widget.indicatorColor,
          ),
          tabs: widget.tabs,
        ),
      ),
    );
  }

  /// User specifies the widget to be placed within each individual tab as a
  /// child of KTab. This function extracts that widget from the KTab and places
  /// it within its corresponding tab in the Standard TabBar. Following which,
  /// the Standard TabBar is returned to the caller.
  Widget get _widgetsPackedInTabs {
    List<Widget> tabs = [];

    widget.tabs.forEach((tab) {
      tabs.add(
        tab.child,
      );
    });

    return TabBarView(children: tabs);
  }

  // Todo: Add documentation...
  // Todo: Action bar is simply a customization of GoTitledBar.
  Widget get _actionBar {
    return GoTitledBar(
      height: 25.0,
      // Review: Perhaps specifying the text without style causes an error.
      title: Text('testing', style: TextStyle()),

      // Review: Or perhaps the error happens when null buttonBar is specified.
      buttonBar: GoButtonBar(
        buttons: [
          GoIconButton(
            decoration: ResponderDecoration(
              border: Border.all(color: Colors.white, width: 0.5),
              shape: ResponderShape.circle,
            ),
            icon: Icon(
              isfolded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_up,
              size: 12.0,
              color: Colors.white,
            ),
            onPressed: () => setState(
              () => isfolded ? isfolded = false : isfolded = true,
            ),
          ),
        ],
      ),
    );
  }
}

// :::::::::::::::::::::::::::::::: GO TAB :::::::::::::::::::::::::::::::::: //

// <r> The tab which can be added to the GoTabBar.
class KTab extends StatelessWidget {
  final Icon icon;

  final Text title;

  /// The widget that needs to be displayed in the tab.
  final Widget child;

  // Note: In this class, child argument is only used to store the widget. It
  // gets added to the tab in the GoTabBar class.
  KTab({
    this.icon = const Icon(Icons.add),
    this.title = const Text('No Title'),
    this.child = const Center(
      child: Text(
        'No Contents.',
        style: TextStyle(
          color: Colors.grey,
        ),
      ),
    ),
  }) {
    // 'null' value is not acceptible.
    assert(icon != null);
    assert(title != null);
    assert(child != null);
  }

  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Row(
        children: <Widget>[
          AutoFit(
            child: icon,
          ),
          AutoFit(
            child: Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: Text(
                title.data,
                style: title?.style,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
